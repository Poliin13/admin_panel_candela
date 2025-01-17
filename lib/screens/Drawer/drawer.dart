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
          _buildExpansionTile(context, Icons.rocket_launch, "Physics-1 Math",
              physicsMathChapters(context), Colors.lightBlue[700]!),
          _buildExpansionTile(context, Icons.rocket_launch, 'Physics-1 MCQ',
              physicsObjectivesChapters(context), Colors.green[700]!),
          _buildExpansionTile(context, Icons.rocket_launch, 'Physics-2 Math',
              physicsMath2ndChapters(context), Colors.teal[700]!),
          _buildExpansionTile(context, Icons.calculate, 'Math-Amir',
              mathAmirChapters(context), Colors.orange[700]!),
          _buildExpansionTile(context, Icons.calculate, 'Math-S.U.',
              mathSUChapters(context), Colors.purple[700]!),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title:
                const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.grey),
            title: const Text('Log Out', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushReplacementNamed(context, '/sign-in'));
            },
          ),
        ],
      ),
    );
  }

  ExpansionTile _buildExpansionTile(BuildContext context, IconData icon,
      String title, List<Widget> children, Color backgroundColor) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      children: children,
    );
  }

  Container buildListTile(BuildContext context, IconData icon, String title,
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
            MaterialPageRoute(
                builder: (context) => HomePage(
                      chapterName: chapterName,
                      jsonNode: title,
                    )),
          );
        },
      ),
    );
  }

  List<Widget> physicsMathChapters(BuildContext context) => [
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 1', 'chapter_1_math', Colors.lightBlue[800]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 2', 'chapter_2_math', Colors.lightBlue[900]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 3', 'chapter_3_math', Colors.lightBlue[800]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 4', 'chapter_4_math', Colors.lightBlue[900]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 5', 'chapter_5_math', Colors.lightBlue[800]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 6', 'chapter_6_math', Colors.lightBlue[900]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 7', 'chapter_7_math', Colors.lightBlue[800]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 8', 'chapter_8_math', Colors.lightBlue[900]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 9', 'chapter_9_math', Colors.lightBlue[800]!),
        buildListTile(context, Icons.rocket_launch, "physics_1st_paper",
            'Chapter 10', 'chapter_10_math', Colors.lightBlue[900]!),
      ];

  List<Widget> physicsMath2ndChapters(BuildContext context) => [
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 1', 'chapter_1_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 2', 'chapter_2_math_2nd', Colors.teal[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 3', 'chapter_3_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 4', 'chapter_4_math_2nd', Colors.teal[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 5', 'chapter_5_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 6', 'chapter_6_math_2nd', Colors.teal[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 7', 'chapter_7_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 8', 'chapter_8_math_2nd', Colors.teal[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 9', 'chapter_9_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 10', 'chapter_10_math_2nd', Colors.teal[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 11', 'chapter_11_math_2nd', Colors.teal[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-Math-2nd',
            'Chapter 12', 'chapter_12_math_2nd', Colors.teal[900]!),
      ];

  List<Widget> physicsObjectivesChapters(BuildContext context) => [
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 1', 'chapter_1_physics_objectives', Colors.green[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 2', 'chapter_2_physics_objectives', Colors.green[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 3', 'chapter_3_physics_objectives', Colors.green[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 4', 'chapter_4_physics_objectives', Colors.green[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 5', 'chapter_5_physics_objectives', Colors.green[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 6', 'chapter_6_physics_objectives', Colors.green[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 7', 'chapter_7_physics_objectives', Colors.green[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 8', 'chapter_8_physics_objectives', Colors.green[900]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 9', 'chapter_9_physics_objectives', Colors.green[800]!),
        buildListTile(context, Icons.rocket_launch, 'Physics-1(MCQ)',
            'Chapter 10', 'chapter_10_physics_objectives', Colors.green[900]!),
      ];

  List<Widget> mathAmirChapters(BuildContext context) => [
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 1',
            'chapter_1_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 2',
            'chapter_2_math_amir', Colors.orange[900]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 3',
            'chapter_3_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 4',
            'chapter_4_math_amir', Colors.orange[900]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 5',
            'chapter_5_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 6',
            'chapter_6_math_amir', Colors.orange[900]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 7',
            'chapter_7_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 8',
            'chapter_8_math_amir', Colors.orange[900]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 9',
            'chapter_9_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 10',
            'chapter_10_math_amir', Colors.orange[900]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 11',
            'chapter_11_math_amir', Colors.orange[800]!),
        buildListTile(context, Icons.calculate, 'Math-Amir', 'Chapter 12',
            'chapter_12_math_amir', Colors.orange[900]!),
      ];

  List<Widget> mathSUChapters(BuildContext context) => [
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 1',
            'chapter_1_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 2',
            'chapter_2_math_su', Colors.purple[900]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 3',
            'chapter_3_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 4',
            'chapter_4_math_su', Colors.purple[900]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 5',
            'chapter_5_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 6',
            'chapter_6_math_su', Colors.purple[900]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 7',
            'chapter_7_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 8',
            'chapter_8_math_su', Colors.purple[900]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 9',
            'chapter_9_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 10',
            'chapter_10_math_su', Colors.purple[900]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 11',
            'chapter_11_math_su', Colors.purple[800]!),
        buildListTile(context, Icons.calculate, 'Math-S.U.', 'Chapter 12',
            'chapter_12_math_su', Colors.purple[900]!),
      ];
}
