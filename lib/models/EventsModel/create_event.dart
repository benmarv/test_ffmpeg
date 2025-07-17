class EventModel {
  EventModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.location,
    required this.description,
    required this.url,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.cover,
    required this.isInterested,
    required this.isGoing,
    required this.createdAt,
    required this.deletedAt,
    required this.updatedAt,
    required this.isOwner,
    required this.userdata,
  });

  String? id;
  String? userId;
  String? name;
  String? location;
  String? description;
  dynamic url;

  String? startDate;
  String? startTime;
  String? endDate;

  String? endTime;
  String? cover;
  bool? isInterested;
  bool? isGoing;
  DateTime? createdAt;
  dynamic deletedAt;
  dynamic updatedAt;
  bool? isOwner;
  Userdata? userdata;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"],
      location: json["location"],
      description: json["description"],
      url: json["url"],
      startDate: json["start_date"] ?? "",
      startTime: json["start_time"],
      endDate: json["end_date"] ?? "",
      endTime: json["end_time"],
      cover: json["cover"],
      isInterested: json["is_interested"],
      isGoing: json["is_going"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      deletedAt: json["deleted_at"],
      updatedAt: json["updated_at"],
      isOwner: json["is_owner"],
      userdata:
          json["userdata"] == null ? null : Userdata.fromJson(json["userdata"]),
    );
  }
}

class Userdata {
  Userdata({
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

  String? id;
  String? isVerified;
  String? username;
  String? firstName;
  String? email;
  String? lastName;
  String? avatar;
  String? cover;
  String? gender;
  String? level;
  String? role;

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
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
  }

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
