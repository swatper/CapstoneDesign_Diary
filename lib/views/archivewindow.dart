import 'package:capstone_diary/Utils/diarymanager.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:capstone_diary/GoogleMap/diarymap.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Items/diaryitem2.dart';
import 'package:capstone_diary/Views/searchingwindow.dart';
import 'package:capstone_diary/KGB/diaryview.dart';

class ArchiveWindow extends StatefulWidget {
  final String? option;
  final String? value;
  final Function(bool)? logOutCallback;
  final Function(Widget) selectDiary;
  final Function(Widget)? searchingView;
  const ArchiveWindow({
    super.key,
    this.option,
    this.value,
    required this.selectDiary,
    this.searchingView,
    this.logOutCallback,
  });

  @override
  State<ArchiveWindow> createState() => _ArchiveWindowwState();
}

class _ArchiveWindowwState extends State<ArchiveWindow> {
  List<DiaryModel> testsamples = [];
  bool isPublic = false; //공개 여부
  bool isLoaded = false;
  Center loadingWidget = const Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    loadSearchingWindow();
  }

  @override
  void didUpdateWidget(covariant ArchiveWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯의 속성(option, value)이 변경되었을 때 호출됩니다.
    // 기존 option/value와 새로운 option/value가 다르면 다시 로드합니다.
    if (widget.option != oldWidget.option || widget.value != oldWidget.value) {
      loadSearchingWindow(); // 변경된 옵션으로 다시 로드
    }
  }

  void loadSearchingWindow() {
    if (widget.option != null && widget.value != null) {
      //옵션과 값이 주어졌을 때, 해당 조건으로 일기 불러오기
      _loadDiariesWithFilter(widget.option!, widget.value!);
      showToastMessage("옵션 값: ${widget.option}, ${widget.value}");
    } else {
      //옵션과 값이 없을 때, 전체 일기 불러오기
      showToastMessage("옵션 없이 검색");
      _loadDiaries();
    }
  }

  Future<void> _loadDiariesWithFilter(String option, String value) async {
    setState(() {
      isLoaded = false; // 로딩 시작
    });
    /*
    String userId = '20213010'; // 사용자 ID 하드코딩 또는 로그인 값 사용
    try {
      List<DiaryModel> diaries = await DiaryManager().fetchAllDiaries(userId);
      print('[INIT] 서버에서 불러온 일기 개수: ${diaries.length}');
      setState(() {
        testsamples = diaries;
        isLoaded = true;
      });
    } catch (e) {
      print('[ERROR] 일기 불러오기 실패: $e');
    }*/
  }

  Future<void> _loadDiaries() async {
    setState(() {
      isLoaded = false; // 로딩 시작
    });
    String userId = '20213010'; // 사용자 ID 하드코딩 또는 로그인 값 사용
    try {
      List<DiaryModel> diaries = await DiaryManager().fetchAllDiaries(userId);
      print('[INIT] 서버에서 불러온 일기 개수: ${diaries.length}');
      setState(() {
        testsamples = diaries;
        isLoaded = true;
      });
    } catch (e) {
      print('[ERROR] 일기 불러오기 실패: $e');
    }
  }

  void handleDateSelected(DateTime date) {
    setState(() {});
  }

  void searchDiray() {
    widget.searchingView?.call(Searchingwindow());
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
            diaryId: diary.diaryId,
            diaryModel: diary,
            onTap: () {
              widget.selectDiary(
                DiaryView(
                  diaryModel: diary,
                  setWriteWindow: widget.selectDiary,
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
            Padding(padding: EdgeInsets.symmetric(horizontal: 40)),
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
                              isLoaded
                                  ? diaryList(
                                    isPublic
                                        ? testsamples
                                            .where((diary) => diary.isPublic)
                                            .toList()
                                        : testsamples,
                                  )
                                  : loadingWidget,
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
