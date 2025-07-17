class GetLikePage {
  GetLikePage({
    required this.id,
    required this.userId,
    required this.pageUsername,
    required this.pageTitle,
    required this.pageDescription,
    required this.avatar,
    required this.cover,
    required this.pageCategory,
    required this.subCategory,
    required this.website,
    required this.facebook,
    required this.google,
    required this.company,
    required this.address,
    required this.phone,
    required this.callActionType,
    required this.callActionTypeUrl,
    required this.backgroundImage,
    required this.isVerified,
    required this.isActive,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.isDeleted,
  });

  final String? id;
  final String? userId;
  final String? pageUsername;
  final String? pageTitle;
  final String? pageDescription;
  final String? avatar;
  final String? cover;
  final String? pageCategory;
  final String? subCategory;
  final dynamic website;
  final dynamic facebook;
  final dynamic google;
  final dynamic company;
  final dynamic address;
  final dynamic phone;
  final String? callActionType;
  final dynamic callActionTypeUrl;
  final dynamic backgroundImage;
  dynamic isVerified;
  final String? isActive;
  final String? likesCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? isDeleted;

  factory GetLikePage.fromJson(Map<String, dynamic> json) {
    return GetLikePage(
      id: json["id"],
      userId: json["user_id"],
      pageUsername: json["page_username"],
      pageTitle: json["page_title"],
      pageDescription: json["page_description"],
      avatar: json["avatar"],
      cover: json["cover"],
      pageCategory: json["page_category"],
      subCategory: json["sub_category"],
      website: json["website"],
      facebook: json["facebook"],
      google: json["google"],
      company: json["company"],
      address: json["address"],
      phone: json["phone"],
      callActionType: json["call_action_type"],
      callActionTypeUrl: json["call_action_type_url"],
      backgroundImage: json["background_image"],
      isVerified: json["is_verified"],
      isActive: json["is_active"],
      likesCount: json["likes_count"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      isDeleted: json["is_deleted"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_username": pageUsername,
        "page_title": pageTitle,
        "page_description": pageDescription,
        "avatar": avatar,
        "cover": cover,
        "page_category": pageCategory,
        "sub_category": subCategory,
        "website": website,
        "facebook": facebook,
        "google": google,
        "company": company,
        "address": address,
        "phone": phone,
        "call_action_type": callActionType,
        "call_action_type_url": callActionTypeUrl,
        "background_image": backgroundImage,
        "is_verified": isVerified,
        "is_active": isActive,
        "likes_count": likesCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "is_deleted": isDeleted,
      };
}
