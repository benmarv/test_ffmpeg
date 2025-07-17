class Members {
    Members({
        this.id,
        this.spaceId,
        this.userId,
        this.created,
        this.isActive,
        this.isAdmin,
        this.isModerator,
        this.status,
    });

    String? id;
    String? spaceId;
    String? userId;
    DateTime? created;
    String? isActive;
    String? isAdmin;
    String? isModerator;
    String? status;

    factory Members.fromJson(Map<String?, dynamic> json) => Members(
        id: json["id"],
        spaceId: json["space_id"],
        userId: json["user_id"],
        created: DateTime.parse(json["created"]),
        isActive: json["is_active"],
        isAdmin: json["is_admin"],
        isModerator: json["is_moderator"],
        status: json["status"],
    );

    Map<String?, dynamic> toJson() => {
        "id": id,
        "space_id": spaceId,
        "user_id": userId,
        "created": created?.toIso8601String(),
        "is_active": isActive,
        "is_admin": isAdmin,
        "is_moderator": isModerator,
        "status": status,
    };
}
