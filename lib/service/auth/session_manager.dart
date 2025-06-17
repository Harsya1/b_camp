import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN_TIME = 'login_time';
  static const String KEY_TOKEN = 'token';
  static const Duration SESSION_DURATION = Duration(days: 7);

  static Future<void> saveLoginSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString(KEY_TOKEN, token);
    await prefs.setInt(KEY_LOGIN_TIME, currentTime);
  }

  static Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTime = prefs.getInt(KEY_LOGIN_TIME);
      final token = prefs.getString(KEY_TOKEN);

      if (loginTime == null || token == null) {
        return false;
      }

      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final sessionAge = Duration(milliseconds: currentTime - loginTime);

      if (sessionAge >= SESSION_DURATION) {
        await clearSession();
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking session: $e');
      return false;
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_TOKEN);
    await prefs.remove(KEY_LOGIN_TIME);
  }
}
