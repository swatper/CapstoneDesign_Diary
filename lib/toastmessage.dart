import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message, // 표시할 메시지
    toastLength: Toast.LENGTH_SHORT, // 짧게 표시 (LONG도 가능)
    gravity: ToastGravity.BOTTOM, // 화면 아래쪽에 표시
    backgroundColor: Colors.black54, // 배경색 (반투명 검은색)
    textColor: Colors.white, // 글자색
    fontSize: 16.0, // 글자 크기
  );
}
