import 'package:capstone_diary/KGB/emotiontag.dart';
import 'package:capstone_diary/KGB/summarytag.dart';
import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryItem2 extends StatefulWidget {
  final DiaryModel diaryModel;
  final int diaryId;
  final VoidCallback? onTap;
  const DiaryItem2({
    super.key,
    required this.diaryModel,
    this.onTap,
    required this.diaryId,
  });

  @override
  State<DiaryItem2> createState() => _DiaryItemState2();
}

class _DiaryItemState2 extends State<DiaryItem2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // 🔹 탭 감지
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 188, 111),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 + 날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.diaryModel.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(widget.diaryModel.date, style: TextStyle(fontSize: 15)),
                ],
              ),
              SizedBox(height: 5),
              // 내용
              Text(
                widget.diaryModel.content,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
              SizedBox(height: 10),
              // 태그
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  // 요약 태그
                  ...widget.diaryModel.summaryKeywords.map((keyword) {
                    return SummaryTag(
                      summary: keyword,
                      onDelete: null, // 삭제 기능 없으면 null 또는 생략
                    );
                  }),

                  // 감정 태그
                  ...widget.diaryModel.emotionTagIds.map((id) {
                    return EmotionTag(
                      emotionIndex: id,
                      onDelete: null, // 삭제 기능 없으면 null
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
