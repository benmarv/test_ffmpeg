class LiveUsers {
    LiveUsers({
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
        required this.agoraAccessToken,
        required this.channelName,
    });

    final String? id;
    final String? isVerified;
    final String? username;
    final String? firstName;
    final String? email;
    final String? lastName;
    final String? avatar;
    final String? cover;
    final String? gender;
    final String? level;
    final String? role;
    final String? agoraAccessToken;
    final String? channelName;

    factory LiveUsers.fromJson(Map<String, dynamic> json){ 
        return LiveUsers(
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
            agoraAccessToken: json["agora_access_token"],
            channelName: json["channel_name"],
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
        "agora_access_token": agoraAccessToken,
        "channel_name": channelName,
    };

}
