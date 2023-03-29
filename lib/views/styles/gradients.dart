import 'package:flutter/material.dart';

const darkModeGradient = LinearGradient(
    tileMode: TileMode.decal,
    colors: [
      Color.fromARGB(255, 15, 15, 15),
      Color.fromARGB(245, 0, 0, 0),
      Color.fromARGB(255, 22, 21, 21),
      Color.fromARGB(255, 63, 62, 62)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);

const lightModeGradient = LinearGradient(
    tileMode: TileMode.decal,
    colors: [
      Colors.white,
      Color.fromARGB(245, 232, 234, 238),
      Color.fromARGB(251, 232, 234, 238),
           Color.fromARGB(245, 217, 230, 255),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);
