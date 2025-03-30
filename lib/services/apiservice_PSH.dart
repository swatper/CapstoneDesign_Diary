import 'dart:convert';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:http/http.dart' as http;

class ApiservicePsh {
  final String diaryURL = "";
  final String targetDate = "YYYY-MM-DD";

  void getdiaryList() async {
    final url = Uri.parse(diaryURL + targetDate);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //json파일 읽어서 list형태로 변환
      final List<dynamic> diayList = jsonDecode(response.body);
      //list 안에 있는 내용의 객체화
      for (var diary in diayList) {
        DirayModel.fromJson(diary);
      }
    } else {
      print("실패");
      return;
    }
  }
}
