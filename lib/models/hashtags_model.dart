class HashtagModel {
    HashtagModel({
        required this.id,
        required this.name,
        required this.tagCount,
    });

    final String? id;
    final String? name;
    final String? tagCount;

    factory HashtagModel.fromJson(Map<String, dynamic> json){ 
        return HashtagModel(
            id: json["id"],
            name: json["name"],
            tagCount: json["tag_count"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag_count": tagCount,
    };

}
