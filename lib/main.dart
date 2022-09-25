import 'package:flutter/material.dart';
import 'package:qrstudent_flutter/screen/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homescreen(),
    );
  }
}
