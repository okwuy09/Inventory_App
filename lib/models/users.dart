class Users {
  Users({
    this.id,
    this.email,
    this.username,
    this.fullName,
    this.avatar,
    this.banned,
    this.lastLogin,
    this.dateCreated,
    this.rolesPriority,
  });

  String? id;
  String? email;
  String? username;
  String? fullName;
  String? avatar;
  bool? banned;
  dynamic lastLogin;
  DateTime? dateCreated;
  String? rolesPriority;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        fullName: json["full_name"],
        avatar: json["avatar"],
        banned: json["banned"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
        dateCreated: DateTime.parse(json["date_created"]),
        rolesPriority: json["roles_Priority"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "full_name": fullName,
        "avatar": avatar,
        "banned": banned,
        // ignore: prefer_null_aware_operators
        "last_login": lastLogin == null ? null : lastLogin.toIso8601String(),

        "date_created": dateCreated!.toIso8601String(),
        "roles_Priority": rolesPriority,
      };
}
