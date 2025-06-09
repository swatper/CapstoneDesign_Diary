import 'package:capstone_diary/Utils/diarymanager.dart';
import 'package:capstone_diary/views/searchingwindow.dart';
import 'package:capstone_diary/views/summarychart.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Items/emotionraderchart.dart';

class StatisticsWindow extends StatefulWidget {
  final Function(bool) logOutCallback;
  final Function(String option, String value) onSearch; // 추가
  const StatisticsWindow({
    super.key,
    required this.logOutCallback,
    required this.onSearch,
  });

  @override
  State<StatisticsWindow> createState() => _StatisticsWindowState();
}

class _StatisticsWindowState extends State<StatisticsWindow> {
  String currentMonth = "${DateTime.now().month}월";
  Map<String, int> emotionData = {
    '기쁨': 0,
    '행복': 0,
    '설렘': 0,
    '화남': 0,
    '우울함': 0,
    '슬픔': 0,
    '지루함': 0,
    '놀람': 0,
    '불안': 0,
    '부끄러움': 0,
  };

  Future<void> _loadAllEmotionData() async {
    emotionData = await DiaryManager().getAllEmotion(); // 데이터 변경 후 entries 갱신
    setState(() {}); // 화면 갱신
  }

  @override
  void initState() {
    super.initState();
    //감정 통계 값 가져오기
    selectDate(DateTime.now());
  }

  Future<void> selectDate(DateTime date) async {
    print("선택한 날짜: $date");

    emotionData = await DiaryManager().getMonthlyEmotion(date);
    setState(() {}); // 화면 갱신
  }

  void showMonthCalander() {
    showMonthPicker(context: context, initialDate: DateTime.now()).then((
      DateTime? date,
    ) {
      if (date != null) {
        selectDate(date);
        setState(() {
          currentMonth = "${date.month}월"; // 선택한 월 업데이트
        });
      }
    });
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
                      createChart("$currentMonth 주요 감정"),
                      //요약 차트 tab
                      SummaryChart(onSearch: widget.onSearch),
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
                  onPressed: showMonthCalander,
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
