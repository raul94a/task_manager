import 'package:flutter/material.dart';

InputDecoration getDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 0.75),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 240, 240, 240), width: 0.75),
      ),
    );
  }
