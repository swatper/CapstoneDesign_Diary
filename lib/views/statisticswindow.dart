import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Views/searchingwindow.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';
import 'package:capstone_diary/Items/emotionraderchart.dart';

class StatisticsWindow extends StatefulWidget {
  final Function(bool) logOutCallback;
  const StatisticsWindow({super.key, required this.logOutCallback});

  @override
  State<StatisticsWindow> createState() => _StatisticsWindowState();
}

class _StatisticsWindowState extends State<StatisticsWindow> {
  final Map<String, int> emotionData = {
    '기쁨': 1,
    '행복': 2,
    '설렘': 3,
    '화남': 4,
    '우울함': 5,
    '슬픔': 6,
    '지루함': 7,
    '놀람': 8,
    '불안': 9,
    '부끄러움': 10,
  };

  @override
  void initState() {
    super.initState();
    //감정 통계 값 가져오기
  }

  void handleDateSelected(DateTime date) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            //통계 보여줄 Tab
            Expanded(
              child: Stack(
                children: [
                  //선택 안한 tab 배경
                  Container(
                    transform: Matrix4.translationValues(21, 0, 0),
                    width: 184,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffEDE8DF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  //tab container 관련 설정
                  TabContainer(
                    color: Color(0xffFFF6E7),
                    selectedTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                    unselectedTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    //tab 관련 설정 (위치, tab 안에 내용)
                    tabsStart: 0.05,
                    tabsEnd: 0.5,
                    tabs: [Tab(text: "감정"), Tab(text: "요약")],
                    children: [
                      //감정 차트 tab
                      createChart("이번달 주요 감정"),
                      //요약 차트 tab
                      createChart("이번달 주요 이벤트"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center createChart(String title) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //제목
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month, size: 40),
                ),
              ],
            ),
            Divider(color: Color(0xff919572), thickness: 1),
            SizedBox(height: 30),
            //차트
            SizedBox(
              width: 380,
              height: 380,
              child: EmotionRadarChart(emotionData: emotionData),
            ),
          ],
        ),
      ),
    );
  }
}
