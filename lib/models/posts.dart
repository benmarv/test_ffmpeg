import 'dart:ui';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/models/post_advertisement/post_advertisement_model.dart';
import 'package:link_on/models/product_model/product_model.dart';

class Posts {
  Posts(
      {this.id,
      this.userId,
      this.privacy,
      this.postText,
      this.sharedText,
      this.postLocation,
      this.postLink,
      this.likeCount,
      this.commentCount,
      this.shareCount,
      this.videoViewCount,
      this.cocCount,
      this.viewCount,
      this.greatjobCount,
      this.pageId,
      this.groupId,
      this.eventId,
      this.postType,
      this.feelingType,
      this.feeling,
      this.offerId,
      this.productId,
      this.parentId,
      this.commentsStatus,
      this.postColorId,
      this.status,
      this.ip,
      this.width,
      this.height,
      this.imageOrVideo,
      this.videoThumbnail,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      this.deletedAt,
      this.bgColor,
      this.deletedBy,
      this.user,
      this.images,
      this.video,
      this.audio,
      this.comments,
      this.event,
      this.offer,
      this.product,
      this.group,
      this.page,
      this.sharedPost,
      this.reaction,
      this.tagsList,
      this.isSaved,
      this.pollId,
      this.advertisement,
      this.poll,
      this.donation,
      this.taggedUsers,
      this.mentionedUsers,
      this.createdHuman});

  String? id;
  String? userId;
  String? privacy;
  String? postText;
  dynamic sharedText;
  String? postLocation;
  String? postLink;
  String? likeCount;
  String? commentCount;
  String? shareCount;
  String? videoViewCount;
  String? cocCount;
  dynamic viewCount;
  String? greatjobCount;
  String? pageId;
  String? groupId;
  String? eventId;
  String? postType;
  dynamic feelingType;
  dynamic feeling;
  String? offerId;
  String? productId;
  String? parentId;
  String? commentsStatus;
  String? postColorId;
  String? bgColor;
  String? status;
  String? ip;
  String? width;
  String? height;
  String? imageOrVideo;
  String? videoThumbnail;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic updatedBy;
  dynamic deletedAt;
  dynamic deletedBy;
  User? user;
  List<User>? taggedUsers;
  List<User>? mentionedUsers;
  List<Audio>? images;
  Audio? video;
  Audio? audio;
  double? videoHeight;
  List<Comment>? comments;
  EventModel? event;
  List<dynamic>? offer;
  ProductsModel? product;
  JoinGroupModel? group;
  GetLikePage? page;
  Posts? sharedPost;
  Reaction? reaction;
  String? tagsList;
  PostAdvertisement? advertisement;
  String? createdHuman;
  String? pollId;
  Poll? poll;
  Donation? donation;
  bool? isSaved;

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json["id"],
      userId: json["user_id"],
      privacy: json["privacy"],
      postText: json["post_text"],
      sharedText: json["shared_text"],
      postLocation: json["post_location"],
      postLink: json["post_link"],
      likeCount: json["like_count"],
      commentCount: json["comment_count"],
      shareCount: json["share_count"],
      videoViewCount: json["video_view_count"],
      cocCount: json["coc_count"],
      viewCount: json["view_count"],
      bgColor: json['bg_color'],
      greatjobCount: json["greatjob_count"],
      pageId: json["page_id"],
      pollId: json["poll_id"],
      groupId: json["group_id"],
      eventId: json["event_id"],
      postType: json["post_type"],
      feelingType: json["feeling_type"],
      feeling: json["feeling"],
      offerId: json["offer_id"],
      productId: json["product_id"],
      parentId: json["parent_id"],
      commentsStatus: json["comments_status"],
      postColorId: json["post_color_id"],
      status: json["status"],
      ip: json["ip"],
      width: json["width"],
      height: json["height"],
      imageOrVideo: json["image_or_video"],
      videoThumbnail: json["video_thumbnail"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: json["updated_at"],
      updatedBy: json["updated_by"],
      deletedAt: json["deleted_at"],
      deletedBy: json["deleted_by"],
      createdHuman: json["created_human"],
      advertisement: json['post_advertisement'] == null
          ? null
          : PostAdvertisement.fromJson(json['post_advertisement']),
      donation:
          json['donation'] == null ? null : Donation.fromJson(json['donation']),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      images: json["images"] == null
          ? null
          : List<Audio>.from(json["images"]!.map((x) => Audio.fromJson(x))),
      video: json["video"] == null ? null : Audio.fromJson(json["video"]),
      poll: json["poll"] == null ? null : Poll.fromJson(json["poll"]),
      audio: json["audio"] == null ? null : Audio.fromJson(json["audio"]),
      comments: json["comments"] == null
          ? null
          : List<Comment>.from(
              json["comments"]!.map((x) => Comment.fromJson(x))),
      taggedUsers: json["tagged_users"] == null
          ? null
          : List<User>.from(json["tagged_users"]!.map((x) => User.fromJson(x))),
      mentionedUsers: json["mentioned_users"] == null
          ? null
          : List<User>.from(
              json["mentioned_users"]!.map((x) => User.fromJson(x))),
      event: json["event"] == null ? null : EventModel.fromJson(json["event"]),
      offer: json["offer"] == null
          ? null
          : List<dynamic>.from(json["offer"]!.map((x) => x)),
      product: json["product"] == null
          ? null
          : ProductsModel.fromJson(json["product"]),
      group:
          json["group"] == null ? null : JoinGroupModel.fromJson(json["group"]),
      page: json["page"] == null ? null : GetLikePage.fromJson(json["page"]),
      sharedPost: json["shared_post"] == null
          ? null
          : Posts.fromJson(json["shared_post"]),
      reaction:
          json["reaction"] == null ? null : Reaction.fromJson(json["reaction"]),
      tagsList: json["tags_list"],
      isSaved: json["is_saved"],
    );
  }
}

class Donation {
  Donation({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.userId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.collectedAmount,
    required this.participatedUsers,
  });

  final String? id;
  final String? title;
  final String? description;
  final String? amount;
  final String? userId;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  String? collectedAmount;
  final int? participatedUsers;

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      amount: json["amount"],
      userId: json["user_id"],
      image: json["image"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      collectedAmount: json["collected_amount"],
      participatedUsers: json["participated_users"],
    );
  }
}

class Poll {
  Poll(
      {required this.id,
      required this.pollTitle,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.pollOptions,
      required this.isVoted,
      required this.userVotedId,
      required this.pollTotalVotes});

  final String? id;
  String? pollTitle;
  final String? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final List<PollOption> pollOptions;
  final String? isVoted;
  final String? userVotedId;
  final int? pollTotalVotes;

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json["id"],
      pollTitle: json["poll_title"],
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      userVotedId: json["user_voted_id"],
      pollTotalVotes: json["poll_total_votes"],
      pollOptions: json["poll_options"] == null
          ? []
          : List<PollOption>.from(
              json["poll_options"]!.map(
                (x) => PollOption.fromJson(x),
              ),
            ),
      isVoted: json["is_voted"],
    );
  }
}

class PollOption {
  PollOption({
    required this.id,
    required this.pollId,
    required this.optionText,
    required this.noOfVotes,
  });

  final String? id;
  final String? pollId;
  final String? optionText;
  final int? noOfVotes;

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json["id"],
      pollId: json["poll_id"],
      optionText: json["option_text"],
      noOfVotes: json["no_of_votes"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "option_text": optionText,
        "no_of_votes": noOfVotes,
      };
}

class Audio {
  Audio({
    required this.id,
    required this.mediaPath,
    required this.imageOrVideo,
  });

  String? id;
  String? mediaPath;
  String? imageOrVideo;

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json["id"],
      mediaPath: json["media_path"],
      imageOrVideo: json["image_or_video"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "media_path": mediaPath,
        "image_or_video": imageOrVideo,
      };
}

class Comment {
  Comment(
      {this.id,
      this.postId,
      this.userId,
      this.comment,
      this.replyCount,
      this.likeCount,
      this.createdAt,
      this.deletedAt,
      this.updatedAt,
      this.firstName,
      this.lastName,
      this.avatar,
      this.reaction,
      this.commentReplies,
      this.isCommentLiked,
      this.createdHuman,
      this.isVerified,
      this.username,
      this.commentId});

  String? id;
  String? postId;
  String? userId;
  String? comment;
  String? replyCount;
  String? likeCount;
  DateTime? createdAt;
  dynamic deletedAt;
  dynamic updatedAt;
  String? firstName;
  String? lastName;
  String? avatar;
  Reaction? reaction;
  List<Comment>? commentReplies;
  bool? isCommentLiked;
  String? createdHuman;
  String? isVerified;
  String? username;
  String? commentId;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      postId: json["post_id"],
      userId: json["user_id"],
      comment: json["comment"],
      isVerified: json["is_verified"],
      replyCount: json["reply_count"],
      likeCount: json["like_count"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      deletedAt: json["deleted_at"],
      updatedAt: json["updated_at"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      username: json["username"],
      avatar: json["avatar"],
      createdHuman: json["created_human"],
      commentId: json["comment_id"],
      reaction:
          json["reaction"] == null ? null : Reaction.fromJson(json["reaction"]),
      commentReplies: json["comment_replies"] == null
          ? null
          : List<Comment>.from(
              json["comment_replies"]!.map((x) => Comment.fromJson(x))),
      isCommentLiked: json["is_comment_liked"],
    );
  }
}

class Reaction {
  Reaction({
    this.isReacted,
    this.reactionType,
    this.count,
    this.image,
    this.color,
    this.text,
  });

  bool? isReacted;
  String? reactionType;
  int? count;
  String? image;
  Color? color;
  String? text;

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      isReacted: json["is_reacted"],
      reactionType: json["reaction_type"],
      count: json["count"],
      image: json["image"],
      text: json["text"],
    );
  }
}

class Image {
  Image({
    required this.id,
    required this.image,
  });

  String? id;
  String? image;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      image: json["image"],
    );
  }
}

class Comments {
  Comments({required this.json});
  Map<String, dynamic> json;

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(json: json);
  }

  Map<String, dynamic> toJson() => {};
}

class User {
  User({
    required this.id,
    required this.isVerified,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.cover,
    required this.gender,
    required this.level,
  });

  String? id;
  String? isVerified;
  String? username;
  String? firstName;
  String? lastName;
  String? avatar;
  String? cover;
  String? gender;
  String? level;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      isVerified: json["is_verified"],
      username: json["username"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      avatar: json["avatar"],
      cover: json["cover"],
      gender: json["gender"],
      level: json["level"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_verified": isVerified,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "cover": cover,
        "gender": gender,
        "level": level,
      };
}
