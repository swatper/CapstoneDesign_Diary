import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/HomeWindow/sidemenuwidget.dart';
import 'package:capstone_diary/ArchiveWindow/diarymap.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/DiaryItem/diaryitem.dart';

class ArchiveWindow extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  const ArchiveWindow({super.key, required this.sideMenuToHomeWindowIndex});

  @override
  State<ArchiveWindow> createState() => _ArchiveWindowwState();
}

class _ArchiveWindowwState extends State<ArchiveWindow> {
  @override
  void initState() {
    super.initState();
    //일기 목록 가져오기
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
            //Tabs
            Stack(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height - 169,
                  width: MediaQuery.of(context).size.width,
                  child: TabContainer(
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
                    tabs: [Tab(text: "일자별"), Tab(text: "장소")],
                    children: [
                      Text(
                        '일기 목록',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //DiaryMap(),
                      DiaryMap(
                        /*
                        diaryList: [
                          DiaryModel(
                            '2025-04-30',
                            1,
                            false,
                            37.5665,
                            126.9780,
                            title: "test",
                            content: 'empty',
                            tags: List<String>.from(["감정1", "감정2", "감정3"]),
                          ),
                        ],*/
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
