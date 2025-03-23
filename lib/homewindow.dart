import 'package:flutter/material.dart';
import 'package:capstone_diary/calander.dart';
import 'package:capstone_diary/customcalender.dart';
import 'package:custom_calender_picker/custom_calender_picker.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            //검색, 더보기 아이콘
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.search, size: 35),
                Icon(Icons.menu, size: 35),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 10),
            Customcalender(backgroundColor: Colors.white),
          ],
        ),
      ),
    );
  }

  //TODO
  void SearchDiray() {}
  void Menu() {}
}
