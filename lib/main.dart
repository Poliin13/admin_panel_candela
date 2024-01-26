import 'package:admin_panel_candela/screens/HomePage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'Authentication/sign_in.dart';
import 'ThemeData/theme_data.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Enable offline persistence
  // FirebaseDatabase.instance.setPersistenceEnabled(true);
  //Auth
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: darkThemeData,
      //SignIn Handler
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : '/loadingPage',
      routes: {
        '/sign-in': (context) => const SignIn(),
        '/loadingPage': (context) => HomePage(questionsChapter: 'chapter_1_math_questions'),
      },
      // home: HomePage(),
      // home: MyHomePage(),
    );
  }
}
