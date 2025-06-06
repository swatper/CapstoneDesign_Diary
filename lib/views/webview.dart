import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final String initialUrl;
  final String? redirectUrl;
  const WebViewPage({super.key, required this.initialUrl, this.redirectUrl});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController webController;

  @override
  void initState() {
    super.initState();
    // WebView 초기화
    webController =
        WebViewController() // WebViewController 초기화
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // 로딩 상태를 표시하고 싶다면 여기에 로직 추가
              },
              onPageStarted: (String url) {
                print('페이지 로드 시작: $url');
              },
              onPageFinished: (String url) {
                print('페이지 로드 완료: $url');
              },
              onWebResourceError: (WebResourceError error) {
                print('웹뷰 오류: ${error.description}');
              },
              onNavigationRequest: (NavigationRequest request) async {
                //senti://로 시작하는 URL이라면 Flutter 앱으로 전달
                if (request.url.startsWith('senti://')) {
                  //시스템이 이 딥링크를 처리할 수 있는 앱(우리의 Flutter 앱)을 찾아 실행
                  if (await canLaunchUrl(Uri.parse(request.url))) {
                    await launchUrl(
                      Uri.parse(request.url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: webController));
  }
}
