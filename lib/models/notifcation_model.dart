import 'dart:convert';
import 'package:link_on/models/usr.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  NotificationModel({
    this.id,
    this.notifierId,
    this.recipientId,
    this.postId,
    this.replyId,
    this.commentId,
    this.pageId,
    this.groupId,
    this.groupChatId,
    this.eventId,
    this.threadId,
    this.blogId,
    this.storyId,
    this.seenPop,
    this.type,
    this.type2,
    this.text,
    this.isPoked,
    this.url,
    this.fullLink,
    this.seen,
    this.sentPush,
    this.admin,
    this.time,
    this.notifier,
    this.ajaxUrl,
    this.typeText,
    this.icon,
    this.timeTextString,
    this.timeText,
  });
  String? id;
  String? notifierId;
  String? recipientId;
  String? postId;
  String? replyId;
  String? commentId;
  String? pageId;
  String? groupId;
  String? groupChatId;
  String? eventId;
  String? threadId;
  String? blogId;
  String? storyId;
  String? seenPop;
  String? type;
  String? type2;
  String? text;
  String? url;
  String? fullLink;
  String? seen;
  String? sentPush;
  String? admin;
  String? time;
  bool? isPoked;
  Usr? notifier;
  String? ajaxUrl;
  String? typeText;
  String? icon;
  String? timeTextString;
  String? timeText;
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        notifierId: json["from_user_id"],
        recipientId: json["to_user_id"],
        postId: json["post_id"],
        replyId: json["reply_id"],
        commentId: json["comment_id"],
        pageId: json["page_id"],
        groupId: json["group_id"],
        groupChatId: json["group_chat_id"],
        eventId: json["event_id"],
        threadId: json["thread_id"],
        blogId: json["blog_id"],
        storyId: json["story_id"],
        seenPop: json["seen_pop"],
        type: json["type"],
        type2: json["type2"],
        isPoked: json['isPoked'] ?? false,
        text: json["text"],
        url: json["url"],
        fullLink: json["full_link"],
        seen: json["seen"],
        sentPush: json["sent_push"],
        admin: json["admin"],
        time: json["created_at"],
        notifier: json["notifier"] != null
            ? Usr.fromJson(json["notifier"])
            : json["notifier"],
        ajaxUrl: json["ajax_url"],
        typeText: json["type_text"],
        icon: json["icon"],
        timeTextString: json["time_text_string"],
        timeText: json["time_text"],
      );
}
