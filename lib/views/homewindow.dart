import 'package:flutter/material.dart';
import 'package:capstone_diary/Calender/customcalender.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Items/diaryitem2.dart';
import 'package:capstone_diary/KGB/diaryview.dart';
import 'package:capstone_diary/Utils/diarymanager.dart';

class HomeWindow extends StatefulWidget {
  final Function(int) writeWindowIndex;
  final Function(bool) logOutCallback;
  final Function(Widget) selectDiary;
  const HomeWindow({
    super.key,
    required this.writeWindowIndex,
    required this.selectDiary,
    required this.logOutCallback,
  });
  @override
  State<HomeWindow> createState() => _HomeWindowState();
}

class _HomeWindowState extends State<HomeWindow> {
  DateTime? selectedDate;
  bool isLoaded = false;
  List<DiaryModel> testsamples = [];
  Center loadingWidget = const Center(child: CircularProgressIndicator());

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

  void writeDiary() {
    widget.writeWindowIndex(0);
  }

  Future<void> fetchDiaryData(DateTime date) async {
    setState(() {
      isLoaded = false;
    });
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    try {
      List<DiaryModel> diaries = await DiaryManager().fetchDiaryForDate(
        formattedDate,
      );
      print('[INIT] 서버에서 불러온 일기 개수: ${diaries.length}');
      setState(() {
        testsamples = diaries;
        isLoaded = true;
      });
    } catch (e) {
      print('[ERROR] 일기 불러오기 실패: $e');
    }
  }

  Widget updateDiaryList(List<DiaryModel> models) {
    List<Widget> diaryWidgets = [];
    for (var diary in models) {
      diaryWidgets.add(
        DiaryItem2(
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
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: diaryWidgets,
    );
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
              //달력
              Customcalender(
                backgroundColor: Colors.white,
                getSelectedDate: handleDateSelected,
              ),
              SizedBox(height: 20),
              //일기장 목록
              isLoaded
                  ? testsamples.isEmpty
                      ? Column(
                        children: [
                          Text(
                            "등록된 일기가 없습니다.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "일기를 작성해보세요!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                      : updateDiaryList(testsamples)
                  : loadingWidget,
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
