
import 'dart:typed_data';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload and Display'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                String? url = await pushImage();
                if (url != null) {
                  setState(() {
                    imageUrl = url;
                  });
                }
              },
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            if (imageUrl != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDisplay(imageUrl: imageUrl!),
                    ),
                  );
                },
                child: Text('Display Image'),
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> pushImage() async {
    FilePickerResult? result = await FilePickerWeb.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;

    Uint8List fileBytes = result.files.first.bytes!;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('images');
    Reference referenceImageToUpload =
        referenceDirImage.child(fileName);

    try {
      await referenceImageToUpload.putData(fileBytes);
      String downloadURL = await referenceImageToUpload.getDownloadURL();
      print(downloadURL);
      return downloadURL;
    } catch (error) {
      print('Error uploading image: $error');
      return null;
    }
  }
}

class ImageDisplay extends StatelessWidget {
  final String imageUrl;

  ImageDisplay({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Display'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
