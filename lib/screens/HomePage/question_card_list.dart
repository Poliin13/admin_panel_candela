import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../EditingPage/Editing_page.dart';

class QuestionCardList extends StatelessWidget {
  final String questionsChapter;

  QuestionCardList({Key? key, required this.questionsChapter})
      : super(key: key);

  int newQuestionIndex = 0;
  String folderName = '';
  DatabaseReference dataRef =
      FirebaseDatabase.instance.ref().child("physics_1st_paper");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingButton(
          newQuestionIndex: newQuestionIndex, folderName: folderName),
      body: StreamBuilder(
        stream: dataRef.child(questionsChapter).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No question items available.'));
          } else {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            //get the folder name for image folder
            folderName = dataSnapshot.key!;
            //Add items to list
            List<Map<String, dynamic>> questionItems =
                (dataSnapshot.value as List<dynamic>)
                    .cast<Map<String, dynamic>>();
            //for adding new item to the list this value is needed
            newQuestionIndex = questionItems.length;
            return ListView.builder(
              itemCount: questionItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onPress(context, questionItems, index),
                  onLongPress: () => onLongPressFunction(
                      context, questionItems[index]['image_url'], index),
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      trailing: questionItems[index]['image_url'] == null
                          ? SizedBox.shrink()
                          : Container(
                              height: double.infinity,
                              width: 150,
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: questionItems[index]['image_url']!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.no_photography),
                                ),
                              ),
                            ),
                      title: Text(
                        '${questionItems[index]['question']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Adjust the color as needed
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  8), // Add spacing between question and other items
                          Text(
                            '${questionItems[index]['answer']}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Math Type: '
                                      '${questionItems[index]['math_type']}, ' +
                                  'Date Updated : ${questionItems[index]['date_updated']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void onPress(BuildContext context, List<Map<String, dynamic>> questionItems,
      int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingPage(
          folderName: folderName,
          questionDetails: questionItems[index],
          questionIndex: index,
          isNewQuestion: false,
        ),
      ),
    );
  }

  void onLongPressFunction(BuildContext context, String imageUrl, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Question'),
          content: Text('Delete option disabled, please edit the question.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the deleteQuestion function with the index
                //problem
                // await deleteQuestion(index);
                await deleteImage(imageUrl);
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteQuestion(int index) async {
    DatabaseReference itemReference = FirebaseDatabase.instance
        .ref()
        .child("physics_1st_paper")
        .child("chapter_1_math_questions")
        .child(index.toString());

    try {
      // Remove the item from the database
      await itemReference.remove();
      //this command sets the list item to be null rather removing it
      print('Item deleted successfully.');
    } catch (error) {
      print('Error deleting item: $error');
      // Handle the error as needed
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Create a Reference object for the image in storage
      Reference imageReference = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the image
      await imageReference.delete();

      print('Image deleted successfully!');
    } catch (error) {
      print('Error deleting image: $error');
    }
  }
}

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    super.key,
    required this.newQuestionIndex,
    required this.folderName,
  });

  final int newQuestionIndex;
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0), // Adjust the padding as needed
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditingPage(
                questionIndex: newQuestionIndex,
                isNewQuestion: true, folderName: folderName, // Pass -1 to
                // indicate a
                // new
                // question
              ),
            ),
          );
          // Handle adding a new question
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.add),
        ),
        tooltip: 'Add New Question',
        heroTag: 'addQuestionButton',
      ),
    );
  }
}
