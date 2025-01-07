import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../EditingPage/editing_page.dart';

class QuestionCardList extends StatelessWidget {
  final String chapterName;
  final String jsonNode;
  final DatabaseReference dataRef;
  int newQuestionIndex = 0;

  QuestionCardList({
    Key? key,
    required this.chapterName,
    required this.jsonNode,
  })  : dataRef = FirebaseDatabase.instance.ref().child(jsonNode),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () => _addNewQuestion(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.add),
          ),
          tooltip: 'Add New Question',
          heroTag: 'addQuestionButton',
          backgroundColor: Colors.blueAccent,
        ),
      ),
      body: StreamBuilder(
        stream: dataRef.child(chapterName).onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return Center(
                child: Text('No question items available.',
                    style: TextStyle(color: Colors.white)));
          } else {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            String folderName = dataSnapshot.key!;
            List<dynamic> questionItemsList =
                dataSnapshot.value as List<dynamic>;
            List<Map<String, dynamic>> questionItems = questionItemsList
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            newQuestionIndex = questionItems.length;

            return ListView.separated(
              itemCount: questionItems.length,
              itemBuilder: (context, index) => _buildQuestionItem(
                context,
                questionItems,
                index,
                folderName,
              ),
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.white),
            );
          }
        },
      ),
    );
  }

  Widget _buildQuestionItem(
    BuildContext context,
    List<Map<String, dynamic>> questionItems,
    int index,
    String folderName,
  ) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              questionItems[index]['question'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              questionItems[index]['date_updated'],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      onTap: () => _onPress(context, questionItems, index, folderName),
      onLongPress: () => _onLongPressFunction(context),
    );
  }

  void _onPress(BuildContext context, List<Map<String, dynamic>> questionItems,
      int index, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingPage(
          chapterName: chapterName,
          questionDetails: questionItems[index],
          questionIndex: index,
          isNewQuestion: false,
          jsonNode: jsonNode, // Pass jsonNode to EditingPage
        ),
      ),
    );
  }

  void _onLongPressFunction(BuildContext context) {
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
          ],
        );
      },
    );
  }

  void _addNewQuestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditingPage(
          questionIndex: newQuestionIndex,
          isNewQuestion: true,
          chapterName: chapterName,
          jsonNode: jsonNode, // Pass jsonNode to EditingPage
        ),
      ),
    );
  }
}
