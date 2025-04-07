import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/HomeWindow/sidemenuwidget.dart';
import 'package:capstone_diary/StatisticsWindow/emotionraderchart.dart';

class Statisticswindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  const Statisticswindow({super.key, required this.sideMenuToHomeWindowIndex});
  @override
  State<Statisticswindow> createState() => _StatisticswindowState();
}

class _StatisticswindowState extends State<Statisticswindow> {
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

  void searchDiray() {
    showToastMessage("아직 미구현");
  }

  //메뉴 버튼
  void showMenu() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0),
              end: Offset(0, 0),
            ).animate(animation),
            child: SideMenuWidget(
              sideMenuSelectedIndex: widget.sideMenuToHomeWindowIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: searchDiray,
                        icon: Icon(Icons.search, size: 35),
                      ),
                      IconButton(
                        onPressed: showMenu,
                        icon: Icon(Icons.menu, size: 35),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //통계 보여줄 Tab
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TabContainer(
                color: Color(0xffFFF6E7),
                selectedTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                unselectedTextStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                tabs: [const Tab(text: "감정"), const Tab(text: "요약")],
                children: [
                  //감정 차트 tab
                  createChart("이번달 주요 감정"),
                  //요약 차트 tab
                  createChart("이번달 주요 이벤트"),
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
            SizedBox(height: 20),
            //제목
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
