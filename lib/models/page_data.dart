class PageData {
  PageData({
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
    required this.isPageOwner,
    required this.isLiked,
  });

  String? id;
  String? userId;
  String? pageUsername;
  String? pageTitle;
  String? pageDescription;
  String? avatar;
  String? cover;
  String? pageCategory;
  String? subCategory;
  String? website;
  String? facebook;
  String? google;
  String? company;
  String? address;
  String? phone;
  String? callActionType;
  String? callActionTypeUrl;
  String? backgroundImage;
  String? isVerified;
  String? isActive;
  String? likesCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? isDeleted;
  bool? isPageOwner;
  bool? isLiked;

  factory PageData.fromJson(Map<String, dynamic> json) {
    return PageData(
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
      isPageOwner: json["is_page_owner"],
      isLiked: json["is_liked"],
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
        "is_page_owner": isPageOwner,
        "is_liked": isLiked,
      };
}
