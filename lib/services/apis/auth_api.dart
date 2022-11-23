import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:viicsoft_inventory_app/models/auth.dart';
import '../api.dart';
import '../sharedpref.dart';

class AuthAPI extends BaseAPI {
  Future<http.Response> signUp(
      String fullname, String email, String password) async {
    var body = jsonEncode(
        {'full_name': fullname, 'email': email, 'password': password});

    http.Response response = await http.post(Uri.parse(super.registerPath),
        headers: super.headers, body: body);
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    var body = jsonEncode({'email': email, 'password': password});
    http.Response response = await http.post(Uri.parse(super.loginPath),
        headers: super.headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var token = AuthModel.fromJson(data).token;
      SharedPrefrence().setToken(token);
      return response;
    } else {
      throw Exception('Failed auth');
    }
  }

  Future<http.Response> logout(int id) async {
    final String token = await SharedPrefrence().getToken();
    var body = jsonEncode({'id': id, 'token': token});
    http.Response response = await http.post(Uri.parse(super.logoutPath),
        headers: super.headers, body: body);

    return response;
  }
}
