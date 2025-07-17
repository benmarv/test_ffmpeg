class UserModelFriendandFollow {
  UserModelFriendandFollow({
    required this.id,
    required this.username,
    required this.avatar,
    required this.isfollowing,
    required this.ispending,
    required this.details,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.lastMessage,
    required this.isMessageSeen,
  });

  String? id;
  String? username;
  String? avatar;
  String? role;
  dynamic isfollowing;
  int? ispending;
  String? firstName;
  String? lastName;
  Details? details;
  String? lastMessage;
  String? isMessageSeen;

  factory UserModelFriendandFollow.fromJson(Map<String, dynamic> json) {
    return UserModelFriendandFollow(
      id: json["id"],
      username: json["username"],
      avatar: json["avatar"],
      isfollowing: json["isfollowing"],
      ispending: json["ispending"],
      role: json['role'],
      details:
          json["details"] == null ? null : Details.fromJson(json["details"]),
      firstName: json['first_name'],
      lastName: json['last_name'],
      lastMessage: json['last_message'] ?? '',
      isMessageSeen: json['is_seen'] ?? '0',
    );
  }
}

class Details {
  Details({
    required this.mutualfriendsCount,
  });

  final int? mutualfriendsCount;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      mutualfriendsCount: json["mutualfriendsCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mutualfriendsCount": mutualfriendsCount,
      };
}
