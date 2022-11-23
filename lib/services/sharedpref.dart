import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrence {
  Future<bool> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("token", token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? '';
  }
}
