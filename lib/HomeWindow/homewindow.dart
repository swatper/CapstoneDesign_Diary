import 'package:flutter/material.dart';
import 'package:capstone_diary/HomeWindow/customcalender.dart';
import 'package:capstone_diary/DiaryItem/diaryitem.dart';
import 'package:capstone_diary/HomeWindow/sidemenuwidget.dart';
import 'package:capstone_diary/toastmessage.dart';

class HomeWindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  const HomeWindow({super.key, required this.sideMenuToHomeWindowIndex});
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchDiaryData(DateTime.now());
  }

  void handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    fetchDiaryData(date);
  }

  //서버에서 일기 데이터를 받아오는 함수
  void fetchDiaryData(DateTime date) async {
    //"YYYY-MM-DD"
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    print("서버 요청: $formattedDate");
    //TODO SERVER: 서버 요청해서 JSON 데이터를 받아오기
  }

  //검색 버튼
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

  void writeDiary() {
    showToastMessage("아직 미구현");
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
                  IconButton(
                    onPressed: searchDiray,
                    icon: Icon(Icons.search, size: 35),
                  ),
                  IconButton(
                    onPressed: showMenu,
                    icon: Icon(Icons.menu, size: 35),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 10),
              //달력
              Customcalender(
                backgroundColor: Colors.white,
                getSelectedDate: handleDateSelected,
              ),
              SizedBox(height: 20),
              //일기장 목록
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //일기장 아이템
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
      //일기쓰기 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: writeDiary,
        backgroundColor: Colors.black,
        heroTag: "writeDiary",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        child: Icon(Icons.border_color_sharp, size: 30, color: Colors.white),
      ),
    );
  }
}
