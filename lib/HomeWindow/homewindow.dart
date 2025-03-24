import 'package:flutter/material.dart';
import 'package:capstone_diary/HomeWindow/customcalender.dart';
import 'package:capstone_diary/DiaryItem/diaryitem.dart';

class HomeWindow extends StatefulWidget {
  const HomeWindow({super.key});
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchDiaryData(DateTime.now()); // 앱 시작 시 모든 날짜 데이터 요청
  }

  void handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    fetchDiaryData(date); // 서버 요청
  }

  // 서버에서 일기 데이터를 받아오는 함수
  void fetchDiaryData(DateTime date) async {
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    print("서버 요청: $formattedDate");
    //TODO SERVER: 서버 요청해서 JSON 데이터를 받아오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
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
              Customcalender(
                backgroundColor: Colors.white,
                getSelectedDate: handleDateSelected,
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //일기장 미리보기 항목
                children: [
                  DiaryItem(
                    title: "Test",
                    date: "날짜",
                    summary: "실험중입니다.",
                    emotios: ["감정1", "감정2", "감정3"],
                  ),
                  SizedBox(height: 5),
                  DiaryItem(
                    title: "title",
                    date: "date",
                    summary: "summary",
                    emotios: ["emotios"],
                  ),
                  SizedBox(height: 5),
                  DiaryItem(
                    title: "title",
                    date: "date",
                    summary: "summary",
                    emotios: ["emotios1", "location"],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
