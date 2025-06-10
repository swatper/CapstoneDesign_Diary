import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Utils/diarymapper.dart';
import 'package:capstone_diary/services/diaryapiservice.dart';

class DiaryManager {
  static final DiaryManager _instance = DiaryManager._internal();
  final DiaryApiService _apiService = DiaryApiService();

  factory DiaryManager() => _instance;

  DiaryManager._internal();

  /// 전체 일기 리스트를 DiaryModel 리스트로 가져오기
  Future<List<DiaryModel>> fetchAllDiaries() async {
    final jsonList = await _apiService.getAllDiary();
    print('[FETCH] 받아온 원시 JSON 리스트: $jsonList');

    final diaries = jsonList.map((json) => DiaryMapper.fromJson(json)).toList();
    print('[FETCH] 변환된 DiaryModel 리스트: $diaries');

    return diaries;
  }

  //특정 날짜 일기 가져오기
  Future<List<DiaryModel>> fetchDiaryForDate(String date) async {
    final jsonList = await _apiService.getDiaryforDate(date);
    print('[FETCH] 받아온 원시 JSON 리스트: $jsonList');

    final diaries = jsonList.map((json) => DiaryMapper.fromJson(json)).toList();
    print('[FETCH] 변환된 DiaryModel 리스트: $diaries');

    return diaries;
  }

  //필터링된 일기 가져오기
  Future<List<DiaryModel>> fetchDiariesWithFilter(
    String option,
    String value,
  ) async {
    final jsonList = await _apiService.getDiaryWithFilter(option, value);
    print('[FETCH] 받아온 원시 JSON 리스트: $jsonList');

    final diaries = jsonList.map((json) => DiaryMapper.fromJson(json)).toList();
    print('[FETCH] 변환된 DiaryModel 리스트: $diaries');

    return diaries;
  }

  /// 새로운 일기 업로드
  Future<bool> uploadDiary(DiaryModel diary) async {
    final json = DiaryMapper.toJson(diary);
    print('[UPLOAD] 변환된 JSON: $json');

    final result = await _apiService.postNewDiray(json);

    print('[UPLOAD] 업로드 결과: $result');

    return result;
  }

  // 일기 수정
  Future<bool> updateDiary(DiaryModel diary) async {
    if (diary.diaryId == 0) {
      print('[ERROR] 일기 ID가 없습니다. 수정 불가');
      return false;
    }

    final json = DiaryMapper.toJson(diary);
    print('[UPDATE] 수정할 일기 ID: ${diary.diaryId}');
    print('[UPDATE] 변환된 JSON: $json');

    final result = await _apiService.updateDiary(diary.diaryId, json);

    print('[UPDATE] 수정 결과: $result');
    return result;
  }

  /// 일기 ID로 단일 일기 가져오기
  Future<DiaryModel> getDiaryById(int diaryId) async {
    print('[FETCH ONE] 요청한 일기 ID: $diaryId');

    final json = await _apiService.getDiaryById(diaryId);
    print('[FETCH ONE] 받아온 JSON: $json');

    final diary = DiaryMapper.fromJson(json);
    print('[FETCH ONE] 변환된 DiaryModel: $diary');

    return diary;
  }

  /// 일기 ID로 삭제 요청
  Future<bool> deleteDiaryById(int diaryId) async {
    print('[DELETE] 삭제할 일기 ID: $diaryId');

    final result = await _apiService.deleteDiary(diaryId);

    print('[DELETE] 삭제 결과: $result');
    return result;
  }

  /// 랜덤 공개 일기 1개 가져오기
  Future<DiaryModel> getRandomPublicDiary() async {
    print('[FETCH RANDOM] 랜덤 공개 일기 요청 시작');

    final json = await _apiService.getRandomPublicDiary();
    print('[FETCH RANDOM] 받아온 JSON: $json');

    final diary = DiaryMapper.fromJson(json);
    print('[FETCH RANDOM] 변환된 DiaryModel: $diary');

    return diary;
  }

  /// 사용자별 전체체 요약 데이터 가져오기
  Future<Map<String, int>> getAllSummary() async {
    try {
      final keywordSummary = await _apiService.getAllSummary();
      print('[FETCH KEYWORDS] 받아온 키워드 요약: $keywordSummary');
      return keywordSummary;
    } catch (e) {
      print('[ERROR] 키워드 요약 데이터 가져오기 실패: $e');
      return {}; // 빈 Map 반환
    }
  }

  /// 특정 연/월에 대한 요약 데이터 가져오기
  Future<Map<String, int>> getMonthlySummary(DateTime date) async {
    final year = date.year;
    final month = date.month;
    print('[FETCH MONTHLY KEYWORDS] 연도: $year / 월: $month');

    try {
      final keywordSummary = await _apiService.getMonthlySummary(year, month);
      print('[FETCH MONTHLY KEYWORDS] 받아온 키워드 요약: $keywordSummary');
      return keywordSummary;
    } catch (e) {
      print('[ERROR] 월별 키워드 요약 데이터 가져오기 실패: $e');
      return {}; // 빈 Map 반환
    }
  }

  /// 사용자별 전체 요약 데이터 가져오기
  Future<Map<String, int>> getAllEmotion() async {
    try {
      final keywordEmotion = await _apiService.getAllEmotion();
      print('[FETCH KEYWORDS] 받아온 감정 태그: $keywordEmotion');
      return keywordEmotion;
    } catch (e) {
      print('[ERROR] 키워드 요약 데이터 가져오기 실패: $e');
      return {}; // 빈 Map 반환
    }
  }

  /// 특정 연/월에 대한 감정정 데이터 가져오기
  Future<Map<String, int>> getMonthlyEmotion(DateTime date) async {
    final year = date.year;
    final month = date.month;
    print('[FETCH MONTHLY KEYWORDS] 연도: $year / 월: $month');

    try {
      final keywordEmotion = await _apiService.getMonthlyEmotion(year, month);
      print('[FETCH MONTHLY KEYWORDS] 받아온 키워드 감정정: $keywordEmotion');
      return keywordEmotion;
    } catch (e) {
      print('[ERROR] 월별 감정 데이터 가져오기 실패: $e');
      return {}; // 빈 Map 반환
    }
  }

  //회원 탈퇴 요청 및 확인
  Future<bool> deleteAccount() async {
    return await _apiService.requestDeleteAccount();
  }
}
