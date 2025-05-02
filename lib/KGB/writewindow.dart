import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:capstone_diary/KGB/writewindowNext.dart';
import 'package:flutter/material.dart';

class WriteWindow extends StatefulWidget {
  final Function(Widget) setWriteWindowNext; //글쓰기 화면간 데이터 전달을 위한 변수
  const WriteWindow({super.key, required this.setWriteWindowNext});
  @override
  State<WriteWindow> createState() => _WriteWindow();
}

void onClickedBackButton() {}

void onClickedCalanderButton() {}

class _WriteWindow extends State<WriteWindow> {
  PageController pageController = PageController();
  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController(); // 제목 입력 컨트롤러
  int selectedWeatherIndex = 1; // 1~5 사이의 숫자 (기본값 1)
  //날짜 정보
  int year = 2025;
  int month = 10;
  int day = 12;

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
                            child: Text('2025', style: TextStyle(fontSize: 15)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text('10월 12일', style: TextStyle(fontSize: 22)),
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
                  WeatherButton(),
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
