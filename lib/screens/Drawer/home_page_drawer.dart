
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // final currentTheme = ref.watch(themeSwitcherProvider);
    // final user = FirebaseAuth.instance.currentUser;
    // final updateProvider = ref.watch(appUpdateProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       user?.photoURL == null
          //           ? const CircleAvatar(
          //               radius: 50,
          //               child: Icon(Icons.person, size: 50),
          //             )
          //           : CircleAvatar(
          //               radius: 50,
          //               backgroundImage: NetworkImage(user?.photoURL ?? ''),
          //             ),
          //       const Spacer(),
          //       Text(user?.displayName ??
          //           user?.email ??
          //           user?.phoneNumber ??
          //           'Anonymous')
          //     ],
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('Contributors'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ContributorsPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_4),
            title: const Text('Dark Mode'),
            // trailing: Switch(
            //   value: currentTheme.darkTheme!,
            //   onChanged: (val) {
            //     currentTheme.toggleTheme();
            //   },
            // ),
          ),

          ListTile(
            leading: const Icon(Icons.star, color: Colors.blue),
            title: const Text('Like this App??'),
            // onTap: () => updateProvider.openStoreListing(),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () async {
              // await logoutUser(context);
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushReplacementNamed(context, '/sign-in'));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever,color: Colors.red),
            title: const Text('Delete Account'),
            onTap: () async {

            },
          ),
        ],
      ),
    );
  }

}


