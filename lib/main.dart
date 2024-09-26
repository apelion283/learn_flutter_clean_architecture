import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/pages/home.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePageScreen(title: "Home"),
  ));
}
