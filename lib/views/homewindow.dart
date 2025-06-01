import 'package:flutter/material.dart';
import 'package:capstone_diary/Calender/customcalender.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Items/diaryitem2.dart';
import 'package:capstone_diary/KGB/diaryview.dart';
import 'package:capstone_diary/Views/searchingwindow.dart';

class HomeWindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  final Function(int) writeWindowIndex;
  final Function(bool) logOutCallback;
  final Function(Widget) selectDiary;
  final Function(Widget) searchingView;
  const HomeWindow({
    super.key,
    required this.sideMenuToHomeWindowIndex,
    required this.writeWindowIndex,
    required this.selectDiary,
    required this.searchingView,
    required this.logOutCallback,
  });
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  DateTime? selectedDate;
  List<DiaryModel> testsamples = [
    DiaryModel(
      '2025-05-10',
      1,
      false,
      37.5665,
      126.9780,
      title: "test1",
      content: 'empty1',
      tags: List<String>.from(["감정1", "감정2", "감정3"]),
    ),
    DiaryModel(
      '2025-05-01',
      1,
      true,
      38.2832,
      127.4890,
      title: "test2",
      content: 'empty2',
      tags: List<String>.from(["감정1", "감정2", "감정3"]),
    ),
    DiaryModel(
      '2025-04-02',
      1,
      true,
      38.0000,
      127.0000,
      title: "test3",
      content: 'empty3',
      tags: List<String>.from(["감정1", "감정2", "감정3"]),
    ),
    DiaryModel(
      '2025-04-01',
      1,
      false,
      37.5465,
      126.9580,
      title: "test3",
      content: 'empty3',
      tags: List<String>.from(["감정1", "감정2", "감정3"]),
    ),
  ];

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
    //TODO SERVER: 서버 요청해서 JSON 데이터를 받아오기
  }

  //검색 버튼
  void searchDiray() {
    widget.searchingView(Searchingwindow());
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
              logOutCallback: widget.logOutCallback,
            ),
          );
        },
      ),
    );
  }

  void writeDiary() {
    widget.writeWindowIndex(0);
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
              SizedBox(height: 20),
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
                  DiaryItem2(
                    diaryModel: testsamples[0],
                    onTap: () {
                      widget.selectDiary(
                        DiaryView(
                          diaryModel: testsamples[1],
                          setWriteWindow: widget.selectDiary,
                          sideMenuToHomeWindowIndex:
                              widget.sideMenuToHomeWindowIndex,
                          goBackToArchive: widget.selectDiary,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  DiaryItem2(
                    diaryModel: testsamples[1],
                    onTap: () {
                      widget.selectDiary(
                        DiaryView(
                          diaryModel: testsamples[1],
                          setWriteWindow: widget.selectDiary,
                          sideMenuToHomeWindowIndex:
                              widget.sideMenuToHomeWindowIndex,
                          goBackToArchive: widget.selectDiary,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  DiaryItem2(
                    diaryModel: testsamples[2],
                    onTap: () {
                      widget.selectDiary(
                        DiaryView(
                          diaryModel: testsamples[1],
                          setWriteWindow: widget.selectDiary,
                          sideMenuToHomeWindowIndex:
                              widget.sideMenuToHomeWindowIndex,
                          goBackToArchive: widget.selectDiary,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5),
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
