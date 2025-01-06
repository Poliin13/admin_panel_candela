import 'package:admin_panel_candela/screens/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

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
          _buildExpansionTile(context, Icons.science, 'Physics-Math-1st',
              _physicsMathChapters(context), Colors.lightBlue[700]!),
          _buildExpansionTile(context, Icons.science, 'Physics-Math-2nd',
              _physicsMath2ndChapters(context), Colors.teal[700]!),
          _buildExpansionTile(context, Icons.science, 'Physics-Obj.',
              _physicsObjectivesChapters(context), Colors.green[700]!),
          _buildExpansionTile(context, Icons.calculate, 'Math-Amir',
              _mathAmirChapters(context), Colors.orange[700]!),
          _buildExpansionTile(context, Icons.calculate, 'Math-S.U.',
              _mathSUChapters(context), Colors.purple[700]!),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.grey),
            title: const Text('Log Out', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushReplacementNamed(context, '/sign-in'));
            },
          ),
        ],
      ),
    );
  }

  ExpansionTile _buildExpansionTile(BuildContext context, IconData icon, String title,
      List<Widget> children, Color backgroundColor) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      children: children,
    );
  }

  Container _buildListTile(BuildContext context, IconData icon, String title,
      String subtitle, String chapterName, Color color) {
    return Container(
      color: color,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(chapterName: chapterName)),
          );
        },
      ),
    );
  }

  List<Widget> _physicsMathChapters(BuildContext context) => [
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 1',
            'chapter_1_math', Colors.lightBlue[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 2',
            'chapter_2_math', Colors.lightBlue[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 3',
            'chapter_3_math', Colors.lightBlue[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 4',
            'chapter_4_math', Colors.lightBlue[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 5',
            'chapter_5_math', Colors.lightBlue[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 6',
            'chapter_6_math', Colors.lightBlue[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 7',
            'chapter_7_math', Colors.lightBlue[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 8',
            'chapter_8_math', Colors.lightBlue[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 9',
            'chapter_9_math', Colors.lightBlue[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-1st', 'Chapter 10',
            'chapter_10_math', Colors.lightBlue[900]!),
      ];

  List<Widget> _physicsMath2ndChapters(BuildContext context) => [
        _buildListTile(context, Icons.rocket, 'Physics-Math-2nd', 'Chapter 1',
            'chapter_1_math_2nd', Colors.teal[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-2nd', 'Chapter 2',
            'chapter_2_math_2nd', Colors.teal[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Math-2nd', 'Chapter 3',
            'chapter_3_math_2nd', Colors.teal[800]!),
      ];

  List<Widget> _physicsObjectivesChapters(BuildContext context) => [
        _buildListTile(context, Icons.rocket, 'Physics-Objectives', 'Chapter 1',
            'chapter_1_physics_objectives', Colors.green[800]!),
        _buildListTile(context, Icons.rocket, 'Physics-Objectives', 'Chapter 2',
            'chapter_2_physics_objectives', Colors.green[900]!),
        _buildListTile(context, Icons.rocket, 'Physics-Objectives', 'Chapter 3',
            'chapter_3_physics_objectives', Colors.green[800]!),
      ];

  List<Widget> _mathAmirChapters(BuildContext context) => [
        _buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 1',
            'chapter_1_math_amir', Colors.orange[800]!),
        _buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 2',
            'chapter_2_math_amir', Colors.orange[900]!),
        _buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 3',
            'chapter_3_math_amir', Colors.orange[800]!),
      ];

  List<Widget> _mathSUChapters(BuildContext context) => [
        _buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 1',
            'chapter_1_math_su', Colors.purple[800]!),
        _buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 2',
            'chapter_2_math_su', Colors.purple[900]!),
        _buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 3',
            'chapter_3_math_su', Colors.purple[800]!),
      ];
}
