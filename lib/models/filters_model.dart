class DeepFilters {
    DeepFilters({
        required this.id,
        required this.name,
        required this.link,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String? id;
    final String? name;
    final String? link;
    final String? image;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    factory DeepFilters.fromJson(Map<String, dynamic> json){ 
        return DeepFilters(
            id: json["id"],
            name: json["name"],
            link: json["link"],
            image: json["image"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
        );
    }

}
