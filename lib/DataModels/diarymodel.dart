//일기 데이터 모델
class DiaryModel {
  //일기 관련 데이터
  final int diaryId; // 일기 ID
  final String date;
  final String title;
  final String content;
  final int weather;
  final List<int> emotionTagIds; // 감정 태그 ID 목록
  final List<String> summaryKeywords; // 키워드 목록
  //공개 여부
  final bool isPublic;
  //위치 정보
  final double lat;
  final double lng;

  //테스트용 생성자
  DiaryModel({
    required this.diaryId,
    required this.date,
    required this.weather,
    required this.isPublic,
    required this.lat,
    required this.lng,
    required this.title,
    required this.content,
    required this.emotionTagIds,
    required this.summaryKeywords,
  });
}
