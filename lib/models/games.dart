class Games {
    Games({
        required this.id,
        required this.name,
        required this.description,
        required this.image,
        required this.link,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String? id;
    final String? name;
    final String? description;
    final String? image;
    final String? link;
    final String? isActive;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    factory Games.fromJson(Map<String, dynamic> json){ 
        return Games(
            id: json["id"],
            name: json["name"],
            description: json["description"],
            image: json["image"],
            link: json["link"],
            isActive: json["is_active"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: json["updated_at"],
            deletedAt: json["deleted_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "link": link,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
    };

}
