import 'package:admin_panel_candela/screens/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../test/flutter_tex_test.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset("assets/images/icon_candela_transparent.png"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Latex'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeXViewDocumentExamples()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.rocket),
            title: const Text('Physics 1st'),
            subtitle: const Text('Math Chapter 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(questionsChapter: 'chapter_1_math_questions')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.rocket),
            title: const Text('Physics 1st'),
            subtitle: const Text('Math Chapter 2'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomePage(questionsChapter: 'chapter_2_math_questions'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.rocket),
            title: const Text('Physics 1st'),
            subtitle: const Text('Math Chapter 3'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomePage(questionsChapter: 'chapter_3_math_questions'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () async {
              // await logoutUser(context);
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushReplacementNamed(context, '/sign-in'));
            },
          ),
        ],
      ),
    );
  }
}
