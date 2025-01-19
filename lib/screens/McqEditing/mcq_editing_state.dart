import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

final mcqEditingStateProvider =
    ChangeNotifierProvider.family<McqEditingState, Map<String, dynamic>?>(
        (ref, mcqDetails) {
  return McqEditingState(mcqDetails);
});

class McqEditingState extends ChangeNotifier {
  final TextEditingController mcqQuestionController;
  final TextEditingController option1Controller;
  final TextEditingController option2Controller;
  final TextEditingController option3Controller;
  final TextEditingController option4Controller;
  final TextEditingController mcqAnswerController;
  String? imageUrl;
  late String initialMcqQuestion;
  late String initialOption1;
  late String initialOption2;
  late String initialOption3;
  late String initialOption4;
  late String initialMcqAnswer;

  McqEditingState(Map<String, dynamic>? mcqDetails)
      : mcqQuestionController = TextEditingController(),
        option1Controller = TextEditingController(),
        option2Controller = TextEditingController(),
        option3Controller = TextEditingController(),
        option4Controller = TextEditingController(),
        mcqAnswerController = TextEditingController() {
    if (mcqDetails != null) {
      mcqQuestionController.text = mcqDetails['mcqQuestion'];
      option1Controller.text = mcqDetails['option1'].toString();
      option2Controller.text = mcqDetails['option2'].toString();
      option3Controller.text = mcqDetails['option3'].toString();
      option4Controller.text = mcqDetails['option4'].toString();
      mcqAnswerController.text = mcqDetails['mcqAnswer'].toString();
      imageUrl = mcqDetails['imageLink'];
      initialMcqQuestion = mcqDetails['mcqQuestion'];
      initialOption1 = mcqDetails['option1'];
      initialOption2 = mcqDetails['option2'];
      initialOption3 = mcqDetails['option3'];
      initialOption4 = mcqDetails['option4'];
      initialMcqAnswer = mcqDetails['mcqAnswer'];
    } else {
      initialMcqQuestion = "";
      initialOption1 = "";
      initialOption2 = "";
      initialOption3 = "";
      initialOption4 = "";
      initialMcqAnswer = "";
    }

    // Adding listeners to update in real-time
    mcqQuestionController.addListener(notifyListeners);
    option1Controller.addListener(notifyListeners);
    option2Controller.addListener(notifyListeners);
    option3Controller.addListener(notifyListeners);
    option4Controller.addListener(notifyListeners);
    mcqAnswerController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    mcqQuestionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
    mcqAnswerController.dispose();
    super.dispose();
  }

  bool hasChanges() {
    return mcqQuestionController.text != initialMcqQuestion ||
        option1Controller.text != initialOption1 ||
        option2Controller.text != initialOption2 ||
        option3Controller.text != initialOption3 ||
        option4Controller.text != initialOption4 ||
        mcqAnswerController.text != initialMcqAnswer;
  }

  Future<String?> uploadImage(BuildContext context, String folderName,
      int mcqIndex, bool isNewMcq, String jsonNode) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    print('File picker result: $result');

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileExtension = result.files.first.extension;
      final fileName = '${folderName}_Image_$mcqIndex.$fileExtension';
      final referenceImageToUpload =
          FirebaseStorage.instance.ref().child(folderName).child(fileName);

      try {
        if (fileBytes != null) {
          print('Uploading file: $fileName');
          await referenceImageToUpload.putData(
            fileBytes!,
            SettableMetadata(contentType: 'image/$fileExtension'),
          );
          final imageUrl = await referenceImageToUpload.getDownloadURL();
          print('Image URL: $imageUrl');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 2,
              backgroundColor: Colors.black12,
              content: Center(
                child: Text(
                  "Image Uploaded as: $fileName",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );

          // Update the Realtime Database with the new image URL
          await updateOrAddData(jsonNode, folderName, mcqIndex, isNewMcq);
          this.imageUrl = imageUrl;
          notifyListeners();
          print('Image URL updated in Realtime Database.');
          return imageUrl;
        }
      } catch (error) {
        print('Error uploading image: $error');
      }
    } else {
      print('No file selected');
    }
    return null;
  }

  Future<void> deleteImage(BuildContext context, String folderName,
      int mcqIndex, bool isNewMcq, String jsonNode) async {
    if (imageUrl != null) {
      try {
        print('Attempting to delete image: $imageUrl');

        Reference imageReference =
            FirebaseStorage.instance.refFromURL(imageUrl!);
        await imageReference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 2,
            backgroundColor: Colors.black12,
            content: Center(
              child: Text(
                "Image Deleted Successfully",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        print('Image deleted successfully!');

        // Update the Realtime Database to remove the image URL
        await updateOrAddData(jsonNode, folderName, mcqIndex, isNewMcq);
        this.imageUrl = null;
        notifyListeners();
        print('Image URL removed from Realtime Database.');
      } catch (error) {
        print('Error deleting image: $error');
      }
    } else {
      print('No image URL provided');
    }
  }

  Future<void> updateOrAddData(
      String jsonNode, String folderName, int mcqIndex, bool isNewMcq) async {
    final data = {
      'mcqQuestion': mcqQuestionController.text,
      'option1': option1Controller.text,
      'option2': option2Controller.text,
      'option3': option3Controller.text,
      'option4': option4Controller.text,
      'mcqAnswer': mcqAnswerController.text,
      'date_updated': DateTime.now().toLocal().toString(),
      'imageLink': imageUrl,
    };

    final _databaseReference = FirebaseDatabase.instance
        .ref()
        .child(jsonNode)
        .child(folderName)
        .child(mcqIndex.toString());

    try {
      if (isNewMcq) {
        await _databaseReference.set(data);
        print('Data Added Successfully!');
      } else {
        await _databaseReference.update(data);
        print('Data Updated Successfully!');
      }
    } catch (error) {
      print('Error updating data: $error');
    }
  }
}
