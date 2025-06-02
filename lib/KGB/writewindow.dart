import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/KGB/weatherbutton.dart';
import 'package:capstone_diary/KGB/writewindowNext.dart';
import 'package:flutter/material.dart';

class WriteWindow extends StatefulWidget {
  final DiaryModel? diaryModel;
  final Function(Widget) setWriteWindowNext;
  final VoidCallback? goBackToHome;
  bool isEditMode;

  WriteWindow({
    super.key,
    required this.setWriteWindowNext,
    this.isEditMode = false,
    this.diaryModel,
    this.goBackToHome,
  });
  @override
  State<WriteWindow> createState() => _WriteWindow();
}

void onClickedCalanderButton() {}

class _WriteWindow extends State<WriteWindow> {
  PageController pageController = PageController();
  late TextEditingController contentController;
  late TextEditingController titleController;
  late int selectedWeatherIndex;
  late int year;
  late int month;
  late int day;
  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
    // 초기 데이터 적용 (널이면 기본값 사용)
    contentController = TextEditingController(
      text: widget.diaryModel?.content ?? '',
    );
    titleController = TextEditingController(
      text: widget.diaryModel?.title ?? '',
    );
    selectedWeatherIndex = widget.diaryModel?.weather ?? 0;
    DateTime parsedDate =
        DateTime.tryParse(widget.diaryModel?.date ?? '') ?? today;

    year = parsedDate.year;
    month = parsedDate.month;
    day = parsedDate.day;
  }

  void onClickedBackButton() {
    // 뒤로가기 버튼 클릭 시 이전 화면으로 이동
    widget.goBackToHome!();
  }

  void onWeatherSelected(int index) {
    setState(() {
      selectedWeatherIndex = index;
    });
  }

  void onClickedNextButton() {
    widget.setWriteWindowNext(
      WriteWindowNext(
        diaryContent: contentController.text,
        year: year,
        month: month,
        day: day,
        weatherIndex: selectedWeatherIndex,
        title: titleController.text,
        onReturnToMain: widget.goBackToHome ?? () {},
        onBackToWriteWindow: () {
          widget.setWriteWindowNext(
            WriteWindow(
              setWriteWindowNext: widget.setWriteWindowNext,
              diaryModel: DiaryModel(
                date:
                    '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
                weather: selectedWeatherIndex,
                isPublic: false,
                lat: 0.0,
                lng: 0.0,
                title: titleController.text,
                content: contentController.text,
                emotionTagIds: [],
                summaryKeywords: [],
              ),
              goBackToHome: widget.goBackToHome,
            ),
          ); // 자신으로 다시 설정
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: Padding(
        padding: const EdgeInsets.only(top: 45), // 전체 Column 위쪽에 패딩 추가
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onClickedBackButton,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 248, 229),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(80, 35),
                    ),
                    onPressed: onClickedNextButton,
                    child: Text('다음', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Transform.translate(
                            offset: Offset(0, 10),
                            child: Text(
                              '$year',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text('$month월 $day일', style: TextStyle(fontSize: 22)),
                          IconButton(
                            onPressed: onClickedCalanderButton,
                            icon: Icon(Icons.calendar_month_outlined),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  WeatherButton(
                    weatherIndex: selectedWeatherIndex,
                    onWeatherChanged: (index) {
                      selectedWeatherIndex = index;
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    labelText: '제목',
                    labelStyle: TextStyle(fontSize: 25, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 100),
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: contentController,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: '내용을 입력하세요.',
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
