class MessageModel {
  MessageModel({
    required this.id,
    required this.fromId,
    this.groupId,
    this.pageId,
    required this.toId,
    required this.text,
    this.media,
    this.mediaFileName,
    required this.time,
    this.seen,
    this.deletedOne,
    this.deletedTwo,
    this.sentPush,
    this.notificationId,
    this.productId,
    this.messageUser,
    this.videoThumbail,
    required this.timeText,
    this.type,
    this.product,
  });
  final String? id;
  final String? fromId;
  final String? groupId;
  final String? pageId;
  final String? toId;
  final String? text;
  final String? media;
  final String? mediaFileName;
  final String? time;
  final String? seen;
  final String? deletedOne;
  final String? deletedTwo;
  final String? sentPush;
  final String? notificationId;
  final String? productId;
  final String? videoThumbail;
  final MessageUser? messageUser;
  final String? timeText;
  final String? type;
  final dynamic product;
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["id"],
      fromId: json["from_id"],
      groupId: json["group_id"],
      pageId: json["page_id"],
      toId: json["to_id"],
      text: json["message"],
      media: json["media"],
      mediaFileName: json["media_name"],
      time: json["created_at"],
      seen: json["is_seen"],
      videoThumbail: json['thumbnail'],
      deletedOne: json["deleted_one"],
      deletedTwo: json["deleted_two"],
      sentPush: json["is_push_sent"],
      notificationId: json["noti_id"],
      productId: json["product_id"],
      messageUser:
          json["user"] == null ? null : MessageUser.fromJson(json["user"]),
      timeText: json["human_time"],
      type: json["media_type"],
      product: json["product"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "from_id": fromId,
        "group_id": groupId,
        "page_id": pageId,
        "to_id": toId,
        "message": text,
        "media": media,
        "media_name": mediaFileName,
        "created_at": time,
        "is_seen": seen,
        "deleted_one": deletedOne,
        "deleted_two": deletedTwo,
        "is_push_sent": sentPush,
        "noti_id": notificationId,
        "product_id": productId,
        'thumbnail': videoThumbail,
        "user": messageUser?.toJson(),
        "human_time ": timeText,
        "media_type": type,
        "product": product,
      };
}

class MessageUser {
  MessageUser({
    required this.userId,
    required this.avatar,
  });
  final String? userId;
  final String? avatar;
  factory MessageUser.fromJson(Map<String, dynamic> json) {
    return MessageUser(
      userId: json["id"],
      avatar: json["avatar"],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": userId,
        "avatar": avatar,
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

class MessgeModel {
  int sender;
  Message message;
  SenderDetails senderDetails;
  MessgeModel({
    required this.sender,
    required this.message,
    required this.senderDetails,
  });
}

class Message {
  int messageFrom;
  int messageTo;
  Data data;
  Message({
    required this.messageFrom,
    required this.messageTo,
    required this.data,
  });
}

class Data {
  int messageTo;
  String text;
  Data({
    required this.messageTo,
    required this.text,
  });
}

class SenderDetails {
  String username;
  String email;
  String firstName;
  String lastName;
  String cover;
  String avatar;
  String gender;
  int userId;
  String sockid;
  SenderDetails({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.cover,
    required this.avatar,
    required this.gender,
    required this.userId,
    required this.sockid,
  });
}
