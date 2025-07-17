class BlogsModel {
  BlogsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.view,
    required this.shared,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.link,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? content;
  final String? description;
  final String? category;
  final String? thumbnail;
  final String? view;
  final String? shared;
  final String? active;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String link;

  factory BlogsModel.fromJson(Map<String, dynamic> json) {
    return BlogsModel(
      id: json["id"],
      userId: json["user_id"],
      title: json["title"],
      content: json["content"],
      description: json["description"],
      category: json["category"],
      thumbnail: json["thumbnail"],
      view: json["view"],
      shared: json["shared"],
      active: json["active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      link: json['link'],
    );
  }
}
