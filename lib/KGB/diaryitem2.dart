import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryItem2 extends StatefulWidget {
  final DiaryModel diaryModel;
  final VoidCallback? onTap;
  const DiaryItem2({super.key, required this.diaryModel, this.onTap});

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
          color: Color(0xffFFCB6C),
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
                children:
                    widget.diaryModel.tags.map((emotion) {
                      return emotionTag(emotion);
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container emotionTag(String emotion) {
  return Container(
    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    decoration: BoxDecoration(
      color: Color(0xFFF8FFC2),
      borderRadius: BorderRadius.circular(45),
    ),
    child: Text("#$emotion"),
  );
}
