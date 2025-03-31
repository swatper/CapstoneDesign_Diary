//일기 데이터 모델
class DirayModel {
  //일기 관련 데이터
  final String date;
  final String title;
  final String content;
  final int weather;
  final List<String> tags;
  //공개 여부
  final bool isPublic;
  //위치 정보
  final int lat;
  final int lng;

  //테스트용 생성자
  DirayModel(
    this.date,
    this.weather,
    this.isPublic,
    this.lat,
    this.lng, {
    required this.title,
    required this.content,
    required this.tags,
  });

  //json to object
  DirayModel.fromJson(Map<String, dynamic> json)
    : date = json['date'],
      title = json['title'],
      content = json['content'],
      weather = json['weather'],
      tags = List<String>.from(json['tags']),
      isPublic = json['isPublic'],
      lat = json['lat'],
      lng = json['lng'];
}
