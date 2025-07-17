
class Movies {
    Movies({
        required this.id,
        required this.userId,
        required this.movieName,
        required this.genre,
        required this.stars,
        required this.producer,
        required this.releaseYear,
        required this.duration,
        required this.description,
        required this.coverPic,
        required this.source,
        required this.video,
        required this.views,
        required this.rating,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String? id;
    final String? userId;
    final String? movieName;
    final String? genre;
    final String? stars;
    final String? producer;
    final dynamic releaseYear;
    final String? duration;
    final dynamic description;
    final String? coverPic;
    final String? source;
    final String? video;
    final String? views;
    final String? rating;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    factory Movies.fromJson(Map<String, dynamic> json){ 
        return Movies(
            id: json["id"],
            userId: json["user_id"],
            movieName: json["movie_name"],
            genre: json["genre"],
            stars: json["stars"],
            producer: json["producer"],
            releaseYear: json["release_year"],
            duration: json["duration"],
            description: json["description"],
            coverPic: json["cover_pic"],
            source: json["source"],
            video: json["video"],
            views: json["views"],
            rating: json["rating"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "movie_name": movieName,
        "genre": genre,
        "stars": stars,
        "producer": producer,
        "release_year": releaseYear,
        "duration": duration,
        "description": description,
        "cover_pic": coverPic,
        "source": source,
        "video": video,
        "views": views,
        "rating": rating,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };

}
