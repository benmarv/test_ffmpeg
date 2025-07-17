class Session {
    Session({
        required this.id,
        required this.userId,
        required this.sessionId,
        required this.deviceId,
        required this.deviceModel,
        required this.deviceType,
        required this.ipAddress,
        required this.token,
        required this.createdAt,
        required this.updatedAt,
    });

    final String? id;
    final String? userId;
    final String? sessionId;
    final String? deviceId;
    final String? deviceModel;
    final String? deviceType;
    final String? ipAddress;
    final String? token;
    final DateTime? createdAt;
    final dynamic updatedAt;

    factory Session.fromJson(Map<String, dynamic> json){ 
        return Session(
            id: json["id"],
            userId: json["user_id"],
            sessionId: json["session_id"],
            deviceId: json["device_id"],
            deviceModel: json["device_model"],
            deviceType: json["device_type"],
            ipAddress: json["ip_address"],
            token: json["token"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: json["updated_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "session_id": sessionId,
        "device_id": deviceId,
        "device_model": deviceModel,
        "device_type": deviceType,
        "ip_address": ipAddress,
        "token": token,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
    };

}
