import 'package:flutter/material.dart';
import 'package:capstone_diary/Items/challengeitem.dart';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Utils/diarymanager.dart';

class ChallengeWindow extends StatefulWidget {
  const ChallengeWindow({super.key});
  @override
  State<ChallengeWindow> createState() => _ChallengeWindowState();
}

class _ChallengeWindowState extends State<ChallengeWindow> {
  int totalDiaries = 0;
  int sharedDiaries = 0;

  void setDiaryCount() async {
    //일기 개수 가져오기
    try {
      List<DiaryModel> diaries = await DiaryManager().fetchAllDiaries();
      totalDiaries = diaries.length;
      for (DiaryModel model in diaries) {
        if (model.isPublic) {
          sharedDiaries += 1;
        }
      }
    } catch (e) {
      print('[ERROR] 일기 불러오기 실패: $e');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
    setDiaryCount();
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
              title: "도전과제 샘플",
              description: "달성조건",
              currentProgress: 0,
              maxProgress: 1,
              imageName: "default.png",
            ),
            SizedBox(height: 20),
            ChallengeItem(
              title: "시작하기",
              description: "일기 10개 작성",
              currentProgress: totalDiaries >= 10 ? 10 : totalDiaries,
              maxProgress: 10,
              imageName: "newbie.png",
            ),
            SizedBox(height: 20),
            ChallengeItem(
              title: "나는 사관이다",
              description: "일기 100개 작성",
              currentProgress: totalDiaries >= 100 ? 100 : totalDiaries,
              maxProgress: 100,
              imageName: "default.png",
            ),
            SizedBox(height: 20),
            ChallengeItem(
              title: "Hello World!!",
              description: "첫 공유일기 작성하기",
              currentProgress: sharedDiaries >= 1 ? 1 : totalDiaries,
              maxProgress: 1,
              imageName: "share.png",
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
