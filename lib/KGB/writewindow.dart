import 'package:capstone_diary/KGB/weatherbutton.dart';
import 'package:capstone_diary/KGB/writewindowNext.dart';
import 'package:flutter/material.dart';

class WriteWindow extends StatefulWidget {
  final Function(Widget) setWriteWindowNext;
  final VoidCallback goBackToHome; //글쓰기 화면간 데이터 전달을 위한 변수
  WriteWindow({
    super.key,
    required this.setWriteWindowNext,
    required this.goBackToHome,
    this.initialYear,
    this.initialMonth,
    this.initialDay,
    this.initialWeatherIndex,
    this.initialTitle,
    this.initialContent,
  });
  @override
  State<WriteWindow> createState() => _WriteWindow();

  int? initialYear;
  int? initialMonth;
  int? initialDay;
  int? initialWeatherIndex;
  String? initialTitle;
  String? initialContent;
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
      text: widget.initialContent ?? '',
    );
    titleController = TextEditingController(text: widget.initialTitle ?? '');
    selectedWeatherIndex = widget.initialWeatherIndex ?? 0;
    year = widget.initialYear ?? today.year;
    month = widget.initialMonth ?? today.month;
    day = widget.initialDay ?? today.day;
  }

  void onClickedBackButton() {
    // 뒤로가기 버튼 클릭 시 이전 화면으로 이동
    widget.goBackToHome();
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
        onBackToWriteWindow: () {
          widget.setWriteWindowNext(
            WriteWindow(
              setWriteWindowNext: widget.setWriteWindowNext,
              goBackToHome: widget.goBackToHome,
              initialContent: contentController.text,
              initialTitle: titleController.text,
              initialYear: year,
              initialMonth: month,
              initialDay: day,
              initialWeatherIndex: selectedWeatherIndex,
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
