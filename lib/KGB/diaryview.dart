import 'package:capstone_diary/views/archivewindow.dart';
import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:capstone_diary/KGB/writewindow.dart';
import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryView extends StatelessWidget {
  final DiaryModel diaryModel;
  final void Function(Widget) setWriteWindow;
  final Function(int) sideMenuToHomeWindowIndex;
  final Function(Widget) goBackToArchive;
  const DiaryView({
    super.key,
    required this.diaryModel,
    required this.setWriteWindow,
    required this.sideMenuToHomeWindowIndex,
    required this.goBackToArchive,
  });

  get onClickedBackButton => null;

  void onSelectedDelete() {
    print("삭제하기");
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.tryParse(diaryModel.date) ?? DateTime.now();
    void onSelectedEdit() {
      setWriteWindow(
        WriteWindow(
          isEditMode: true,
          diaryModel: diaryModel,
          goBackToHome: () {
            setWriteWindow(
              DiaryView(
                diaryModel: diaryModel,
                setWriteWindow: setWriteWindow,
                sideMenuToHomeWindowIndex: sideMenuToHomeWindowIndex,
                goBackToArchive: goBackToArchive,
              ),
            );
          },
          setWriteWindowNext: (Widget nextPage) {
            setWriteWindow(nextPage); // WriteWindowNext로 이동
          },
        ),
      );
    }

    void onClickedBackButton() {
      goBackToArchive(
        ArchiveWindow(
          sideMenuToHomeWindowIndex: sideMenuToHomeWindowIndex,
          selectDiary: setWriteWindow,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffFFE4B5),
      body: Padding(
        padding: const EdgeInsets.only(top: 45),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 바
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onClickedBackButton,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 30,
                      color: Colors.amber,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        // 수정하기 눌렀을 때
                        onSelectedEdit();
                      } else if (value == 'delete') {
                        // 삭제하기 눌렀을 때
                        onSelectedDelete();
                      }
                    },
                    offset: const Offset(0, 40), // 팝업 위치 조정 (버튼 아래로)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: const Color(0xFFFFF2DC), // 배경색 (이미지와 비슷한 밝은 베이지)
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            height: 20,
                            value: 'edit',
                            child: Text('수정하기'),
                          ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            height: 20,
                            value: 'delete',
                            child: Text('삭제하기'),
                          ),
                        ],
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.more_horiz_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 날짜 + 날씨
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
                              '${parsedDate.year}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            '${parsedDate.month}월 ${parsedDate.day}일',
                            style: const TextStyle(fontSize: 22),
                          ),
                          IconButton(
                            onPressed: null,
                            icon: const Icon(Icons.calendar_month_outlined),
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  WeatherButton(
                    weatherIndex: diaryModel.weather,
                    isButtonActive: false,
                  ),
                ],
              ),

              const SizedBox(height: 20),

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

              // 내용 + 하단 Divider를 함께 스크롤
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diaryModel.content,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.black, thickness: 1),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            diaryModel.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber[400],
                                  borderRadius: BorderRadius.circular(50),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
