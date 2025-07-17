class Usr {
  Usr(
      {this.isBack,
      this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.avatar,
      this.cover,
      this.email,
      this.password,
      this.aboutYou,
      this.gender,
      this.address,
      this.status,
      this.resetToken,
      this.resetTokenExpire,
      this.resetExpire,
      this.phone,
      this.isPhoneVerified,
      this.ipAddress,
      this.isVerified,
      this.level,
      this.notifyFriendsNewPost,
      this.activated,
      this.activateToken,
      this.activateExpire,
      this.role,
      this.dateOfBirth,
      this.resetCode,
      this.notifyMessage,
      this.resetCodeExpire,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.balance,
      this.points,
      this.lastSeen,
      this.onlineStatus,
      this.privacyBirthday,
      this.privacyMessage,
      this.privacyFriends,
      this.privacyEmail,
      this.privacyPhone,
      this.working,
      this.city,
      this.relationId,
      this.deviceId,
      this.deviceType,
      this.deviceModel,
      this.facebook,
      this.instagram,
      this.linkedin,
      this.twitter,
      this.youtube,
      this.confirmFollowers,
      this.chatStatus,
      this.shareMyLocation,
      this.shareMyData,
      this.privacyFollow,
      this.privacyPost,
      this.userLevel,
      this.privacyShowActivities,
      this.privateAccount,
      this.activeStatus,
      this.hangoutPrivacy,
      this.privacySeeFriend,
      this.notifyLike,
      this.friendsCount,
      this.notifyComment,
      this.notifySharePost,
      this.notifyAcceptRequest,
      this.notifyJoinedGroup,
      this.notifyLikedPage,
      this.memory,
      this.notifyViewStory,
      this.notifyProfileVisit,
      this.details,
      this.isFriend,
      this.isPending,
      this.isAdmin,
      this.distance,
      this.bloodGroup,
      this.isAvailableForDonation,
      this.lastDonationDate,
      this.isRequestReceived,
      this.addressBytes,
      this.hex,
      this.isWalletExist,
      this.walletAddress,
      this.timezone});

  String? id;
  String? username;
  String? firstName;
  String? lastName;
  String? avatar;
  String? cover;
  String? email;
  String? password;
  String? aboutYou;
  String? gender;
  dynamic address;
  String? status;
  dynamic resetToken;
  dynamic resetTokenExpire;
  String? resetExpire;
  dynamic phone;
  String? isPhoneVerified;
  dynamic ipAddress;
  String? isVerified;
  String? level;
  String? activated;
  int? friendsCount;
  dynamic activateToken;
  dynamic activateExpire;
  String? role;
  DateTime? dateOfBirth;
  dynamic resetCode;
  dynamic resetCodeExpire;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? onlineStatus;
  dynamic deletedAt;
  String? balance;
  String? points;
  String? notifyMessage;
  dynamic lastSeen;
  String? privacyBirthday;
  String? privacyMessage;
  String? privacyFriends;
  String? privacyEmail;
  String? privacyPhone;
  String? working;
  String? city;
  String? relationId;
  String? deviceId;
  String? deviceType;
  String? deviceModel;
  dynamic facebook;
  dynamic instagram;
  dynamic linkedin;
  dynamic twitter;
  dynamic youtube;
  String? confirmFollowers;
  String? chatStatus;
  String? shareMyLocation;
  String? shareMyData;
  String? privacyFollow;
  String? privacyPost;
  String? privacyShowActivities;
  String? privateAccount;
  String? activeStatus;
  String? hangoutPrivacy;
  String? privacySeeFriend;
  String? notifyLike;
  String? notifyFriendsNewPost;
  String? notifyProfileVisit;
  String? notifyComment;
  String? notifySharePost;
  String? notifyAcceptRequest;
  String? notifyJoinedGroup;
  String? notifyLikedPage;
  String? memory;
  String? notifyViewStory;
  Details? details;
  UserLevel? userLevel;
  String? isFriend;
  String? isPending;
  int? isAdmin;
  String? distance;
  String? isRequestReceived;
  String? bloodGroup;
  String? isAvailableForDonation;
  String? lastDonationDate;
  String? addressBytes;
  String? hex;
  String? walletAddress;
  int? isWalletExist;
  bool? isBack;
  String? timezone;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "avatar": avatar,
      "cover": cover,
      "email": email,
      "password": password,
      "about_you": aboutYou,
      "gender": gender,
      "address": address,
      "status": status,
      "reset_token": resetToken,
      "reset_token_expire": resetTokenExpire,
      "reset_expire": resetExpire,
      "phone": phone,
      "is_phone_verified": isPhoneVerified,
      "ip_address": ipAddress,
      "is_verified": isVerified,
      "level": level,
      "notify_friends_newpost": notifyFriendsNewPost,
      "activated": activated,
      "activate_token": activateToken,
      "activate_expire": activateExpire,
      "role": role,
      "date_of_birth": dateOfBirth?.toIso8601String(),
      "reset_code": resetCode,
      "reset_code_expire": resetCodeExpire,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "balance": balance,
      "points": points,
      "last_seen": lastSeen,
      "online_status": onlineStatus,
      "privacy_birthday": privacyBirthday,
      "privacy_message": privacyMessage,
      "privacy_friends": privacyFriends,
      "privacy_view_email": privacyEmail,
      "privacy_view_phone": privacyPhone,
      "working": working,
      "city": city,
      "relation_id": relationId,
      "device_id": deviceId,
      "device_type": deviceType,
      "device_model": deviceModel,
      "facebook": facebook,
      "instagram": instagram,
      "linkedin": linkedin,
      "twitter": twitter,
      "youtube": youtube,
      "confirm_followers": confirmFollowers,
      "chat_status": chatStatus,
      "privacy_share_my_location": shareMyLocation,
      "share_my_data": shareMyData,
      "privacy_follow": privacyFollow,
      "privacy_post": privacyPost,
      "privacy_show_activities": privacyShowActivities,
      "privacy_private_account": privateAccount,
      "privacy_active_status": activeStatus,
      "hangout_privacy": hangoutPrivacy,
      "privacy_see_friend": privacySeeFriend,
      "notify_like": notifyLike,
      "friends_count": friendsCount,
      "notify_comment": notifyComment,
      "notify_share_post": notifySharePost,
      "notify_accept_request": notifyAcceptRequest,
      "notify_joined_group": notifyJoinedGroup,
      "notify_liked_page": notifyLikedPage,
      "memory": memory,
      "notify_view_story": notifyViewStory,
      "notify_profile_visit": notifyProfileVisit,
      "isFriend": isFriend,
      "isPending": isPending,
      "isAdmin": isAdmin,
      "distance": distance,
      "blood_group": bloodGroup,
      "donation_available": isAvailableForDonation,
      "donation_date": lastDonationDate,
      "isRequestReceieved": isRequestReceived,
      "address_bytes": addressBytes,
      "hex": hex,
      "wallet_address": walletAddress,
      "is_wallet_exist": isWalletExist,
      "is_back": isBack,
      "timezone": timezone,
    };
  }

  factory Usr.fromJson(Map<String, dynamic> json) {
    return Usr(
        id: json["id"],
        addressBytes: json["address_bytes"] ?? '',
        hex: json["hex"] ?? '',
        walletAddress: json["wallet_address"] ?? '',
        isWalletExist: json["is_wallet_exist"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        cover: json["cover"],
        email: json["email"],
        password: json["password"],
        aboutYou: json["about_you"],
        gender: json["gender"],
        address: json["address"],
        status: json["status"],
        notifyProfileVisit: json['notify_profile_visit'],
        notifyFriendsNewPost: json['notify_friends_newpost'],
        resetToken: json["reset_token"],
        resetTokenExpire: json["reset_token_expire"],
        resetExpire: json["reset_expire"],
        phone: json["phone"],
        notifyMessage: json['notify_message'],
        isPhoneVerified: json["is_phone_verified"],
        ipAddress: json["ip_address"],
        isVerified: json["is_verified"],
        level: json["level"],
        bloodGroup: json["blood_group"],
        isAvailableForDonation: json["donation_available"],
        lastDonationDate: json["donation_date"],
        userLevel: json['user_level'] == null
            ? null
            : UserLevel.fromJson(json['user_level']),
        activated: json["activated"],
        activateToken: json["activate_token"],
        activateExpire: json["activate_expire"],
        role: json["role"],
        dateOfBirth: DateTime.tryParse(json["date_of_birth"] ?? ""),
        resetCode: json["reset_code"],
        resetCodeExpire: json["reset_code_expire"],
        createdAt: DateTime.tryParse(json["created_at"] ?? ""),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        deletedAt: json["deleted_at"],
        onlineStatus: json['online_status'],
        balance: json["balance"],
        points: json["points"],
        friendsCount: json['friends_count'] ?? 0,
        lastSeen: json["last_seen"],
        privacyBirthday: json["privacy_birthday"],
        privacyMessage: json["privacy_message"],
        privacyFriends: json["privacy_friends"],
        privacyEmail: json['privacy_view_email'],
        privacyPhone: json['privacy_view_phone'],
        working: json["working"],
        city: json["city"],
        relationId: json["relation_id"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        deviceModel: json["device_model"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        twitter: json["twitter"],
        youtube: json["youtube"],
        confirmFollowers: json["confirm_followers"],
        chatStatus: json["chat_status"],
        shareMyLocation: json["privacy_share_my_location"],
        shareMyData: json["share_my_data"],
        privacyFollow: json["privacy_follow"],
        privacyPost: json["privacy_post"],
        privacyShowActivities: json["privacy_show_activities"],
        privateAccount: json["privacy_private_account"],
        activeStatus: json["privacy_active_status"],
        hangoutPrivacy: json["hangout_privacy"],
        privacySeeFriend: json["privacy_see_friend"],
        notifyLike: json["notify_like"],
        notifyComment: json["notify_comment"],
        notifySharePost: json["notify_share_post"],
        notifyAcceptRequest: json["notify_accept_request"],
        notifyJoinedGroup: json["notify_joined_group"],
        notifyLikedPage: json["notify_liked_page"],
        memory: json["memory"],
        notifyViewStory: json["notify_view_story"],
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
        isFriend: json["isFriend"],
        isPending: json["isPending"],
        isAdmin: json["isAdmin"],
        distance: json['distance'],
        isRequestReceived: json['isRequestReceieved'],
        isBack: json['is_back'],
        timezone: json['timezone']);
  }
}

class Details {
  Details({
    this.followersCount,
    this.mutualFriendCount,
  });

  int? followersCount;
  int? mutualFriendCount;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      followersCount: json["followers_count"],
      mutualFriendCount: json["mutualFriendCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "followers_count": followersCount,
        "mutualFriendCount": mutualFriendCount,
      };
}

class UserLevel {
  UserLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.likeAmount,
    required this.packagePrice,
    required this.color,
    required this.payAmount,
    required this.duration,
    required this.status,
    required this.commentAmount,
    required this.shareAmount,
    required this.poLikeAmount,
    required this.poShareAmount,
    required this.poCommentAmount,
    required this.pointSpendable,
    required this.featuredMember,
    required this.verifiedBadge,
    required this.pagePromo,
    required this.postPromo,
    required this.editPost,
    required this.longerPost,
    required this.videoUploadSize,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  String? id;
  final String? name;
  final String? description;
  final String? likeAmount;
  final String? packagePrice;
  final String? color;
  final String? payAmount;
  final String? duration;
  final String? status;
  final String? commentAmount;
  final String? shareAmount;
  final String? poLikeAmount;
  final String? poShareAmount;
  final String? poCommentAmount;
  final String? pointSpendable;
  final String? featuredMember;
  final String? verifiedBadge;
  final String? pagePromo;
  final String? postPromo;
  final String? editPost;
  final String? longerPost;
  final String? videoUploadSize;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      likeAmount: json["like_amount"],
      packagePrice: json["package_price"],
      color: json["color"],
      payAmount: json["pay_amount"],
      duration: json["duration"],
      status: json["status"],
      commentAmount: json["comment_amount"],
      shareAmount: json["share_amount"],
      poLikeAmount: json["po_like_amount"],
      poShareAmount: json["po_share_amount"],
      poCommentAmount: json["po_comment_amount"],
      pointSpendable: json["point_spendable"],
      featuredMember: json["featured_member"],
      verifiedBadge: json["verified_badge"],
      pagePromo: json["page_promo"],
      postPromo: json["post_promo"],
      editPost: json["edit_post"],
      longerPost: json["longer_post"],
      videoUploadSize: json["video_upload_size"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }
}
