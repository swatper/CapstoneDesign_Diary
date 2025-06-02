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

  /// 새로운 일기 업로드
  Future<bool> uploadDiary(String userId, DiaryModel diary) async {
    final json = DiaryMapper.toJson(userId, diary);
    print('[UPLOAD] userId: $userId');
    print('[UPLOAD] 변환된 JSON: $json');

    final result = await _apiService.postNewDiray(json);

    print('[UPLOAD] 업로드 결과: $result');

    return result;
  }
}
