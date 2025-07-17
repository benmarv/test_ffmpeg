class CallHistory {
    CallHistory({
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
        required this.callType,
        required this.incoming,
        required this.time,
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
    final String? callType;
    final String? incoming;
    final String? time;

    factory CallHistory.fromJson(Map<String, dynamic> json){ 
        return CallHistory(
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
            callType: json["call_type"],
            incoming: json["incoming"],
            time: json["time"],
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
        "call_type": callType,
        "incoming": incoming,
        "time": time,
    };

}
