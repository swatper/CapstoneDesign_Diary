import 'package:flutter/material.dart';
import 'package:capstone_diary/challenge/challengeitem.dart';

class Challengewindow extends StatefulWidget {
  const Challengewindow({super.key});
  @override
  State<Challengewindow> createState() => _ChallengewindowState();
}

class _ChallengewindowState extends State<Challengewindow> {
  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFE4B5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
