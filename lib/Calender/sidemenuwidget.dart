import 'package:flutter/material.dart';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:capstone_diary/Utils/assetmanager.dart';
import 'package:capstone_diary/Utils/datamanager.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(int) sideMenuSelectedIndex;
  final Function(bool) logOutCallback;
  const SideMenuWidget({
    super.key,
    required this.sideMenuSelectedIndex,
    required this.logOutCallback,
  });
  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  String userName = "???";
  @override
  void initState() {
    super.initState();
    setUserName();
  }

  void setUserName() async {
    userName = await Datamanager().getData("user_Name");
    setState(() {});
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
      Navigator.pop(context);
    }

    @override
    void didUpdateWidget(SideMenuWidget oldWidget) {
      super.didUpdateWidget(oldWidget);
      setUserName();
    }

    void logout() {
      //로그아웃 처리
      Datamanager().saveData("is_logged_in", false, false);
      Datamanager().removeData("userName");
      Datamanager().removeToken();
      widget.logOutCallback.call(false);
      showToastMessage("로그아웃 되었습니다.");
      Navigator.pop(context);
    }

    void showLogoutDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("로그아웃"),
            content: Text("정말 로그아웃 하시겠습니까?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("취소"),
              ),
              TextButton(
                onPressed: () {
                  logout();
                  Navigator.pop(context);
                },
                child: Text("로그아웃"),
              ),
            ],
          );
        },
      );
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
            height: MediaQuery.of(context).size.height * 0.9,
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
                    //사용자 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width * 0.7 * 0.5,
                              child: Text(
                                userName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ) /*
                            Text(
                              "tester@abcdef.com",
                              style: TextStyle(color: infoColor2, fontSize: 12),
                            ),*/,
                          ],
                        ),
                        Row(
                          children: [
                            AssetManager.instance.getProfileImage(
                              'defaultpro.png',
                              52,
                              52,
                            ),
                            AssetManager.instance.getChallengeImage(
                              'default.png',
                              52,
                              52,
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
                          onPressed: () => selectSideMenu(0),
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
                          onPressed: () => selectSideMenu(1),
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
                          onPressed: () => selectSideMenu(2),
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
                          onPressed: () => selectSideMenu(3),
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
                    Expanded(child: SizedBox()),
                    Divider(color: Color(0xff919572), thickness: lineThickness),
                    //기타 정보
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => selectSideMenu(4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.question_mark_outlined,
                                  color: Color(0xff757575),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Help",
                                  style: TextStyle(
                                    color: infoColor2,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: showLogoutDialog,
                            child: Row(
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  "Logout Account",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
