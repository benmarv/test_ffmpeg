class ProductsModel {
  ProductsModel({
    required this.id,
    required this.userId,
    required this.pageId,
    required this.productName,
    required this.productDescription,
    required this.category,
    required this.subCategory,
    required this.price,
    required this.location,
    required this.status,
    required this.currency,
    required this.isActive,
    required this.units,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.images,
    required this.userInfo,
  });

  final String? id;
  final String? userId;
  final String? pageId;
  final String? productName;
  final String? productDescription;
  final String? category;
  final dynamic subCategory;
  final String? price;
  final String? location;
  final String? status;
  final String? currency;
  final String? isActive;
  final String? units;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<Image> images;
  final UserInfo? userInfo;

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json["id"],
      userId: json["user_id"],
      pageId: json["page_id"],
      productName: json["product_name"],
      productDescription: json["product_description"],
      category: json["category"],
      subCategory: json["sub_category"],
      price: json["price"],
      location: json["location"],
      status: json["status"],
      currency: json["currency"],
      isActive: json["is_active"],
      units: json["units"],
      type: json["type"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      images: json["images"] == null
          ? []
          : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      userInfo: json["user_info"] == null
          ? null
          : UserInfo.fromJson(json["user_info"]),
    );
  }


}

class Image {
  Image({
    required this.id,
    required this.image,
  });

  final String? id;
  final String? image;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class UserInfo {
  UserInfo({
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

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
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
