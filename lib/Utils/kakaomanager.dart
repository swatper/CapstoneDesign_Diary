//카카오톡 SDK
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoManager {
  void initKakao() {
    //카카오톡 SDK 초기화
    KakaoSdk.init(nativeAppKey: '네이티브키');
  }

  //Future<void> doKakaoLogin() {}
}
