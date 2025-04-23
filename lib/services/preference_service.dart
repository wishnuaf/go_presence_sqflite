import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginStatus(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_logged_in', isLoggedIn);
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_logged_in') ?? false;
}

Future<void> logoutUser() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_logged_in', false);
}
