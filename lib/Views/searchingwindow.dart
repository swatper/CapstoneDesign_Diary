import 'package:flutter/material.dart';

class Searchingwindow extends StatefulWidget {
  const Searchingwindow({super.key});

  @override
  State<Searchingwindow> createState() => _SearchingwindowState();
}

class _SearchingwindowState extends State<Searchingwindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFE4B5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [Text("data")]),
      ),
    );
  }
}
