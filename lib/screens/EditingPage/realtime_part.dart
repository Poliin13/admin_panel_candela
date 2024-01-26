// import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
//
// import 'Editing_page.dart';
//
// class RealtimeDisplayWidget extends StatelessWidget {
//   const RealtimeDisplayWidget({
//     super.key,
//     required this.questionController,
//     required this.quillQuestionController,
//     required this.quillAnswerController,
//     required this.answerController,
//     required this.mathTypeController,
//     required this.widget,
//   });
//
//   final TextEditingController questionController;
//   final QuillEditorController quillQuestionController;
//   final QuillEditorController quillAnswerController;
//   final TextEditingController answerController;
//   final TextEditingController mathTypeController;
//   final QuestionDetailsPage widget;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             SizedBox(height: 16),
//             //need to use Tex column
//             FutureBuilder<String>(
//               future: quillQuestionController.getPlainText(),
//               builder: (context, snapshot) => InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: 'Question', // Updated label text
//                   border: OutlineInputBorder(),
//                   contentPadding: EdgeInsets.symmetric(
//                       vertical: 15.0,
//                       horizontal: 10.0), // Adjust padding as needed
//                 ),
//                 child: TeXView(
//                   renderingEngine: TeXViewRenderingEngine.katex(),
//                   child: TeXViewDocument(
//                     snapshot.data ?? '',
//                     style: TeXViewStyle(
//                       contentColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               // Text('Output Text: ${snapshot.data ?? ''}'),
//             ),
//             SizedBox(height: 16),
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: 'Answer', // Updated label text
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(
//                     vertical: 15.0,
//                     horizontal: 10.0), // Adjust padding as needed
//               ),
//               child: Text(
//                 answerController.text,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ), // Updated text
//             SizedBox(height: 16),
//             InputDecorator(
//               decoration: InputDecoration(
//                 labelText: 'MathType', // Updated label text
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(
//                     vertical: 15.0,
//                     horizontal: 10.0), // Adjust padding as needed
//               ),
//               child: Text(
//                 mathTypeController.text,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             // Updated text
//             SizedBox(height: 16),
//             widget.isNewQuestion == true
//                 ? SizedBox.shrink()
//                 : Text(
//                     'Timestamp :  ${widget.questionDetails?['date_updated']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// String texString = r"<h4>Quadratic Equation</h4>" +
//     r"""
//      When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
//      $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$<br>""";
