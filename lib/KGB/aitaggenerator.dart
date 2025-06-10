import 'dart:convert';
import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AiTagGenerator {
  static final String _openAiApiKey =
      dotenv.env['OPENAI_API_KEY'] ?? ''; // 여기에 실제 API 키를 넣으세요

  Future<Map<String, dynamic>> generateTags(DiaryModel diary) async {
    print('불러온 API 키: $_openAiApiKey');
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_openAiApiKey',
    };

    final prompt = '''
다음은 일기입니다:

제목: ${diary.title}
날짜: ${diary.date}
내용: ${diary.content}

이 일기의 감정 태그(emotions)와 요약 태그(summaries)를 각각 3개 이내로 JSON 형태로 만들어줘.
요약 태그의 길이는 10자 이내로 하고,
감정 태그는 아래 목록에서 골라 번호로 응답해줘 (숫자 리스트로만 반환):
1. 기쁨
2. 행복
3. 설렘
4. 화남
5. 우울함
6. 슬픔
7. 불안
8. 놀람
9. 부끄러움
10. 지루함

예시 응답:
{
  "emotions": [2, 3],
  "summaries": ["여행", "가족", "자연"]
}
''';

    final body = jsonEncode({
      "model": "gpt-4",
      "messages": [
        {"role": "user", "content": prompt},
      ],
      "temperature": 0.7,
    });

    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final decoded = jsonDecode(decodedBody);
      final content = decoded['choices'][0]['message']['content'];

      try {
        return jsonDecode(content);
      } catch (e) {
        print('OpenAI 응답 파싱 실패. 원문 출력:\n$content');
        throw Exception('OpenAI 응답을 JSON으로 파싱할 수 없습니다.');
      }
    } else {
      throw Exception(
        'OpenAI API 호출 실패: ${response.statusCode} ${response.body}',
      );
    }
  }
}
