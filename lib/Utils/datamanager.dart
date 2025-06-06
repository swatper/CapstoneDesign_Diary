import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Datamanager {
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

  Future<void> saveToken(String token) async {
    await secStorage.write(key: 'user_token', value: token);
  }

  Future<void> removeToken() async {
    await secStorage.delete(key: 'user_token');
  }

  Future<String?> getToken() async {
    return await secStorage.read(key: 'user_token');
  }
}
