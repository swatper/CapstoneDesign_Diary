import 'package:capstone_diary/KGB/emotiontag.dart';
import 'package:capstone_diary/KGB/summarytag.dart';
import 'package:capstone_diary/Utils/diarymanager.dart';
import 'package:capstone_diary/Views/archivewindow.dart';
import 'package:capstone_diary/KGB/weatherButton.dart';
import 'package:capstone_diary/KGB/writewindow.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/GoogleMap/locationconverter.dart';
import 'package:flutter/material.dart';

class DiaryView extends StatefulWidget {
  final DiaryModel diaryModel;
  final void Function(Widget) setWriteWindow;
  final Function(Widget) goBackToArchive;
  const DiaryView({
    super.key,
    required this.diaryModel,
    required this.setWriteWindow,
    required this.goBackToArchive,
  });

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  get onClickedBackButton => null;
  String curAddress = "부산 어디구 강호동";

  void onSelectedDelete() {
    print("삭제하기");
    DiaryManager().deleteDiaryById(widget.diaryModel.diaryId);
    widget.goBackToArchive(
      ArchiveWindow(key: UniqueKey(), selectDiary: widget.setWriteWindow),
    );
  }

  void setDiaryLocationInfo() async {
    curAddress = await LocationConverter.instance.getLocationInfo(
      widget.diaryModel.lat,
      widget.diaryModel.lng,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDiaryLocationInfo();
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate =
        DateTime.tryParse(widget.diaryModel.date) ?? DateTime.now();
    void onSelectedEdit() {
      widget.setWriteWindow(
        WriteWindow(
          diaryId: widget.diaryModel.diaryId,
          isEditMode: true,
          diaryModel: widget.diaryModel,
          goBackToHome: () async {
            DiaryModel editedDiary = await DiaryManager().getDiaryById(
              widget.diaryModel.diaryId,
            );
            widget.setWriteWindow(
              DiaryView(
                diaryModel: editedDiary,
                setWriteWindow: widget.setWriteWindow,
                goBackToArchive: widget.goBackToArchive,
              ),
            );
          },
          setWriteWindowNext: (Widget nextPage) {
            widget.setWriteWindow(nextPage); // WriteWindowNext로 이동
          },
        ),
      );
    }

    void onClickedBackButton() {
      widget.goBackToArchive(ArchiveWindow(selectDiary: widget.setWriteWindow));
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
                    weatherIndex: widget.diaryModel.weather,
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
                      widget.diaryModel.title,
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
                        widget.diaryModel.content,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.black, thickness: 1),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          ...widget.diaryModel.summaryKeywords.map(
                            (keyword) => SummaryTag(summary: keyword),
                          ),
                          ...widget.diaryModel.emotionTagIds.map(
                            (id) => EmotionTag(emotionIndex: id),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.black, thickness: 1),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 248, 229),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(
                              curAddress,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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
