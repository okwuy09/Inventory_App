import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:viicsoft_inventory_app/models/profile.dart';
import 'package:viicsoft_inventory_app/models/users.dart';
import 'package:viicsoft_inventory_app/services/api.dart';
import 'package:http/http.dart' as http;
import '../sharedpref.dart';

class UserAPI extends BaseAPI {
  Future<List<Users>> fetchAllUser() async {
    final String token = await SharedPrefrence().getToken();
    final response = await http.get(Uri.parse(super.allUsersPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });
    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<Users> users = _data['data']['user']
          .map<Users>((model) => Users.fromJson(model as Map<String, dynamic>))
          .toList();
      return users;
    } else {
      throw Exception('Failed to load Users');
    }
  }

  Future<http.Response> deleteUser(String id) async {
    final String token = await SharedPrefrence().getToken();

    var body = jsonEncode({'id': id});
    final http.Response response =
        await http.post(Uri.parse(super.deleteUserPath + id),
            headers: <String, String>{
              "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
              "Content-Type": "application/json",
              'Accept': 'application/json',
              'x-token': token,
            },
            body: body);
    if (response.statusCode == 200) {
      //print(' delete user: ${response.body}');
      return response;
    } else {
      throw Exception('Failed to delete user.');
    }
  }

  Future<ProfileUser> fetchProfileUser() async {
    final String token = await SharedPrefrence().getToken();
    final response = await http.get(Uri.parse(super.profileUserPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });
    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final userResponse = ProfileUser.fromJson(_data['data']['user']);
      return userResponse;
    } else {
      throw Exception('Failed to load Users');
    }
  }

  Future<List<Groups>> fetchUserGroup() async {
    final String token = await SharedPrefrence().getToken();
    final response = await http.get(Uri.parse(super.profileUserPath), headers: {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-token': token,
    });
    if (response.statusCode == 200) {
      final _data = jsonDecode(response.body);
      final List<Groups> userGroup = _data['data']['group']
          .map<Groups>(
              (model) => Groups.fromJson(model as Map<String, dynamic>))
          .toList();
      return userGroup;
    } else {
      throw Exception('Failed to load User group');
    }
  }

  Future<http.StreamedResponse> updateUserProfile(
      String email, String id, XFile avatar, String fullname) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    //create multipart request for POST or PATCH method
    var request =
        http.MultipartRequest("POST", Uri.parse(super.updateprofileUserPath));
    //add header in http request
    request.headers.addAll(headers);
    request.fields["email"] = email;
    //request.fields["password"] = password;
    request.fields["full_name"] = fullname;
    request.fields["id"] = id;
    var pic = await http.MultipartFile.fromPath("avatar", avatar.path);
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    // ignore: unused_local_variable
    var responseString = String.fromCharCodes(responseData);
    return response;
  }

  Future<http.StreamedResponse> updateUserPassword(
    String email,
    String password,
    String fullname,
    String id,
  ) async {
    final String token = await SharedPrefrence().getToken();
    Map<String, String> headers = {
      "X-Api-Key": "632F2EC9771B6C4C0BDF30BE21D9009B",
      'x-token': token,
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(super.updateprofileUserPath));
    //add header in http request
    request.headers.addAll(headers);
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["full_name"] = fullname;
    request.fields["id"] = id;
    var response = await request.send();
    return response;
  }
}
