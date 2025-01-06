import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'helper_functions.dart';
import '../HomePage/vertical_split_view.dart';
import 'package:intl/intl.dart';

class EditingPage extends StatefulWidget {
  final Map<String, dynamic>? questionDetails;
  final int questionIndex;
  final bool isNewQuestion;
  final String chapterName;

  const EditingPage({
    Key? key,
    required this.questionIndex,
    this.questionDetails,
    required this.isNewQuestion,
    required this.chapterName,
  }) : super(key: key);

  @override
  _EditingPageState createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  String? imageUrl;
  late String initialQuestion;
  late String initialAnswer;

  @override
  void initState() {
    super.initState();
    if (widget.questionDetails != null) {
      questionController.text = widget.questionDetails!['question'];
      answerController.text = widget.questionDetails!['answer'].toString();
      imageUrl = widget.questionDetails!['image_url'];
      initialQuestion = widget.questionDetails!['question'];
      initialAnswer = widget.questionDetails!['answer'].toString();
    } else {
      initialQuestion = "";
      initialAnswer = "";
    }

    // Adding listeners to update the TeXView in real-time
    questionController.addListener(() {
      setState(() {});
    });
    answerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNewQuestion ? 'Add New Question' : 'Edit Question'),
        ),
        body: HorizontalSplitView(
          ratio: .6,
          left: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type your question here',
                    questionController,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 4,
                  child: buildTextField(
                    'Type your answer here',
                    answerController,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          right: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TeXView(
                  child: TeXViewColumn(
                    children: [
                      TeXViewDocument(
                        questionController.text,
                        style: TeXViewStyle(contentColor: Colors.blue),
                      ),
                      TeXViewDocument(
                        answerController.text,
                        style: TeXViewStyle(
                          margin: TeXViewMargin.only(top: 16),
                          contentColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (imageUrl != null)
                  Center(
                    child: Image.network(
                      imageUrl!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image URL: $imageUrl');
                        print('Error loading image: $error');
                        return Column(
                          children: [
                            Icon(Icons.no_photography),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                SizedBox(height: 4),
                if (!widget.isNewQuestion)
                  Text(
                    'Last Edit: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.questionDetails?['date_updated']))}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                final url = await uploadImage(
                    context,
                    widget.chapterName,
                    widget.questionIndex,
                    questionController,
                    answerController,
                    widget.isNewQuestion);
                if (url != null) {
                  setState(() {
                    imageUrl = url;
                  });
                }
              },
              tooltip: 'Pick and Upload Image',
              child: Icon(Icons.image),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                await deleteImage(context, imageUrl, widget.questionIndex,
                    questionController, answerController, widget.isNewQuestion);
                setState(() {
                  imageUrl = null;
                });
              },
              tooltip: 'Delete Image',
              child: Icon(Icons.delete),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () {
                updateOrAddData(widget.questionIndex, imageUrl, widget.isNewQuestion,
                    questionController, answerController);
                Navigator.pop(context);
              },
              tooltip: widget.isNewQuestion ? 'Add Question' : 'Update Question',
              child: Icon(widget.isNewQuestion ? Icons.add : Icons.update),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      expands: true,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.black12,
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 10.0,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Check if there are any changes
    if (questionController.text != initialQuestion ||
        answerController.text != initialAnswer) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to update the question before leaving?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    updateOrAddData(
                      widget.questionIndex,
                      imageUrl,
                      widget.isNewQuestion,
                      questionController,
                      answerController,
                    );
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }
}
