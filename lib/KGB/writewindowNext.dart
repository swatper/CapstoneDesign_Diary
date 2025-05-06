import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:flutter/material.dart';

import 'writewindow.dart';

class WriteWindowNext extends StatefulWidget {
  final VoidCallback onBackToWriteWindow;
  final int year;
  final int month;
  final int day;
  final int weatherIndex;
  final String title;
  final String diaryContent;

  const WriteWindowNext({
    super.key,
    required this.year,
    required this.month,
    required this.day,
    required this.weatherIndex,
    required this.title,
    required this.diaryContent,
    required this.onBackToWriteWindow,
  });

  @override
  State<WriteWindowNext> createState() => _WriteeWindowNextState();
}

class _WriteeWindowNextState extends State<WriteWindowNext> {
  void onClickedBackButton() {
    widget.onBackToWriteWindow();
  }

  bool isPublic = false; // 공개 여부 상태 변수
  void onClickedCompleteButton() {
    // DB 저장 로직 추가
    print('저장 완료: ${widget.title}, ${widget.diaryContent}');
    Navigator.pop(context); // 저장 후 이전 화면으로 돌아가기
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
              // 상단 뒤로가기 및 완료 버튼
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
                    onPressed: onClickedCompleteButton,
                    child: Text('완료', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
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
                              widget.year.toString(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            '${widget.month}월 ${widget.day}일',
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  WeatherButton(
                    weatherIndex: widget.weatherIndex,
                    isButtonActive: false,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: TextStyle(fontSize: 22)),
                    Divider(
                      color: Colors.black, // 선 색상
                      thickness: 1, // 선 두께
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.diaryContent, style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Divider(
                      color: Colors.black, // 선 색상
                      thickness: 0.8, // 선 두께
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 280),
                  Container(
                    width: 85,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // 버튼 배경색
                      borderRadius: BorderRadius.circular(50), // 버튼 모서리 둥글게
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 그림자 색상
                          spreadRadius: 1, // 그림자 확산 정도
                          blurRadius: 5, // 그림자 흐림 정도
                          offset: Offset(2, 2), // 그림자 위치 (x, y)
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        // 버튼 클릭 시 동작 추가
                        print('텍스트 버튼 클릭됨');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10), // 내부 패딩
                        minimumSize: Size(40, 20), // 버튼 크기
                      ),
                      child: Text(
                        'AI 태그 생성',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12, // 텍스트 크기
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/emotion_icon1.png',
                          width: 25,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 10),
                        Text('감정', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              print('아이콘 버튼 클릭됨');
                            },
                            icon: Icon(
                              Icons.add_circle_outlined, // 아이콘 종류
                              size: 30, // 아이콘 크기
                              color: Colors.amber, // 아이콘 색상,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[400], // 버튼 배경색
                            borderRadius: BorderRadius.circular(
                              50,
                            ), // 버튼 모서리 둥글게
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            child: Text(
                              '#즐거움',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14, // 텍스트 크기
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey, // 선 색상
                      thickness: 0.8, // 선 두께
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/book.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                        Text('요약', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              print('아이콘 버튼 클릭됨');
                            },
                            icon: Icon(
                              Icons.add_circle_outlined, // 아이콘 종류
                              size: 30, // 아이콘 크기
                              color: Colors.amber, // 아이콘 색상,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.amber[400], // 버튼 배경색
                            borderRadius: BorderRadius.circular(
                              50,
                            ), // 버튼 모서리 둥글게
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            child: Text(
                              '#',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14, // 텍스트 크기
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey, // 선 색상
                      thickness: 0.8, // 선 두께
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/eye.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                        Text('공개 여부', style: TextStyle(fontSize: 20)),
                        Spacer(),
                        Switch(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value; // 상태 변경
                            });
                          },
                          activeColor: Colors.amber, // 활성 상태 색상
                          inactiveThumbColor: Colors.grey, // 비활성 상태 색상
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey, // 선 색상
                      thickness: 0.8, // 선 두께
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/mapicon.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 5),
                        Text('위치', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 248, 229),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: Size(80, 35),
                      ),
                      onPressed: () {},
                      child: Text(
                        '부산 부산진구 가야대로 567 상가 5동',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Divider(
                      color: Colors.grey, // 선 색상
                      thickness: 0.8, // 선 두께
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
