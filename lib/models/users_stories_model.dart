class Stories {
  Stories({
    required this.id,
    required this.username,
    required this.avatar,
    required this.verified,
    required this.stories,
  });

  final String? id;
  final String? username;
  final String? avatar;
  final String? verified;
  final List<Story> stories;

  factory Stories.fromJson(Map<String, dynamic> json) {
    return Stories(
      id: json["id"],
      username: json["username"],
      avatar: json["avatar"],
      verified: json["is_verified"],
      stories: json["stories"] == null
          ? []
          : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
    );
  }
}

class Story {
  Story({
    required this.id,
    required this.userId,
    required this.description,
    required this.type,
    required this.thumbnail,
    required this.media,
    required this.viewsCount,
    required this.createdAt,
    required this.duration,
    required this.isOwner,
  });

  final String? id;
  final String? userId;
  final String? description;
  final String? duration;
  final String? type;
  final String? thumbnail;
  final String? media;
  final String? viewsCount;
  final DateTime? createdAt;
  final int? isOwner;

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["id"],
      userId: json["user_id"],
      description: json["description"],
      duration: json["duration"],
      type: json["type"],
      thumbnail: json["thumbnail"],
      media: json["media"],
      viewsCount: json["views_count"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      isOwner: json["is_owner"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "description": description,
        "type": type,
        "thumbnail": thumbnail,
        "media": media,
        "duration": duration,
        "views_count": viewsCount,
        "created_at": createdAt?.toIso8601String(),
        "is_owner": isOwner,
      };
}

class Images {
  Images({
    required this.id,
    required this.storyId,
    required this.type,
    required this.filename,
    required this.expire,
  });

  String id;
  String storyId;
  String type;
  String filename;
  String expire;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: json["id"],
        storyId: json["story_id"],
        type: json["type"],
        filename: json["filename"],
        expire: json["expire"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "story_id": storyId,
        "type": type,
        "filename": filename,
        "expire": expire,
      };
}

class Videos {
  Videos({
    required this.id,
    required this.storyId,
    required this.type,
    required this.filename,
    required this.expire,
  });

  String id;
  String storyId;
  String type;
  String filename;
  String expire;

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
        id: json["id"],
        storyId: json["story_id"],
        type: json["type"],
        filename: json["filename"],
        expire: json["expire"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "story_id": storyId,
        "type": type,
        "filename": filename,
        "expire": expire,
      };
}

class Reaction {
  Reaction({
    this.isReacted,
    this.type,
    this.count,
  });

  bool? isReacted;
  String? type;
  int? count;

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
        isReacted: json["is_reacted"],
        type: json["type"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "is_reacted": isReacted,
        "type": type,
        "count": count,
      };
}
