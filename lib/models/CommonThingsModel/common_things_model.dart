// To parse this JSON data, do
//
//     final commonThingsModel = commonThingsModelFromJson(jsonString);

import 'dart:convert';

CommonThingsModel commonThingsModelFromJson(String str) =>
    CommonThingsModel.fromJson(json.decode(str));

String commonThingsModelToJson(CommonThingsModel data) =>
    json.encode(data.toJson());

class CommonThingsModel {
  List<dynamic> pages;
  List<dynamic> groups;
  List<dynamic> events;
  User user;

  CommonThingsModel({
    required this.pages,
    required this.groups,
    required this.events,
    required this.user,
  });

  factory CommonThingsModel.fromJson(Map<String, dynamic> json) =>
      CommonThingsModel(
        pages: List<dynamic>.from(json["pages"].map((x) => x)),
        groups: List<dynamic>.from(json["groups"].map((x) => x)),
        events: List<dynamic>.from(json["events"].map((x) => x)),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "pages": List<dynamic>.from(pages.map((x) => x)),
        "groups": List<dynamic>.from(groups.map((x) => x)),
        "events": List<dynamic>.from(events.map((x) => x)),
        "user": user.toJson(),
      };
}

class User {
  String id;
  String isVerified;
  String username;
  String firstName;
  String email;
  String lastName;
  String avatar;
  String cover;
  String gender;
  String level;
  String role;

  User({
    required this.id,
    required this.isVerified,
    required this.username,
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.avatar,
    required this.cover,
    required this.gender,
    required this.level,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        isVerified: json["is_verified"],
        username: json["username"],
        firstName: json["first_name"],
        email: json["email"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        cover: json["cover"],
        gender: json["gender"],
        level: json["level"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_verified": isVerified,
        "username": username,
        "first_name": firstName,
        "email": email,
        "last_name": lastName,
        "avatar": avatar,
        "cover": cover,
        "gender": gender,
        "level": level,
        "role": role,
      };
}
