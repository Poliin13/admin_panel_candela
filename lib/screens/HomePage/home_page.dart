import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../responsive.dart';
import 'question_card_list.dart';
import '../Drawer/drawer.dart';

class HomePage extends StatelessWidget {
  final String chapterName;
  const HomePage({Key? key, required this.chapterName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isDesktop, // Remove drawer icon on desktop
        title: Text(
          'CANDELA',
          style: GoogleFonts.caesarDressing(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.amber,
          ),
        ),
      ),
      drawer: isDesktop ? null : SideDrawer(), // Remove drawer on desktop
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Expanded(
                flex: 1,
                child: SideDrawer(),
              ),
            Expanded(
              flex: 4,
              child: QuestionCardList(chapterName: chapterName),
            ),
          ],
        ),
      ),
    );
  }
}
