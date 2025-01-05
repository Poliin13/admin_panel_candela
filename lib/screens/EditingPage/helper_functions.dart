import 'dart:io'; // Import dart:io for File
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<String?> uploadImage(
    BuildContext context,
    String folderName,
    int questionIndex,
    TextEditingController questionController,
    TextEditingController answerController,
    bool isNewQuestion) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
  );

  print('File picker result: $result');

  if (result != null && result.files.isNotEmpty) {
    final fileBytes = result.files.first.bytes;
    final fileExtension = result.files.first.extension; // Extract file extension
    final fileName =
        '${folderName}_Image_$questionIndex.$fileExtension'; // Append file extension to filename
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
        await updateOrAddData(
            questionIndex, imageUrl, isNewQuestion, questionController, answerController);
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

Future<void> deleteImage(
    BuildContext context,
    String? imageUrl,
    int questionIndex,
    TextEditingController questionController,
    TextEditingController answerController,
    bool isNewQuestion) async {
  if (imageUrl != null) {
    try {
      print('Attempting to delete image: $imageUrl');

      Reference imageReference = FirebaseStorage.instance.refFromURL(imageUrl);
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
      await updateOrAddData(
          questionIndex, null, isNewQuestion, questionController, answerController);
      print('Image URL removed from Realtime Database.');
    } catch (error) {
      print('Error deleting image: $error');
    }
  } else {
    print('No image URL provided');
  }
}

Future<void> updateOrAddData(
    int questionIndex,
    String? imageUrl,
    bool isNewQuestion,
    TextEditingController questionController,
    TextEditingController answerController) async {
  final data = {
    'question': questionController.text,
    'answer': answerController.text,
    'date_updated': DateTime.now().toLocal().toString(),
    'image_url': imageUrl,
  };

  final _databaseReference = FirebaseDatabase.instance
      .ref()
      .child("physics_1st_paper")
      .child("chapter_1_math")
      .child(questionIndex.toString());

  try {
    if (isNewQuestion) {
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
