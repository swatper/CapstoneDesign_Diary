import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';
import 'package:capstone_diary/GoogleMap/diarymap.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Items/diaryitem2.dart';
import 'package:capstone_diary/Views/searchingwindow.dart';
import 'package:capstone_diary/KGB/diaryview.dart';

class ArchiveWindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  final Function(bool)? logOutCallback;
  final Function(Widget) selectDiary;
  final Function(Widget)? searchingView;
  const ArchiveWindow({
    super.key,
    required this.sideMenuToHomeWindowIndex,
    required this.selectDiary,
    this.searchingView,
    this.logOutCallback,
  });

  @override
  State<ArchiveWindow> createState() => _ArchiveWindowwState();
}

class _ArchiveWindowwState extends State<ArchiveWindow> {
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
  bool isPublic = false; //공개 여부

  @override
  void initState() {
    super.initState();
    //일기 목록 가져오기
  }

  void handleDateSelected(DateTime date) {
    setState(() {});
  }

  void searchDiray() {
    widget.searchingView?.call(Searchingwindow());
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

  Widget diaryList(List<DiaryModel> models) {
    String lastYearMonth = "";
    List<Widget> diaryWidgets = [];
    for (var diary in models) {
      //일기 목록 제목 넣기
      if (lastYearMonth != diary.date.substring(0, 7)) {
        lastYearMonth = diary.date.substring(0, 7);
        diaryWidgets.add(SizedBox(height: 10));
        diaryWidgets.add(
          Text(
            "${lastYearMonth.substring(0, 4)}년 ${lastYearMonth.substring(5, 7)}월",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
        );
      }
      //일기 목록 넣기
      diaryWidgets.add(
        Container(
          alignment: Alignment.center,
          child: DiaryItem2(
            diaryModel: diary,
            onTap: () {
              widget.selectDiary(
                DiaryView(
                  diaryModel: diary,
                  setWriteWindow: widget.selectDiary,
                  sideMenuToHomeWindowIndex: widget.sideMenuToHomeWindowIndex,
                  goBackToArchive: widget.selectDiary,
                ),
              );
            },
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: diaryWidgets,
    );
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
            //Tabs
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
                      color: const Color.fromARGB(255, 3, 2, 2),
                      fontWeight: FontWeight.w500,
                    ),
                    //tab 관련 설정 (위치, tab 안에 내용)
                    tabsStart: 0.05,
                    tabsEnd: 0.5,
                    tabs: [Tab(text: "일자별"), Tab(text: "장소")],
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(17, 10, 17, 0),
                          child: Stack(
                            children: [
                              //일기장 목록
                              diaryList(
                                isPublic
                                    ? testsamples
                                        .where((diary) => diary.isPublic)
                                        .toList()
                                    : testsamples,
                              ),
                              //버튼
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Switch(
                                    value: isPublic,
                                    onChanged: (value) {
                                      setState(() {
                                        isPublic = value; // 상태 변경
                                      });
                                    },
                                    activeColor: Colors.amber, // 활성 상태 색상
                                    inactiveThumbColor:
                                        Colors.grey, // 비활성 상태 색상
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      DiaryMap(diaryList: testsamples),
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
}
