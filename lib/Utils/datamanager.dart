import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Datamanager {
  static const String profileImagePathKey = 'user_profile_image_path';
  final secStorage = FlutterSecureStorage();

  Future<void> saveData(String key, dynamic value, bool? needBackend) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toString());
  }

  Future<String> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  Future<void> removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // 프로필 이미지 경로 저장
  Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileImagePathKey, path);
  }

  // 프로필 이미지 경로 불러오기
  Future<String> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileImagePathKey) ?? '';
  }

  Future<void> saveToken(String token) async {
    await secStorage.write(key: 'user_token', value: token);
  }

  Future<String?> getToken() async {
    return await secStorage.read(key: 'user_token');
  }

  Future<void> removeToken() async {
    await secStorage.delete(key: 'user_token');
  }

  Future<void> clearAllUserData() async {
    try {
      //SharedPreferences의 모든 데이터 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      //FlutterSecureStorage의 모든 데이터 삭제
      await secStorage.deleteAll();
    } catch (e) {
      //데이터 삭제 실패할 경우
      print('데이터 삭제 중 오류 발생: $e');
    }
  }
}
