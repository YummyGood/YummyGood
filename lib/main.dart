import 'package:flutter/material.dart';
import 'package:yummygood/displays/homepage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YummyGood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEBA174)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}