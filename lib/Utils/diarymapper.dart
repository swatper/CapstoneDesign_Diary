import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryMapper {
  // JSON → DiaryModel
  static DiaryModel fromJson(Map<String, dynamic> json) {
    bool isEdited = false;

    // createdAt과 updatedAt이 둘 다 존재할 때만 비교
    if (json.containsKey('createdAt') && json.containsKey('updatedAt')) {
      try {
        final createdAt = DateTime.parse(json['createdAt']);
        final updatedAt = DateTime.parse(json['updatedAt']);
        isEdited = !createdAt.isAtSameMomentAs(updatedAt);
      } catch (e) {
        // 날짜 파싱 실패 시에도 안전하게 false 유지
        isEdited = false;
      }
    }
    return DiaryModel(
      isEdited: isEdited,
      diaryId: json['id'] as int,
      date: json['diaryDate'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      weather: json['weatherId'] as int,
      emotionTagIds: List<int>.from(json['emotionTagIds']),
      summaryKeywords: List<String>.from(json['summaryKeywords']),
      isPublic: json['viewScope'] as bool,
      lat: (json['latitude'] as num).toDouble(),
      lng: (json['longitude'] as num).toDouble(),
    );
  }

  // DiaryModel → JSON (userId는 매개변수로 따로 받음)
  static Map<String, dynamic> toJson(String userId, DiaryModel diary) {
    return {
      'userId': userId,
      'diaryDate': diary.date,
      'title': diary.title,
      'content': diary.content,
      'viewScope': diary.isPublic,
      'weatherId': diary.weather,
      'emotionTagIds': diary.emotionTagIds,
      'summaryKeywords': diary.summaryKeywords,
      'latitude': diary.lat,
      'longitude': diary.lng,
    };
  }
}
