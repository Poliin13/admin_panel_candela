import 'package:admin_panel_candela/screens/HomePage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:flutter_tex/flutter_tex.dart';
import 'Authentication/sign_in.dart';
import 'ThemeData/theme_data.dart';
import 'firebase_options.dart';

Future<void> main() async {
  TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.mathjax();

  if (!kIsWeb) {
    await TeXRederingServer.run();
    await TeXRederingServer.initController();
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable offline persistence for Realtime Database
  if (!kIsWeb) FirebaseDatabase.instance.setPersistenceEnabled(true);

  // Configure Firebase UI Auth providers
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: darkThemeData,
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? '/loadingPage' : '/sign-in',
      routes: {
        '/sign-in': (context) => const SignIn(),
        // '/sign-in': (context) => HomePage(chapterName: 'chapter_1_math'),
        '/loadingPage': (context) => HomePage(chapterName: 'chapter_1_math'),
      },
    );
  }
}
