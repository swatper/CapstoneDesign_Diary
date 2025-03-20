import 'package:flutter/material.dart';
import 'package:capstone_diary/calander.dart';

class HomeWindow extends StatefulWidget {
  const HomeWindow({super.key});
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              "홈화면",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            //CustomCalenderPickerExample(),
          ],
        ),
      ),
    );
  }
}
