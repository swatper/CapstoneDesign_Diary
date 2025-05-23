import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';

class SharedDiary extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  const SharedDiary({super.key, required this.sideMenuToHomeWindowIndex});

  @override
  State<SharedDiary> createState() => _SharedDiaryState();
}

class _SharedDiaryState extends State<SharedDiary> {
  bool isLiked = false;

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
    DiaryModel diaryModel = DiaryModel(
      '2025-05-10',
      1,
      false,
      37.5665,
      126.9780,
      title: "test1",
      content: '내용 ' * 100,
      tags: List<String>.from([
        "감정1",
        "감정2",
        "감정3",
        "감정3",
        "감정3",
        "감정3",
        "감정3",
        "감정3",
        "감정3",
        "감정3",
      ]),
    );

    return Scaffold(
      backgroundColor: const Color(0xffFFE4B5),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 바
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: showMenu, icon: const Icon(Icons.menu)),
                ],
              ),
              // 날짜
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Transform.translate(
                            offset: const Offset(0, 10),
                            child: Text(
                              '2025',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text('5월 10일', style: const TextStyle(fontSize: 22)),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 5),

              // 제목
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '제목',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.black, thickness: 1),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              // 내용 + Divider + 하단 영역
              Expanded(
                child: Column(
                  children: [
                    // 내용 (스크롤)
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diaryModel.content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Divider + 하단 영역
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const Divider(color: Colors.black, thickness: 1),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  // 왼쪽 70%: 태그
                                  Expanded(
                                    flex: 15,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children:
                                            diaryModel.tags.map((tag) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber[400],
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),

                                  // 오른쪽 30%: 버튼
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Image.asset(
                                            'assets/images/icons/reportIcon.png',
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isLiked = !isLiked;
                                            });
                                          },
                                          icon: Image.asset(
                                            isLiked
                                                ? 'assets/images/icons/likeOnIcon.png'
                                                : 'assets/images/icons/likeOffIcon.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // 버튼 클릭 시 동작
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.grey[400], // 회색 배경
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                              vertical: 2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: const Text(
                                            '불러\n오기',
                                            style: TextStyle(
                                              color:
                                                  Colors
                                                      .black, // 글자색은 흰색으로 가독성 좋게
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
