import 'package:flutter/material.dart';

class AppSnackbar {
  static void createSnackbar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
