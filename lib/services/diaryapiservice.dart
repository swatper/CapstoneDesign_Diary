import 'package:capstone_diary/Utils/datamanager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiaryApiService {
  final String baseUrl;
  final Datamanager _datamanager = Datamanager();
  static final DiaryApiService _instance = DiaryApiService._internal(
    baseUrl: 'http://localhost:8088/SentiDiary/',
  );

  factory DiaryApiService() => _instance;

  DiaryApiService._internal({required this.baseUrl});

  /// 새 일기  작성 JSON 업로드 (POST)
  Future<bool> postNewDiray(Map<String, dynamic> diaryJson) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary',
    );

    print('[POST] 요청 보낼 URL: $url');
    print('[POST] 요청 데이터: ${json.encode(diaryJson)}');

    final token = await _datamanager.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(diaryJson),
    );

    print('[POST] 응답 코드: ${response.statusCode}');
    print('[POST] 응답 본문: ${response.body}');

    return response.statusCode == 200;
  }

  /// 전체 일기 JSON 리스트 가져오기 (GET) //최신순
  Future<List<Map<String, dynamic>>> getAllDiary() async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/my',
    );

    final token = await _datamanager.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      print('[RESPONSE] UTF8 디코딩된 응답: $decoded');

      final List<dynamic> jsonList = json.decode(decoded);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      print('[ERROR] 실패한 응답 코드: ${response.statusCode}');
      throw Exception('일기 데이터를 불러오지 못했습니다.');
    }
  }

  //특정 날짜 일기 JSON 리스트 가져오기 (GET)
  Future<List<Map<String, dynamic>>> getDiaryforDate(String date) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/my/date/$date',
    );
    final token = await _datamanager.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      print('[RESPONSE] UTF8 디코딩된 응답: $decoded');

      final List<dynamic> jsonList = json.decode(decoded);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      print('[ERROR] 실패한 응답 코드: ${response.statusCode}');
      return [_getFallbackDiary()];
    }
  }

  /// 기존 일기 수정 요청 (PUT)
  Future<bool> updateDiary(int diaryId, Map<String, dynamic> diaryJson) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/$diaryId',
    );

    print('[PUT] 요청 보낼 URL: $url');
    print('[PUT] 요청 데이터: ${json.encode(diaryJson)}');

    final token = await _datamanager.getToken();
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(diaryJson),
    );

    print('[PUT] 응답 코드: ${response.statusCode}');
    print('[PUT] 응답 본문: ${response.body}');

    return response.statusCode == 200;
  }

  /// 특정 일기 1개 가져오기 (GET)
  Future<Map<String, dynamic>> getDiaryById(int diaryId) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/my/diaries/$diaryId',
    );

    print('[GET] 요청 보낼 URL: $url');
    final token = await _datamanager.getToken();
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('[GET] 응답 코드: ${response.statusCode}');
    print('[GET] 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> diary = json.decode(decoded);
      return diary;
    } else {
      throw Exception('일기 조회 실패: 상태 코드 ${response.statusCode}');
    }
  }

  /// 특정 일기 삭제 요청 (DELETE)
  Future<bool> deleteDiary(int diaryId) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/$diaryId',
    );

    print('[DELETE] 요청 보낼 URL: $url');

    final response = await http.delete(url);

    print('[DELETE] 응답 코드: ${response.statusCode}');
    print('[DELETE] 응답 본문: ${response.body}');

    return response.statusCode == 200;
  }

  /// 랜덤 공개 일기 1개 가져오기 (GET)
  Future<Map<String, dynamic>> getRandomPublicDiary() async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/random',
    );

    print('[GET - Random] 요청 보낼 URL: $url');
    final token = await _datamanager.getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[GET - Random] 응답 코드: ${response.statusCode}');
      print('[GET - Random] 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> diary = json.decode(decoded);
        return diary;
      } else {
        // 실패 시 기본 일기 JSON 리턴
        return _getFallbackDiary();
      }
    } catch (e) {
      print('[GET - Random] 요청 중 예외 발생: $e');
      return _getFallbackDiary();
    }
  }

  /// 서버 실패 시 반환할 임시 일기 JSON
  Map<String, dynamic> _getFallbackDiary() {
    print('[GET - Random] 서버 응답 실패로 기본 일기 반환');
    return {
      'id': 0,
      'title': '임시 일기입니다',
      'content': '서버에 연결할 수 없어 임시 일기를 불러왔습니다.',
      'diaryDate': '2025-06-04',
      'summaryKeywords': ['예시', '임시', '오류'],
      'weatherId': 0,
      'emotionTagIds': [1, 3],
      'viewScope': true,
      'latitude': 37.5665,
      'longitude': 126.9780,
    };
  }

  /// 사용자별 전체 요약 데이터 가져오기 (GET)
  Future<Map<String, int>> getAllSummary(String userId) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/summary/$userId',
    );

    print('[GET - Summary] 요청 보낼 URL: $url');

    final response = await http.get(url);

    print('[GET - Summary] 응답 코드: ${response.statusCode}');
    print('[GET - Summary] 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> rawMap = json.decode(decoded);

      // dynamic → int 캐스팅
      final Map<String, int> keywordMap = rawMap.map(
        (key, value) => MapEntry(key, value as int),
      );

      return keywordMap;
    } else {
      return {"임시": 1, "통신실패": 7, "임시": 5, "요약태그": 3, "에러러": 2};
    }
  }

  /// 사용자별 연/월 기준 요약 데이터 가져오기 (GET)
  Future<Map<String, int>> getMonthlySummary(
    String userId,
    int year,
    int month,
  ) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/summary/$userId/$year/$month',
    );

    print('[GET - Monthly Summary] 요청 보낼 URL: $url');

    final response = await http.get(url);

    print('[GET - Monthly Summary] 응답 코드: ${response.statusCode}');
    print('[GET - Monthly Summary] 응답 본문: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> rawMap = json.decode(decoded);

      // dynamic → int 캐스팅
      final Map<String, int> keywordMap = rawMap.map(
        (key, value) => MapEntry(key, value as int),
      );

      return keywordMap;
    } else {
      return {"임시": 1, "통신실패": 7, "에러러": 2, "요약태그": 3};
    }
  }

  ///사용자별 월 기준 감정 데이터 가져오기 (GET)
  Future<Map<String, int>> getMonthlyEmotion(String userId, String date) async {
    final url = Uri.parse(
      'https://joint-cheetah-helpful.ngrok-free.app/SentiDiary/api/diary/emotion/$userId/$date',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> rawMap = json.decode(decoded);

      // dynamic → int 캐스팅
      final Map<String, int> emotionTagMap = rawMap.map(
        (key, value) => MapEntry(key, value as int),
      );

      return emotionTagMap;
    } else {
      return {
        'joy': 1,
        'happy': 2,
        'excited': 3,
        'angry': 4,
        'depressed': 5,
        'sad': 6,
        'bored': 7,
        'surprised': 8,
        'nervous': 9,
        'shy': 10,
      };
    }
  }
}
