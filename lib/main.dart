import 'package:flutter/material.dart';
import 'package:capstone_diary/bottomnavbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDiary',
      home: Scaffold(
        bottomNavigationBar: BottomNavBar(),
        backgroundColor: Color(0xffFFE4B5),
      ),
    );
  }
}
