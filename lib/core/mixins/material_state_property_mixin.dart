import 'package:flutter/material.dart';

mixin MaterialStatePropertyMixin{

  MaterialStateProperty<T> getProperty<T>(T object){
    return MaterialStateProperty.resolveWith((states) => object);
  }
}