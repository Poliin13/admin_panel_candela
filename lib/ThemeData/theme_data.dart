import 'package:flutter/material.dart';
import '../constants.dart';


final buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

// theme: ThemeData.dark().copyWith(
//   scaffoldBackgroundColor: bgColor,
//   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//       .apply(bodyColor: Colors.white),
//   canvasColor: secondaryColor,
// ),

ThemeData darkThemeData = ThemeData(
  scaffoldBackgroundColor: bgColor,
  canvasColor: secondaryColor,
  visualDensity: VisualDensity.standard,
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.indigo,
  applyElevationOverlayColor: true,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
  textButtonTheme: TextButtonThemeData(style: buttonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
);
