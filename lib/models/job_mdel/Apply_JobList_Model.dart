class AppliedJobList {
    AppliedJobList({
        required this.id,
        required this.userId,
        required this.jobId,
        required this.phone,
        required this.position,
        required this.previousWork,
        required this.cvFile,
        required this.location,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.email,
        required this.username,
        required this.avatar,
    });

    final String? id;
    final String? userId;
    final String? jobId;
    final String? phone;
    final String? position;
    final String? previousWork;
    final String? cvFile;
    final String? location;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final String? email;
    final dynamic username;
    final dynamic avatar;

    factory AppliedJobList.fromJson(Map<String, dynamic> json){ 
        return AppliedJobList(
            id: json["id"],
            userId: json["user_id"],
            jobId: json["job_id"],
            phone: json["phone"],
            position: json["position"],
            previousWork: json["previous_work"],
            cvFile: json["cv_file"],
            location: json["location"],
            description: json["description"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
            email: json["email"],
            username: json["username"],
            avatar: json["avatar"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "job_id": jobId,
        "phone": phone,
        "position": position,
        "previous_work": previousWork,
        "cv_file": cvFile,
        "location": location,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "email": email,
        "username": username,
        "avatar": avatar,
    };

}
