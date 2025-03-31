import 'package:flutter/material.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryItem extends StatefulWidget {
  final DirayModel diaryModel;

  const DiaryItem({super.key, required this.diaryModel});

  @override
  State<DiaryItem> createState() => _DiaryItemState();
}

class _DiaryItemState extends State<DiaryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        color: Color(0xffFFCB6C),
        borderRadius: BorderRadius.circular(25),
      ),
      //내용
      child: Container(
        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //제목
                Expanded(
                  child: Text(
                    widget.diaryModel.title,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //날짜
                Text(widget.diaryModel.date, style: TextStyle(fontSize: 15)),
              ],
            ),
            SizedBox(height: 5),
            //내용
            Text(
              widget.diaryModel.content,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
            SizedBox(height: 10),
            //태그
            Row(
              children:
                  widget.diaryModel.tags
                      .map(
                        (emotion) => Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: emotionTag(emotion),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

//감정 태그
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
