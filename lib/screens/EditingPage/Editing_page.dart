import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tex/flutter_tex.dart';

class EditingPage extends StatefulWidget {
  final Map<String, dynamic>? questionDetails;
  final int questionIndex;
  final bool isNewQuestion;
  final String folderName;

  const EditingPage({
    Key? key,
    required this.questionIndex,
    this.questionDetails,
    required this.isNewQuestion,
    required this.folderName,
  }) : super(key: key);

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController mathTypeController = TextEditingController();
  String? imageUrl;
  Uint8List? _imageBytes;
  bool imagePicked = false;

  @override
  void initState() {
    super.initState();
    // Set initial values for editing existing question

    if (widget.questionDetails != null) {
      questionController.text = widget.questionDetails!['question'];
      answerController.text = widget.questionDetails!['answer'].toString();
      mathTypeController.text = widget.questionDetails!['math_type'];
      imageUrl = widget.questionDetails!['image_url'];
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    mathTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // ElevatedButton(
          //   onPressed: () {
          //     print(widget.folderName +
          //         '_Image_' +
          //         widget.questionIndex.toString());
          //
          //     // Reference referenceImageToUpload = referenceDirImage.child(fileName);
          //   },
          //   child: Text('Test'),
          // ),
          SizedBox(width: 8),
          ElevatedButton(
            style: imagePicked != true? ButtonStyle() :ButtonStyle(backgroundColor:
            MaterialStateProperty
                .all<Color>(Colors.green)),
            onPressed: imagePicked != true?_pickAndPreviewImage: _uploadImage,
            child: imagePicked != true? Text('Pick Image') :Text('Click '
                'to Upload Image'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async => await _deleteImage(context),
            child: Text('Delete Image'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _updateData(widget.questionIndex, imageUrl);
              Navigator.pop(
                  context); // Return to the previous screen after updating
            },
            child: Text(widget.isNewQuestion == true
                ? 'Add Question'
                : 'Update Question'),
          ),
          SizedBox(width: 8),
        ],
        title: Text(
          widget.isNewQuestion == true ? 'Add New Question' : 'Edit Question',
        ),
      ),
      body: Row(
        children: [
          // Editing Section
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  buildQuestionTextFIeld(),
                  SizedBox(height: 16),
                  buildAnswerTextField(),
                  SizedBox(height: 16),
                  buildMathTypeTextField(),
                ],
              ),
            ),
          ),
          // Output Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TeXView(
                    renderingEngine: TeXViewRenderingEngine.katex(),
                    child: TeXViewColumn(
                      children: [
                        TeXViewDocument(
                          questionController.text,
                          style: TeXViewStyle(
                            contentColor: Colors.blue,
                          ),
                        ),
                        TeXViewDocument(
                          answerController.text,
                          style: TeXViewStyle(
                            margin: TeXViewMargin.only(top: 16),
                            contentColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ), // Updated text
                  SizedBox(height: 8),
                  Text(
                    'Math Type: ${mathTypeController.text}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 4),
                  widget.isNewQuestion == true
                      ? SizedBox.shrink()
                      : Text(
                          'Timestamp: ${widget.questionDetails?['date_updated']}',
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(fontSize: 12, color: Colors.blueGrey),
                        ),
                  SizedBox(height: 16),
                  if (_imageBytes != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.memory(
                        _imageBytes!,
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (imageUrl != null)
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.no_photography),
                      ),
                    ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteImage(BuildContext context) async {
    if (imageUrl != null)
      try {
        // Create a Reference object for the image in storage
        Reference imageReference =
            FirebaseStorage.instance.refFromURL(imageUrl!);

        // Delete the image
        await imageReference.delete();
        // Show Toast
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          elevation: 2,
          backgroundColor: Colors.black12,
          content: Center(
            child: Text(
              "Image Deleted Successfully",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
        print('Image deleted successfully!');
      } catch (error) {
        print('Error deleting image: $error');
      }
  }

  Future<void> _pickAndPreviewImage() async {
    FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
      _imageBytes = result.files.first.bytes;
      imagePicked = true;
    });
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return null;

    String fileName =
        widget.folderName + '_Image_' + widget.questionIndex.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child(widget.folderName);
    Reference referenceImageToUpload = referenceDirImage.child(fileName);

    try {
      await referenceImageToUpload.putData(_imageBytes!);
      String downloadURL = await referenceImageToUpload.getDownloadURL();
      print(downloadURL);
      imageUrl = downloadURL;
      // Show Toast
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        elevation: 2,
        backgroundColor: Colors.black12,
        content: Center(
          child: Text(
            "Image Uploaded as: $fileName",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ));
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }

  Future<void> _updateData(int questionIndex, String? imageUrl) async {
    try {
      // Update the timestamp before saving
      final Map<String, dynamic> data = {
        'question': questionController.text,
        'answer': answerController.text,
        'math_type': mathTypeController.text,
        'date_updated': DateTime.now().toLocal().toString(),
        'image_url': imageUrl,
      };

      DatabaseReference _databaseReference = FirebaseDatabase.instance
          .ref()
          .child("physics_1st_paper")
          .child("chapter_1_math_questions")
          .child(questionIndex.toString());

      if (widget.isNewQuestion == true) {
        print('Data add');
        // Adding a new question
        await _databaseReference.set(data);
        print('Data Added Successfully!');
      } else {
        print('Data edit');
        // Updating an existing question
        await _databaseReference.update(data);
        print('Data Updated Successfully!');
      }
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  TextField buildMathTypeTextField() {
    return TextField(
      controller: mathTypeController,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.black12,
        hintText: 'Math Type',
      ),
      onChanged: (_) {
        // Update the output section when the text changes
        setState(() {});
      },
    );
  }

  SizedBox buildAnswerTextField() {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: TextField(
        expands: true,
        maxLines: null,
        controller: answerController,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.black12,
          hintText: 'Type your answer here',
          contentPadding: EdgeInsets.symmetric(
              vertical: 15.0, horizontal: 10.0), // Adjust padding as needed
        ),
        onChanged: (_) {
          // setState helps update text in realtime
          setState(() {});
        },
      ),
    );
  }

  SizedBox buildQuestionTextFIeld() {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: TextField(
        expands: true,
        maxLines: null,
        controller: questionController,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.black12,
          hintText: 'Type your question here',
          contentPadding: EdgeInsets.symmetric(
              vertical: 15.0, horizontal: 10.0), // Adjust padding as needed
        ),
        onChanged: (_) {
          // setState helps update text in realtime
          setState(() {});
        },
      ),
    );
  }
}
