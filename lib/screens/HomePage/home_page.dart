import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../responsive.dart';
import 'question_card_list.dart';
import '../Drawer/drawer.dart';

class HomePage extends StatelessWidget {
  final String questionsChapter;

  HomePage({Key? key, required this.questionsChapter})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CANDELA',
          style: GoogleFonts.caesarDressing(
              fontSize: 20, fontWeight: FontWeight.w900, color: Colors.amber),
        ),
      ),
      // key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideDrawer(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideDrawer(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: QuestionCardList(questionsChapter: questionsChapter),
            ),
          ],
        ),
      ),
    );
  }
}
