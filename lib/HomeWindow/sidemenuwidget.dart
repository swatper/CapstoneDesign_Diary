import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(int) sideMenuSelectedIndex;
  const SideMenuWidget({super.key, required this.sideMenuSelectedIndex});
  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  void initState() {
    super.initState();
    //앱 시작 시 도전 과제 달성도 가져오기
  }

  @override
  Widget build(BuildContext context) {
    String appVersion = "1.0.0";
    Color infoColor1 = Color(0xff33363F);
    Color infoColor2 = Color(0xff757575);
    double lineThickness = 2.0;
    double titleSize = 12.0;
    double infoSize = 16.0;
    FontWeight fontWeightSet = FontWeight.w300;

    void selectSideMenu(int index) {
      widget.sideMenuSelectedIndex(index);
      showToastMessage("아직 미구현");
      Navigator.pop(context);
    }

    return Stack(
      children: [
        //반투명 검은 배경
        GestureDetector(
          onTap: () => Navigator.pop(context), //배경 클릭 시 닫힘
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        //메뉴 배경
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: Color(0xffF8FFC2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            //메뉴 내용
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                margin: EdgeInsets.only(top: 10),
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "닉네임 재설정",
                          style: TextStyle(
                            color: infoColor1,
                            fontSize: infoSize,
                            fontWeight: fontWeightSet,
                          ),
                        ),
                        IconButton(
                          onPressed: () => selectSideMenu(5),
                          icon: Icon(Icons.chevron_right_sharp),
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "알람 설정",
                          style: TextStyle(
                            color: infoColor1,
                            fontSize: infoSize,
                            fontWeight: fontWeightSet,
                          ),
                        ),
                        IconButton(
                          onPressed: () => selectSideMenu(6),
                          icon: Icon(Icons.chevron_right_sharp),
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "약관 및 정책",
                          style: TextStyle(
                            color: infoColor1,
                            fontSize: infoSize,
                            fontWeight: fontWeightSet,
                          ),
                        ),
                        IconButton(
                          onPressed: () => selectSideMenu(7),
                          icon: Icon(Icons.chevron_right_sharp),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "회원 탈퇴하기",
                          style: TextStyle(
                            color: infoColor1,
                            fontSize: infoSize,
                            fontWeight: fontWeightSet,
                          ),
                        ),
                        IconButton(
                          onPressed: () => selectSideMenu(8),
                          icon: Icon(Icons.chevron_right_sharp),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "앱 버전",
                          style: TextStyle(
                            color: infoColor1,
                            fontSize: infoSize,
                            fontWeight: fontWeightSet,
                          ),
                        ),
                        Text(
                          appVersion,
                          style: TextStyle(
                            color: infoColor2,
                            fontSize: infoSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 300),
                    Divider(color: Color(0xff919572), thickness: lineThickness),
                    //기타 정보
                    Row(
                      children: [
                        Icon(
                          Icons.question_mark_outlined,
                          color: Color(0xff757575),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Help",
                          style: TextStyle(color: infoColor2, fontSize: 17),
                        ),
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
            ),
          ),
        ),
      ],
    );
  }
}
