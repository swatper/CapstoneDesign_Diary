import 'dart:async';
import 'package:capstone_diary/Utils/toastmessage.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
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
  StreamSubscription? linkSubscription;

  @override
  void initState() {
    initLoginCheck();
    initBackendCallbackListener();
    super.initState();
  }

  @override
  void dispose() {
    // 위젯이 dispose될 때 스트림 구독 취소
    linkSubscription?.cancel();
    super.dispose();
  }

  //백엔드 콜백 리스너 초기화
  Future<void> initBackendCallbackListener() async {
    final appLinks = AppLinks(); // AppLinks 인스턴스 생성

    //앱이 백그라운드에 있거나 실행 중인 상태에서 딥링크로 들어올 경우 처리
    linkSubscription = appLinks.uriLinkStream.listen(
      (Uri uri) {
        // uni_links와 달리 AppLinks는 Uri 객체를 직접 반환합니다.
        handleBackendCallbackLink(uri.toString()); // URI 객체를 String으로 변환하여 전달
      },
      onError: (err) {
        print("링크 스트리밍 오류: $err");
      },
    );
  }

  void handleBackendCallbackLink(String link) {
    Uri uri = Uri.parse(link);
    //Senti://kakao_login?jwt=... 패턴 찾기
    if (uri.scheme == 'senti' && uri.host == 'kakao_login') {
      String? jwt = uri.queryParameters['token'];
      String? username = uri.queryParameters['nickname'];
      if (jwt != null && jwt.isNotEmpty) {
        showToastMessage('백엔드로부터 JWT 수신: $jwt \n 닉네임: $username');
        Datamanager().saveToken(jwt);
        Datamanager().saveData("username", username, false);
        saveLoginState(true);
        widget.onLogin(true);
      } else {
        showToastMessage('JWT가 파라미터에 없거나 비어있습니다.');
      }
    }
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
    print("로그인 누름");
    String kakaoLoginUrl =
        "https://joint-cheetah-helpful.ngrok-free.app/SentiDiary";
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(initialUrl: kakaoLoginUrl),
      ),
    );
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
