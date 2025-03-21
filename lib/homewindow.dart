import 'package:flutter/material.dart';
import 'package:capstone_diary/calander.dart';
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
            Text(
              "홈화면",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            CustomCalendarWidget(
              returnDateType: ReturnDateType.range, // 예시 값
              initialDateList: [],
              initialDateRange: DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(Duration(days: 7)),
              ),
              calenderThema: CalenderThema.white,
            ),
          ],
        ),
      ),
    );
  }
}
