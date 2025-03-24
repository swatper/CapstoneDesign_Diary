import 'package:flutter/material.dart';

class ChallengeItem extends StatefulWidget {
  const ChallengeItem({super.key});

  @override
  State<ChallengeItem> createState() => _ChallengeItemState();
}

class _ChallengeItemState extends State<ChallengeItem> {
  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        color: Color(0xffFFCB6C),
        borderRadius: BorderRadius.circular(30),
      ),
      //도전과제 항목
      child: Row(
        children: [
          Image.asset('assets/images/default.png', width: 100, height: 100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "도전과제 제목",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              Text(
                "달성조건",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              //달성도
              Row(
                children: [
                  /*Expanded(
                    child: LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.grey[300],
                      color: Color(0xffA7ECF9),
                      minHeight: 8,
                    ),
                  ),*/
                  Text("0/0"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
