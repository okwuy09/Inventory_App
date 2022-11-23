// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

AuthModel usersFromJson(String str) => AuthModel.fromJson(json.decode(str));

String usersToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  AuthModel({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
  });

  bool status;
  String message;
  Data data;
  String token;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class Data {
  Data({
    this.id,
    required this.email,
    this.oauthUid,
    this.oauthProvider,
    required this.pass,
    this.username,
    this.fullName,
    this.avatar,
    this.banned,
    this.lastLogin,
    this.lastActivity,
    this.dateCreated,
    this.forgotExp,
    this.rememberTime,
    this.rememberExp,
    this.verificationCode,
    this.topSecret,
    this.ipAddress,
    this.createdBy,
    this.updatedBy,
    this.updatedAt,
    this.createdAt,
  });

  String? id;
  String email;
  dynamic oauthUid;
  dynamic oauthProvider;
  String pass;
  String? username;
  String? fullName;
  String? avatar;
  String? banned;
  DateTime? lastLogin;
  dynamic lastActivity;
  DateTime? dateCreated;
  dynamic forgotExp;
  dynamic rememberTime;
  dynamic rememberExp;
  dynamic verificationCode;
  dynamic topSecret;
  String? ipAddress;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic updatedAt;
  DateTime? createdAt;

  factory Data.fromJson(Map<String?, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        oauthUid: json["oauth_uid"],
        oauthProvider: json["oauth_provider"],
        pass: json["pass"],
        username: json["username"],
        fullName: json["full_name"],
        avatar: json["avatar"],
        banned: json["banned"],
        lastLogin: DateTime.parse(json["last_login"]),
        lastActivity: json["last_activity"],
        dateCreated: DateTime.parse(json["date_created"]),
        forgotExp: json["forgot_exp"],
        rememberTime: json["remember_time"],
        rememberExp: json["remember_exp"],
        verificationCode: json["verification_code"],
        topSecret: json["top_secret"],
        ipAddress: json["ip_address"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "oauth_uid": oauthUid,
        "oauth_provider": oauthProvider,
        "pass": pass,
        "username": username,
        "full_name": fullName,
        "avatar": avatar,
        "banned": banned,
        "last_login": lastLogin?.toIso8601String(),
        "last_activity": lastActivity,
        "date_created": dateCreated?.toIso8601String(),
        "forgot_exp": forgotExp,
        "remember_time": rememberTime,
        "remember_exp": rememberExp,
        "verification_code": verificationCode,
        "top_secret": topSecret,
        "ip_address": ipAddress,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "created_at": createdAt?.toIso8601String(),
      };
}
