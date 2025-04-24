import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginSession(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_logged_in', true);
  await prefs.setInt('user_id', userId);
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_logged_in') ?? false;
}

Future<void> clearLoginSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
