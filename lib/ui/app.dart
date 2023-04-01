import 'package:colors_of_clothes/ui/home/home_screen.dart';
import 'package:flutter/material.dart';

class ColorsClothesApp extends StatelessWidget {
  const ColorsClothesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colors of Clothes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}


