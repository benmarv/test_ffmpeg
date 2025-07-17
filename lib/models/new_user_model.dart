class NewUserModel {
    NewUserModel({
        required this.id,
        required this.isVerified,
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.avatar,
        required this.cover,
        required this.gender,
        required this.level,
    });

    final String? id;
    final String? isVerified;
    final String? username;
    final String? firstName;
    final String? lastName;
    final String? avatar;
    final String? cover;
    final String? gender;
    final String? level;

    factory NewUserModel.fromJson(Map<String, dynamic> json){ 
        return NewUserModel(
            id: json["id"],
            isVerified: json["is_verified"],
            username: json["username"],
            firstName: json["first_name"],
            lastName: json["last_name"],
            avatar: json["avatar"],
            cover: json["cover"],
            gender: json["gender"],
            level: json["level"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "is_verified": isVerified,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "cover": cover,
        "gender": gender,
        "level": level,
    };

}
