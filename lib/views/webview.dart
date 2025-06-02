import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String initialUrl;
  final String? redirectUrl;
  const WebViewPage({super.key, required this.initialUrl, this.redirectUrl});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // WebView 초기화
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted) //JavaScript 허용
          /*
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                //리디렉션 URL이 설정되어 있다면 해당 URL로 이동
                if (widget.redirectUrl != null &&
                    request.url == widget.redirectUrl) {
                  Navigator.pop(context, request.url); //성공적으로 로그인되었다고 알림
                  return NavigationDecision.prevent; //현재 요청을 막음
                }
                return NavigationDecision.navigate; //다른 URL로 이동 허용
              },
            ),
          )*/
          ..loadRequest(Uri.parse(widget.initialUrl)); //초기 URL 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
