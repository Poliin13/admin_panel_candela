import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../HomePage/vertical_split_view.dart';
import 'package:intl/intl.dart';
import 'mcq_editing_state.dart';

class McqEditingPage extends ConsumerWidget {
  final Map<String, dynamic>? mcqDetails;
  final int mcqIndex;
  final bool isNewMcq;
  final String chapterName;
  final String jsonNode;

  const McqEditingPage({
    Key? key,
    required this.mcqIndex,
    this.mcqDetails,
    required this.isNewMcq,
    required this.chapterName,
    required this.jsonNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mcqEditingState = ref.watch(mcqEditingStateProvider(mcqDetails));

    return WillPopScope(
      onWillPop: () async {
        if (mcqEditingState.hasChanges()) {
          return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to update the MCQ before leaving?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        mcqEditingState.updateOrAddData(
                            jsonNode, chapterName, mcqIndex, isNewMcq);
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
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNewMcq ? 'Add New MCQ' : 'Edit MCQ'),
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
                    'Type your MCQ question here',
                    mcqEditingState.mcqQuestionController,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type option 1 here',
                    mcqEditingState.option1Controller,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type option 2 here',
                    mcqEditingState.option2Controller,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type option 3 here',
                    mcqEditingState.option3Controller,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type option 4 here',
                    mcqEditingState.option4Controller,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  flex: 1,
                  child: buildTextField(
                    'Type the correct answer here',
                    mcqEditingState.mcqAnswerController,
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
                        mcqEditingState.mcqQuestionController.text,
                        style: TeXViewStyle(contentColor: Colors.blue),
                      ),
                      TeXViewDocument(
                        mcqEditingState.option1Controller.text,
                        style: TeXViewStyle(contentColor: Colors.black),
                      ),
                      TeXViewDocument(
                        mcqEditingState.option2Controller.text,
                        style: TeXViewStyle(contentColor: Colors.black),
                      ),
                      TeXViewDocument(
                        mcqEditingState.option3Controller.text,
                        style: TeXViewStyle(contentColor: Colors.black),
                      ),
                      TeXViewDocument(
                        mcqEditingState.option4Controller.text,
                        style: TeXViewStyle(contentColor: Colors.black),
                      ),
                      TeXViewDocument(
                        mcqEditingState.mcqAnswerController.text,
                        style: TeXViewStyle(
                          margin: TeXViewMargin.only(top: 16),
                          contentColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (mcqEditingState.imageUrl != null)
                  Center(
                    child: Image.network(
                      mcqEditingState.imageUrl!,
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
                        print('Image URL: ${mcqEditingState.imageUrl}');
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
                if (!isNewMcq && mcqDetails?['date_updated'] != null)
                  Text(
                    'Last Edit: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(mcqDetails!['date_updated']))}',
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
                final url = await mcqEditingState.uploadImage(
                  context,
                  chapterName,
                  mcqIndex,
                  isNewMcq,
                  jsonNode,
                );
                if (url != null) {
                  mcqEditingState.imageUrl = url;
                }
              },
              tooltip: 'Pick and Upload Image',
              child: Icon(Icons.image),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                await mcqEditingState.deleteImage(
                  context,
                  chapterName,
                  mcqIndex,
                  isNewMcq,
                  jsonNode,
                );
                mcqEditingState.imageUrl = null;
              },
              tooltip: 'Delete Image',
              child: Icon(Icons.delete),
            ),
            SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () {
                mcqEditingState.updateOrAddData(
                  jsonNode,
                  chapterName,
                  mcqIndex,
                  isNewMcq,
                );
                Navigator.pop(context);
              },
              tooltip: isNewMcq ? 'Add MCQ' : 'Update MCQ',
              child: Icon(isNewMcq ? Icons.add : Icons.update),
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
}
