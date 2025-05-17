import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryView extends StatelessWidget {
  final DiaryModel diaryModel;

  const DiaryView({super.key, required this.diaryModel});

  get onClickedBackButton => null;
  get onClickedNextButton => null;

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.tryParse(diaryModel.date) ?? DateTime.now();

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
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 248, 229),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(80, 35),
                    ),
                    onPressed: onClickedNextButton,
                    child: const Text(
                      '다음',
                      style: TextStyle(color: Colors.black),
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
