import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(context, '/loadingPage');
        }),
      ],
      sideBuilder: (context, action) => const AppTitle(),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'CANDELA',
            style: GoogleFonts.caesarDressing(
                fontSize: 60, fontWeight: FontWeight.w900,color: Colors.amber),
          ),
        ),
        Container(
          height: 250,
          width: 250,
          child: Image.asset("assets/images/icon_candela_transparent.png"),
        ),
      ],
    );
  }
}