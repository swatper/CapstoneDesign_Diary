import 'package:flutter/material.dart';

class ProfileWindow extends StatefulWidget {
  final Function(int) backButtonEvent;
  const ProfileWindow({super.key, required this.backButtonEvent});

  @override
  State<ProfileWindow> createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow> {
  TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle infoStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  void backToHomeWindow() {
    widget.backButtonEvent(0); //메인 화면으로 돌아가기
  }

  void editProfile() {}

  @override
  void initState() {
    super.initState();
    //프로필 정보 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          //제목 부분
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: backToHomeWindow,
                icon: Icon(Icons.arrow_back_sharp, color: Color(0xffFC8650)),
              ),
              Text(
                "프로필",
                style: TextStyle(color: Color(0xffFC8650), fontSize: 45),
              ),
              SizedBox(width: 60),
            ],
          ),
          Divider(color: Color(0xffFC8650), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: editProfile,
                icon: Icon(Icons.border_color_sharp, color: Colors.grey),
              ),
            ],
          ),
          Image.asset(
            "assets/images/default.png",
            width: 130,
            height: 130,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Color(0xff919572), thickness: 2),
                //닉네임 설정
                infomationSet("닉네임", "tester"),
                Divider(color: Color(0xff919572), thickness: 2),
                //이메일
                infomationSet("이메일", "abcd@gmail.com"),
                Divider(color: Color(0xff919572), thickness: 2),
                //비밀번호
                infomationSet("비밀번호", "********"),
                Divider(color: Color(0xff919572), thickness: 2),
                //뱃지
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("뱃지", style: titleStyle),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/default.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Color(0xff919572), thickness: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding infomationSet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
      child: Row(
        children: [
          Text(title, style: titleStyle),
          SizedBox(width: 20),
          Text(value, style: infoStyle),
        ],
      ),
    );
  }
}
