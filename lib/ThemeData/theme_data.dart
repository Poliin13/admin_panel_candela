import 'package:flutter/material.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

final buttonStyle = ButtonStyle(
  padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

ThemeData darkThemeData = ThemeData(
  scaffoldBackgroundColor: bgColor,
  canvasColor: secondaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: secondaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardTheme: CardTheme(
    color: bgColor,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.indigo),
    ),
    labelStyle: TextStyle(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
  textButtonTheme: TextButtonThemeData(style: buttonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);
