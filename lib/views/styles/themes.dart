import 'package:flutter/material.dart';

import 'app_colors.dart';

final darkTheme = ThemeData().copyWith(
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 238, 225, 225),
      selectionColor: Colors.pink),
  // dialogBackgroundColor:Color.fromARGB(255, 51, 50, 50),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
              (states) => const Color.fromARGB(255, 63, 63, 63)))),
  dialogTheme: const DialogTheme(
    backgroundColor: Color.fromARGB(255, 44, 44, 44),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    errorMaxLines: 2,
    fillColor: Color.fromARGB(246, 56, 56, 56),
    filled: true,
    labelStyle: TextStyle(color: Colors.black, fontSize: 14.2),
    errorStyle: TextStyle(color: Colors.red, fontSize: 14.2),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.75),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),

    labelMedium: TextStyle(color: Colors.black, fontSize: 14.2),
    labelLarge: TextStyle(color: Colors.white),

    labelSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    //TEXT
    bodyMedium:
        TextStyle(color: Color.fromARGB(255, 240, 239, 239), fontSize: 14.2),
    bodySmall: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.black, fontSize: 14.2),
    headlineMedium: TextStyle(color: Colors.black, fontSize: 14.2),
    headlineLarge: TextStyle(color: Colors.black, fontSize: 14.2),
    titleLarge: TextStyle(color: Colors.white, fontSize: 14.2),
    titleMedium: TextStyle(color: Colors.white, fontSize: 14.2),
    titleSmall: TextStyle(color: Colors.black, fontSize: 14.2),
  ),
);

final lightTheme = ThemeData.light().copyWith(
  inputDecorationTheme: const InputDecorationTheme(
    errorMaxLines: 2,
    fillColor: lateralBarBg,
    filled: true,
    labelStyle: TextStyle(color: Colors.black, fontSize: 14.2),
    errorStyle: TextStyle(color: Colors.red, fontSize: 14.2),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 233, 17, 17), width: 0.75),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 0.75),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  dialogBackgroundColor: taskDialogLightModeBg,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),

    labelMedium: TextStyle(color: Colors.white, fontSize: 14.2),
    labelLarge: TextStyle(color: Colors.black),

    labelSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    //TEXT
    bodyMedium: TextStyle(color: Colors.black, fontSize: 14.2),
    bodySmall: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 14.2),
    headlineMedium: TextStyle(color: Colors.white, fontSize: 14.2),
    headlineLarge: TextStyle(color: Colors.white, fontSize: 14.2),
    titleLarge: TextStyle(color: Colors.black, fontSize: 14.2),
    titleMedium: TextStyle(color: Colors.white, fontSize: 14.2),
    titleSmall: TextStyle(color: Colors.white, fontSize: 14.2),
  ),
);
