import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Menuwidget extends StatefulWidget {
  const Menuwidget({super.key});
  @override
  State<Menuwidget> createState() => _Menuwidget();
}

class _Menuwidget extends State<Menuwidget> {
  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
  }

  @override
  Widget build(BuildContext context) {
    Color infoColor1 = Color(0xff33363F);
    Color infoColor2 = Color(0xff757575);
    double lineThickness = 2.0;
    double titleSize = 12.0;
    double infoSize = 22.0;
    FontWeight fontWeightSet = FontWeight.w300;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF8FFC2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 10, 110, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "tester",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                    Text(
                      "tester@abcdef.com",
                      style: TextStyle(color: infoColor2, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/default.png',
                      width: 52,
                      height: 52,
                    ),
                    Image.asset(
                      'assets/images/default.png',
                      width: 52,
                      height: 52,
                    ),
                  ],
                ),
              ],
            ),
            //아래 부분 정리
            Divider(color: Color(0xff919572), thickness: lineThickness),
            Text(
              "계정 관리",
              style: TextStyle(
                color: infoColor1,
                fontSize: titleSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Text(
              "도움말",
              style: TextStyle(
                color: infoColor1,
                fontSize: infoSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Divider(color: Color(0xff919572), thickness: lineThickness),
            Text(
              "알람",
              style: TextStyle(
                color: infoColor1,
                fontSize: titleSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Text(
              "알람 설정",
              style: TextStyle(
                color: infoColor1,
                fontSize: infoSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Divider(color: Color(0xff919572), thickness: lineThickness),
            Text(
              "이용 정보",
              style: TextStyle(
                color: infoColor1,
                fontSize: titleSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Text(
              "약관 및 정책",
              style: TextStyle(
                color: infoColor1,
                fontSize: infoSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Text(
              "회원 탈퇴하기",
              style: TextStyle(
                color: infoColor1,
                fontSize: infoSize,
                fontWeight: fontWeightSet,
              ),
            ),
            Text(
              "앱 버전",
              style: TextStyle(
                color: infoColor1,
                fontSize: infoSize,
                fontWeight: fontWeightSet,
              ),
            ),
            SizedBox(height: 300),
            Divider(color: Color(0xff919572), thickness: lineThickness),
            Row(
              children: [
                Icon(Icons.question_mark_outlined, color: Color(0xff757575)),
                SizedBox(width: 10),
                Text("Help", style: TextStyle(color: infoColor2, fontSize: 17)),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  "Logout Account",
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
