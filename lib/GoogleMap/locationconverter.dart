import 'package:geocoding/geocoding.dart';

class LocationConverter {
  static final LocationConverter instance = LocationConverter.internal();

  factory LocationConverter() {
    return instance;
  }

  LocationConverter.internal();

  Future<String> getLocationInfo(double lat, double lng) async {
    //테스트 데이터용
    if (lat == 0 && lng == 0) {
      return "부산 어디구 강호동";
    }

    try {
      // 위도와 경도를 사용하여 Placemark 리스트를 가져옵니다.
      // localeIdentifier: 'ko_KR'을 추가하여 한국어 주소 정보를 요청합니다.
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        //첫 번째 Placemark 객체를 사용
        Placemark place = placemarks.first;

        //주소 값 가져오기
        String address = [
          place.administrativeArea, // 시/도
          place.locality, // 시/군/구
          place.subLocality, // 동/읍/면
          place.thoroughfare, // 도로명
          place.name, // 건물명 또는 번지
        ].where((element) => element != null && element.isNotEmpty).join(' ');

        return address;
      } else {
        return "주소를 찾을 수 없습니다.";
      }
    } catch (e) {
      print("위치 정보를 주소로 변환 중 오류 발생: $e");
      return "주소 변환 오류";
    }
  }
}
