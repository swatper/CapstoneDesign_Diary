import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Calender/sidemenuwidget.dart';

class SharedDiary extends StatefulWidget {
  final Function(int) sideMenuToHomeWindowIndex;
  final Function(bool) logOutCallback;
  const SharedDiary({
    super.key,
    required this.sideMenuToHomeWindowIndex,
    required this.logOutCallback,
  });

  @override
  State<SharedDiary> createState() => _SharedDiaryState();
}

class _SharedDiaryState extends State<SharedDiary> {
  bool isLiked = false;
  bool isLoaded = false; // <-- 추가됨

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
              logOutCallback: widget.logOutCallback,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DiaryModel diaryModel = DiaryModel(
      // 예시로 일기 ID를 설정
      diaryId: 0,
      title: '오늘의 일기',
      content:
          '오늘은 정말 좋은 날이었어요! 친구들과 함께 시간을 보내고, 맛있는 음식을 먹었답니다. 날씨도 맑고 화창해서 기분이 좋았어요.',
      date: '2025-05-10',
      summaryKeywords: ['행복', '친구', '맛집'],
      weather: 1, // 예시로 날씨를 설정
      emotionTagIds: [1, 2], // 예시로 감정 태그 ID를 설정
      isPublic: true,
      lat: 37.5665, // 예시로 위도 설정
      lng: 126.978, // 예시로 경도 설정
    );

    return Scaffold(
      backgroundColor: const Color(0xffFFE4B5),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child:
              isLoaded
                  ? _buildDiaryContent(diaryModel) // 일기 내용 전체
                  : _buildLoadingView(), // 처음 진입 시 보여줄 뷰
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: showMenu,
                icon: const Icon(Icons.menu, size: 35),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Divider(color: Colors.black, thickness: 1, indent: 20, endIndent: 20),
          Image.asset(
            'assets/images/sharedirayIcon.png', // 원하는 이미지 경로
            width: 300,
            height: 300,
          ),
          const Text(
            '다른 사람의 일기를 들춰보세요.',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          Divider(color: Colors.black, thickness: 1, indent: 20, endIndent: 20),
          TextButton(
            onPressed: () {
              setState(() {
                isLoaded = true;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[400],
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              '불러오기',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryContent(DiaryModel diaryModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        //상단 바
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
                      child: const Text('2025', style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text('5월 10일', style: TextStyle(fontSize: 22)),
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
                diaryModel.title,
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

        // 내용 + 태그 + 버튼
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
                          style: const TextStyle(fontSize: 16, height: 1.6),
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
                            // 태그
                            Expanded(
                              flex: 15,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children:
                                      diaryModel.emotionTagIds.map((tag) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber[400],
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
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

                            // 버튼
                            Flexible(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                      // 불러오기 버튼 눌렀을 때 동작
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[400],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: const Text(
                                      '불러\n오기',
                                      style: TextStyle(
                                        color: Colors.black,
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
    );
  }
}
