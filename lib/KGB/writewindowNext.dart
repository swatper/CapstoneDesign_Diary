import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/KGB/aitaggenerator.dart';
import 'package:capstone_diary/KGB/emotionTag.dart';
import 'package:capstone_diary/KGB/summarytag.dart';
import 'package:capstone_diary/KGB/weatherbutton.dart';
import 'package:flutter/material.dart';

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
  bool _isTagButtonEnabled = true;
  List<int> selectedEmotions = [];
  List<String> selectedSummaries = [];
  List<IconData> emotionIcons = [
    Icons.sentiment_satisfied_alt_rounded, // 0. 기쁨
    Icons.sentiment_very_satisfied_rounded, // 1. 행복
    Icons.move_to_inbox_rounded, // 2. 설렘
    Icons.sentiment_very_satisfied, // 3. 화남
    Icons.sentiment_very_dissatisfied, // 4. 우울함
    Icons.mood, // 5. 슬픔
    Icons.mood_bad, // 6. 불안
    Icons.face, // 7. 놀람
    Icons.tag_faces, // 8. 부끄러움
    Icons.exposure_neg_1, // 9. 지루함
  ];
  List<String> emotionLabels = [
    '기쁨',
    '행복',
    '설렘',
    '화남',
    '우울함',
    '슬픔',
    '불안',
    '놀람',
    '부끄러움',
    '지루함',
  ];
  bool isPublic = false; // 공개 여부 상태 변수

  void onClickedBackButton() {
    widget.onBackToWriteWindow();
  }

  void onClickedCompleteButton() {
    // DB 저장 로직 추가
  }

  Future<void> genrateTags() async {
    if (!_isTagButtonEnabled) return; // 태그 버튼이 비활성화된 경우 실행하지 않음
    setState(() {
      _isTagButtonEnabled = false;
    });

    final aiTagGenerator = AiTagGenerator();

    final diary = DiaryModel(
      '2025-05-25',
      widget.weatherIndex,
      true,
      35.1796,
      129.0756,
      title: widget.title,
      content: widget.diaryContent,
      tags: [],
    );
    try {
      final tags = await aiTagGenerator.generateTags(diary);

      final List<int> aiEmotions =
          (tags['emotions'] as List)
              .whereType<int>()
              .where((e) => e >= 0 && e < emotionLabels.length)
              .toList();

      final List<String> aiSummaries =
          (tags['summaries'] as List).whereType<String>().toList();

      setState(() {
        for (final emotion in aiEmotions) {
          if (!selectedEmotions.contains(emotion)) {
            selectedEmotions.add(emotion);
          }
        }

        for (final summary in aiSummaries) {
          if (!selectedSummaries.contains(summary)) {
            selectedSummaries.add(summary);
          }
        }
      });

      print('감정 태그: $aiEmotions');
      print('요약 태그: $aiSummaries');
    } catch (e) {
      print('태그 생성 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                        child: Text(
                          '완료',
                          style: TextStyle(color: Colors.black),
                        ),
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
                        Text(
                          widget.diaryContent,
                          style: TextStyle(fontSize: 18),
                        ),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 28, // 너무 작으면 텍스트 잘려요
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            print('selectedEmotions: $selectedEmotions');
                            print('selectedSummaries: $selectedSummaries');
                            genrateTags();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(40, 20),
                          ),
                          child: Text(
                            'AI 태그 생성',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
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
                            // 왼쪽에 고정된 아이콘 버튼
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _showEmotionPicker(); // 감정 선택 다이얼로그 호출
                                  print('아이콘 버튼 클릭됨');
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            // 감정 태그들
                            Expanded(
                              child: Wrap(
                                spacing: 8, // 태그들 간의 간격
                                runSpacing: 8, // 줄 바꿈 시 간격
                                children:
                                    selectedEmotions.map((index) {
                                      return EmotionTag(
                                        emotionIndex: index,
                                        onDelete: () {
                                          setState(() {
                                            selectedEmotions.remove(index);
                                          });
                                        },
                                      );
                                    }).toList(),
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
                            // 왼쪽에 고정된 아이콘 버튼
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _showSummaryTagPicker(); // 요약 태그 선택 다이얼로그 호출
                                  print('요약 태그 버튼 클릭됨');
                                },
                                icon: Icon(
                                  Icons.add_circle_outlined,
                                  size: 30,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            // 요약 태그들
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    selectedSummaries.map((summary) {
                                      return SummaryTag(
                                        summary: summary,
                                        onDelete: () {
                                          setState(() {
                                            selectedSummaries.remove(
                                              summary,
                                            ); // 삭제할 항목을 리스트에서 제거
                                          });
                                        },
                                      );
                                    }).toList(),
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
        ),
      ),
    );
  }

  void _showSummaryTagPicker() async {
    final TextEditingController controller = TextEditingController();

    String? newTag = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("요약 태그를 입력하세요"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '예: 여행, 공부, 친구와의 대화 등',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 아무 것도 입력하지 않고 닫기
              child: Text("취소"),
            ),
            ElevatedButton(
              onPressed: () {
                final input = controller.text.trim();
                if (input.isNotEmpty) {
                  Navigator.pop(context, input); // 입력한 텍스트 전달
                }
              },
              child: Text("추가"),
            ),
          ],
        );
      },
    );

    if (newTag != null &&
        newTag.isNotEmpty &&
        !selectedSummaries.contains(newTag)) {
      setState(() {
        selectedSummaries.add(newTag);
      });
    }
  }

  void _showEmotionPicker() async {
    int? picked = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("감정을 선택하세요"),
          content: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(10, (index) {
              return TextButton.icon(
                onPressed: () => Navigator.pop(context, index),
                // icon: Icon(
                //   emotionIcons[index],
                //   color: Colors.primaries[index % Colors.primaries.length],
                // ),
                label: Text(
                  emotionLabels[index],
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors
                          .primaries[index % Colors.primaries.length]
                          .shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }),
          ),
        );
      },
    );
    if (picked != null && !selectedEmotions.contains(picked)) {
      setState(() {
        selectedEmotions.add(picked);
      });
    }
  }

  // Widget _buildEmotionSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Wrap(
  //       alignment: WrapAlignment.start,
  //       children: [
  //         SizedBox(height: 15),
  //         SizedBox(height: 10),
  //         Wrap(
  //           spacing: 10,
  //           runSpacing: 10,
  //           children: [
  //             ...selectedEmotions.map(
  //               (index) => EmotionTag(emotionIndex: index),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
