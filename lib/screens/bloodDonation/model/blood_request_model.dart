class BloodRequestModel {
    BloodRequestModel({
        required this.id,
        required this.userId,
        required this.bloodGroup,
        required this.location,
        required this.phone,
        required this.isUrgentNeed,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
    });

    final String? id;
    final String? userId;
    final String? bloodGroup;
    final String? location;
    final String? phone;
    final String? isUrgentNeed;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;

    factory BloodRequestModel.fromJson(Map<String, dynamic> json){ 
        return BloodRequestModel(
            id: json["id"],
            userId: json["user_id"],
            bloodGroup: json["blood_group"],
            location: json["location"],
            phone: json["phone"],
            isUrgentNeed: json["is_urgent_need"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }


}

class User {
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

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
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

   

}
