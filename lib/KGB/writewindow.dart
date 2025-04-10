import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:flutter/material.dart';

class WriteWindow extends StatefulWidget {
  final Function(int) backButtonCallback;
  const WriteWindow({super.key, required this.backButtonCallback});

  @override
  State<WriteWindow> createState() => _WriteWindow();
}

void onClickedNestButton() {}
void onClickedCalanderButton() {}

class _WriteWindow extends State<WriteWindow> {
  int selectedWeatherIndex = 1; // 1~5 사이의 숫자 (기본값 1)

  void onWeatherSelected(int index) {
    setState(() {
      selectedWeatherIndex = index;
    });
  }

  void onClickedBackButton() {
    widget.backButtonCallback(0); // 0은 홈 화면으로 돌아가는 인덱스
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
                    onPressed: onClickedNestButton,
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
