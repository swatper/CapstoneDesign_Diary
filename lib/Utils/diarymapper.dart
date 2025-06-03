import 'package:capstone_diary/DataModels/diarymodel.dart';

class DiaryMapper {
  // JSON → DiaryModel
  static DiaryModel fromJson(Map<String, dynamic> json) {
    return DiaryModel(
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
