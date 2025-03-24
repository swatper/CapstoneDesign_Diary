import 'package:flutter/material.dart';
import 'package:capstone_diary/customcalender.dart';
import 'package:capstone_diary/diaryitem.dart';

class HomeWindow extends StatefulWidget {
  const HomeWindow({super.key});
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  void OnClicked() {
    setState(() {});
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
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //일기장 미리보기 항목
                children: [
                  DiaryItem(
                    title: "Test",
                    date: "날짜",
                    summary: "실험중입니다.",
                    tags: 3,
                    emotios: ["감정1", "감정2", "감정3"],
                  ),
                  SizedBox(height: 5),
                  DiaryItem(
                    title: "title",
                    date: "date",
                    summary: "summary",
                    tags: 1,
                    emotios: ["emotios"],
                  ),
                  SizedBox(height: 5),
                  DiaryItem(
                    title: "title",
                    date: "date",
                    summary: "summary",
                    tags: 1,
                    emotios: ["emotios"],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //TODO
  void SearchDiray() {}
  void Menu() {}
}
