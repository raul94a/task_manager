import 'package:flutter/material.dart';

extension EasyContext on BuildContext {

  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  void showSnackBar(String message){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

}