import 'package:link_on/models/usr.dart';

class PostAdvertisement {
  PostAdvertisement({
    required this.id,
    required this.postId,
    required this.fromUserId,
    required this.toUserId,
    required this.title,
    required this.link,
    required this.body,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.userData,
  });

  final String? id;
  final String? postId;
  final String? fromUserId;
  final String? toUserId;
  final String? title;
  final String? link;
  final String? body;
  final String? image;
  final String? status;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;
  final Usr? userData;

  factory PostAdvertisement.fromJson(Map<String, dynamic> json) {
    return PostAdvertisement(
      id: json["id"],
      postId: json["post_id"],
      fromUserId: json["from_user_id"],
      toUserId: json["to_user_id"],
      title: json["title"],
      link: json["link"],
      body: json["body"],
      image: json["image"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      userData: json["user_data"] == null
          ? null
          : Usr.fromJson(
              json["user_data"],
            ),
    );
  }
}
