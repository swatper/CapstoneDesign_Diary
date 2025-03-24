import 'package:flutter/material.dart';

class DiaryItem extends StatefulWidget {
  final String title;
  final String date;
  final String summary;
  final int tags;
  final List<String> emotios;

  const DiaryItem({
    super.key,
    required this.title,
    required this.date,
    required this.summary,
    required this.tags,
    required this.emotios,
  });

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
        borderRadius: BorderRadius.circular(30),
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
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
                Text(widget.date, style: TextStyle(fontSize: 15)),
              ],
            ),
            SizedBox(height: 5),
            Text(widget.summary, style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Row(
              children: [
                EmotionTag("감정1"),
                SizedBox(width: 5),
                EmotionTag("감정2"),
                SizedBox(width: 5),
                EmotionTag("장소장소"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//감정 태그
Container EmotionTag(String emotion) {
  return Container(
    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
    decoration: BoxDecoration(
      color: Color(0xFFF8FFC2),
      borderRadius: BorderRadius.circular(45),
    ),
    child: Text("#$emotion"),
  );
}
