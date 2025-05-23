import 'package:flutter/material.dart';
import 'package:capstone_diary/Items/challengeitem.dart';

class ChallengeWindow extends StatefulWidget {
  const ChallengeWindow({super.key});
  @override
  State<ChallengeWindow> createState() => _ChallengeWindowState();
}

class _ChallengeWindowState extends State<ChallengeWindow> {
  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "도전과제",
              style: TextStyle(color: Color(0xffFC8650), fontSize: 45),
            ),
            Divider(color: Color(0xffFC8650), thickness: 1),
            SizedBox(height: 30),
            ChallengeItem(
              title: "도전과제",
              description: "달성조건",
              currentProgress: 0,
              maxProgress: 1,
              imageName: "newbie.png",
            ),
          ],
        ),
      ),
    );
  }
}
