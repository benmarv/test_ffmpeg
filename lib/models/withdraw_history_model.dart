class WithdrawHistory {
    WithdrawHistory({
        required this.id,
        required this.type,
        required this.fullName,
        required this.paypalEmail,
        required this.userId,
        required this.iban,
        required this.country,
        required this.swiftCode,
        required this.mblNo,
        required this.amount,
        required this.status,
        required this.address,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.user,
    });

    final String? id;
    final String? type;
    final String? fullName;
    final dynamic paypalEmail;
    final String? userId;
    final String? iban;
    final String? country;
    final String? swiftCode;
    final String? mblNo;
    final String? amount;
    final String? status;
    final String? address;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final User? user;

    factory WithdrawHistory.fromJson(Map<String, dynamic> json){ 
        return WithdrawHistory(
            id: json["id"],
            type: json["type"],
            fullName: json["full_name"],
            paypalEmail: json["paypal_email"],
            userId: json["user_id"],
            iban: json["iban"],
            country: json["country"],
            swiftCode: json["swift_code"],
            mblNo: json["mbl_no"],
            amount: json["amount"],
            status: json["status"],
            address: json["address"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "full_name": fullName,
        "paypal_email": paypalEmail,
        "user_id": userId,
        "iban": iban,
        "country": country,
        "swift_code": swiftCode,
        "mbl_no": mblNo,
        "amount": amount,
        "status": status,
        "address": address,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "user": user?.toJson(),
    };

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
