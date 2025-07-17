class SpaceModel {
  SpaceModel({
    required this.id,
    required this.userId,
    required this.topic,
    required this.title,
    required this.description,
    required this.agoraAccessToken,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.listenersCount,
    required this.amount,
    required this.deletedAt,
    required this.member,
  });
  String? id;
  String? userId;
  dynamic topic;
  String? title;
  String? description;
  dynamic agoraAccessToken;
  String? status;
  int? listenersCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String amount;
  Member member;
  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json["id"],
      userId: json["user_id"],
      topic: json["topic"],
      title: json["title"],
      description: json["description"],
      agoraAccessToken: json["agora_access_token"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      amount: json['amount'],
      listenersCount: json['listners_count'] ?? 0,
      member: Member.fromJson(json['members']),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "topic": topic,
        "title": title,
        "description": description,
        "agora_access_token": agoraAccessToken,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        'listners_count': listenersCount,
        'amount': amount,
        "member": member,
      };
}
class Member {
  Member({
    required this.id,
    required this.spaceId,
    required this.userId,
    required this.isActive,
    required this.isHost,
    required this.isCohost,
    required this.isSpeakingAllowed,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });
  String? id;
  String? spaceId;
  String? userId;
  String? isActive;
  String? isHost;
  String? isCohost;
  String? isSpeakingAllowed;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? firstName;
  String? lastName;
  String? avatar;
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["id"],
      spaceId: json["space_id"],
      userId: json["user_id"],
      isActive: json["is_active"],
      isHost: json["is_host"],
      isCohost: json["is_cohost"],
      isSpeakingAllowed: json["is_speaking_allowed"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      avatar: json["avatar"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "space_id": spaceId,
        "user_id": userId,
        "is_active": isActive,
        "is_host": isHost,
        "is_cohost": isCohost,
        "is_speaking_allowed": isSpeakingAllowed,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
      };
}