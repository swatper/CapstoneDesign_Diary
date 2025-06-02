import 'package:flutter/material.dart';
import 'package:capstone_diary/views/webview.dart';
import 'package:capstone_diary/Utils/assetmanager.dart';
import 'package:capstone_diary/Utils/datamanager.dart';

class LoginWindow extends StatefulWidget {
  final Function(bool) onLogin;
  const LoginWindow({super.key, required this.onLogin});

  @override
  State<LoginWindow> createState() => _LoginWindowState();
}

class _LoginWindowState extends State<LoginWindow> {
  @override
  void initState() {
    initLoginCheck();
    super.initState();
  }

  void initLoginCheck() async {
    //로그인 상태 확인
    if (await Datamanager().getData("is_logged_in") == "true") {
      widget.onLogin(true);
    } else {
      saveLoginState(false);
    }
  }

  void guestLogin() {
    //게스트 로그인
    widget.onLogin(true);
    Datamanager().saveData("is_logged_in", true, false);
  }

  void kakaoLogin() async {
    String kakaoLoginUrl = "https://www.kakaocorp.com/page/";
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(initialUrl: kakaoLoginUrl),
      ),
    ).then((value) {
      //웹뷰에서 로그인 후 돌아왔을 때
      if (value != null && value is bool) {
        if (value) {
          widget.onLogin(true);
          saveLoginState(true);
        } else {
          widget.onLogin(false);
        }
      }
    });
  }

  //로그인 성공 시
  void saveLoginState(bool setLoginStatus) async {
    Datamanager().saveData("is_logged_in", setLoginStatus, true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height /*- kBottomNavigationBarHeight*/,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "로그인",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            Text("나만의 맞춤 경험을 시작하세요!", style: TextStyle(fontSize: 20)),
            //로그인 버튼
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: GestureDetector(
                      onTap: kakaoLogin,
                      child: AssetManager.instance.getEtcImage(
                        "kakao_login.png",
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: guestLogin,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 25),
                          Text(
                            "게스트 로그인",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
