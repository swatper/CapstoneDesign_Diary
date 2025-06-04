import 'package:capstone_diary/DataModels/diarymodel.dart';
import 'package:capstone_diary/Utils/diarymapper.dart';
import 'package:capstone_diary/services/diaryapiservice';

class DiaryManager {
  static final DiaryManager _instance = DiaryManager._internal();
  final DiaryApiService _apiService = DiaryApiService();

  factory DiaryManager() => _instance;

  DiaryManager._internal();

  /// 전체 일기 리스트를 DiaryModel 리스트로 가져오기
  Future<List<DiaryModel>> fetchAllDiaries(String userId) async {
    print('[FETCH] 사용자 ID: $userId');

    final jsonList = await _apiService.getAllDiary(userId);
    print('[FETCH] 받아온 원시 JSON 리스트: $jsonList');

    final diaries = jsonList.map((json) => DiaryMapper.fromJson(json)).toList();
    print('[FETCH] 변환된 DiaryModel 리스트: $diaries');

    return diaries;
  }

  //특정 날짜 일기 가져오기
  Future<List<DiaryModel>> fetchDiaryForDate(String userId, String date) async {
    print('[FETCH] 사용자 ID: $userId');

    final jsonList = await _apiService.getDiaryforDate(userId, date);
    print('[FETCH] 받아온 원시 JSON 리스트: $jsonList');

    final diaries = jsonList.map((json) => DiaryMapper.fromJson(json)).toList();
    print('[FETCH] 변환된 DiaryModel 리스트: $diaries');

    return diaries;
  }

  /// 새로운 일기 업로드
  Future<bool> uploadDiary(String userId, DiaryModel diary) async {
    final json = DiaryMapper.toJson(userId, diary);
    print('[UPLOAD] userId: $userId');
    print('[UPLOAD] 변환된 JSON: $json');

    final result = await _apiService.postNewDiray(json);

    print('[UPLOAD] 업로드 결과: $result');

    return result;
  }

  // 일기 수정
  Future<bool> updateDiary(String userId, DiaryModel diary) async {
    if (diary.diaryId == 0) {
      print('[ERROR] 일기 ID가 없습니다. 수정 불가');
      return false;
    }

    final json = DiaryMapper.toJson(userId, diary);
    print('[UPDATE] 수정할 일기 ID: ${diary.diaryId}');
    print('[UPDATE] 변환된 JSON: $json');

    final result = await _apiService.updateDiary(diary.diaryId, json);

    print('[UPDATE] 수정 결과: $result');
    return result;
  }

  /// 일기 ID로 단일 일기 가져오기
  Future<DiaryModel> getDiaryById(String userId, int diaryId) async {
    print('[FETCH ONE] 요청한 일기 ID: $diaryId');

    final json = await _apiService.getDiaryById(userId, diaryId);
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
}
