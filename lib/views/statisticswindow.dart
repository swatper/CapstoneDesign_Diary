import 'package:capstone_diary/Utils/datamanager.dart';
import 'package:capstone_diary/views/summarychart.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Items/emotionraderchart.dart';
import 'package:capstone_diary/services/diaryapiservice.dart';

class StatisticsWindow extends StatefulWidget {
  final Function(bool) logOutCallback;
  const StatisticsWindow({super.key, required this.logOutCallback});

  @override
  State<StatisticsWindow> createState() => _StatisticsWindowState();
}

class _StatisticsWindowState extends State<StatisticsWindow> {
  String currentMonth = "${DateTime.now().month}월";
  String selectedDate = "${DateTime.now().month}-${DateTime.now().month}";
  final Map<String, int> emotionData = {
    '기쁨': 10,
    '행복': 0,
    '설렘': 8,
    '화남': 7,
    '우울함': 6,
    '슬픔': 5,
    '지루함': 4,
    '놀람': 3,
    '불안': 2,
    '부끄러움': 1,
  };

  @override
  void initState() {
    super.initState();
    //감정 통계 값 가져오기
    getEmotionData(selectedDate);
  }

  void showMonthCalander() {
    showMonthPicker(context: context, initialDate: DateTime.now()).then((
      DateTime? date,
    ) {
      if (date != null) {
        setState(() {
          selectedDate = "${date.year}년 ${date.month}월";
          currentMonth = "${date.month}월";
        });
        getEmotionData(selectedDate);
      }
    });
  }

  void getEmotionData(String date) async {
    Map<String, int> emotionDataMap = await DiaryApiService().getMonthlyEmotion(
      await Datamanager().getData('userId'),
      date,
    );
    setState(() {
      emotionData['기쁨'] = emotionDataMap['joy'] ?? 0;
      emotionData['행복'] = emotionDataMap['happy'] ?? 0;
      emotionData['설렘'] = emotionDataMap['excited'] ?? 0;
      emotionData['화남'] = emotionDataMap['angry'] ?? 0;
      emotionData['우울함'] = emotionDataMap['depressed'] ?? 0;
      emotionData['슬픔'] = emotionDataMap['sad'] ?? 0;
      emotionData['지루함'] = emotionDataMap['bored'] ?? 0;
      emotionData['놀람'] = emotionDataMap['surprised'] ?? 0;
      emotionData['불안'] = emotionDataMap['nervous'] ?? 0;
      emotionData['부끄러움'] = emotionDataMap['shy'] ?? 0;
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
                      SummaryChart(),
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
