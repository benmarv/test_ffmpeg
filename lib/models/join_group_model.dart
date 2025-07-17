class JoinGroupModel {
  JoinGroupModel(
      {required this.id,
      required this.userId,
      required this.groupName,
      required this.groupTitle,
      required this.avatar,
      required this.cover,
      required this.aboutGroup,
      required this.category,
      required this.subCategory,
      required this.privacy,
      required this.joinPrivacy,
      required this.active,
      required this.membersCount,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.isGroupOwner,
      this.isJoined});

  final String? id;
  final String? userId;
  final String? groupName;
  final String? groupTitle;
  final String? avatar;
  final String? cover;
  final String? aboutGroup;
  final String? category;
  final String? subCategory;
  final String? privacy;
  final String? joinPrivacy;
  final String? active;
   String? isJoined;
  String? membersCount;
  final dynamic createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  bool? isGroupOwner;

  factory JoinGroupModel.fromJson(Map<String, dynamic> json) {
    return JoinGroupModel(
      id: json["id"],
      userId: json["user_id"],
      groupName: json["group_name"],
      groupTitle: json["group_title"],
      avatar: json["avatar"],
      cover: json["cover"],
      isJoined: json["is_joined"],
      aboutGroup: json["about_group"],
      category: json["category"],
      subCategory: json["sub_category"],
      privacy: json["privacy"],
      joinPrivacy: json["join_privacy"],
      active: json["active"],
      membersCount: json["members_count"],
      createdAt: json["created_at"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      isGroupOwner: json["is_group_owner"],
    );
  }
}
