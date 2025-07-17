import 'dart:convert';

List<OfferModel> offerModelFromJson(String str) =>
    List<OfferModel>.from(json.decode(str).map((x) => OfferModel.fromJson(x)));

String offerModelToJson(List<OfferModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OfferModel {
  OfferModel({
    this.id,
    this.pageId,
    this.userId,
    this.discountType,
    this.discountPercent,
    this.discountAmount,
    this.discountedItems,
    this.buy,
    this.getPrice,
    this.spend,
    this.amountOff,
    this.description,
    this.expireDate,
    this.expireTime,
    this.image,
    this.currency,
    this.time,
    this.offerText,
    this.page,
    this.postId,
    this.url,
  });

  int? id;
  int? pageId;
  int? userId;
  String? discountType;
  int? discountPercent;
  int? discountAmount;
  String? discountedItems;
  int? buy;
  int? getPrice;
  int? spend;
  int? amountOff;
  String? description;
  String? expireDate;
  String? expireTime;
  String? image;
  String? currency;
  int? time;
  String? offerText;
  Page? page;
  int? postId;
  String? url;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        pageId: json["page_id"],
        userId: json["user_id"],
        discountType: json["discount_type"],
        discountPercent: json["discount_percent"],
        discountAmount: json["discount_amount"],
        discountedItems: json["discounted_items"],
        buy: json["buy"],
        getPrice: json["get_price"],
        spend: json["spend"],
        amountOff: json["amount_off"],
        description: json["description"],
        expireDate: json["expire_date"],
        expireTime: json["expire_time"],
        image: json["image"],
        currency: json["currency"],
        time: json["time"],
        offerText: json["offer_text"],
        page: json["page"] == null ? null : Page.fromJson(json["page"]),
        postId: json["post_id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "page_id": pageId,
        "user_id": userId,
        "discount_type": discountType,
        "discount_percent": discountPercent,
        "discount_amount": discountAmount,
        "discounted_items": discountedItems,
        "buy": buy,
        "get_price": getPrice,
        "spend": spend,
        "amount_off": amountOff,
        "description": description,
        "expire_date": expireDate,
        "expire_time": expireTime,
        "image": image,
        "currency": currency,
        "time": time,
        "offer_text": offerText,
        "page": page?.toJson(),
        "post_id": postId,
        "url": url,
      };
}

class Page {
  Page({
    this.pageId,
    this.userId,
    this.pageName,
    this.pageTitle,
    this.pageDescription,
    this.avatar,
    this.cover,
    this.usersPost,
    this.pageCategory,
    this.subCategory,
    this.website,
    this.facebook,
    this.google,
    this.vk,
    this.twitter,
    this.linkedin,
    this.company,
    this.phone,
    this.address,
    this.callActionType,
    this.callActionTypeUrl,
    this.backgroundImage,
    this.backgroundImageStatus,
    this.instgram,
    this.youtube,
    this.verified,
    this.active,
    this.registered,
    this.boosted,
    this.time,
    this.about,
    this.id,
    this.type,
    this.url,
    this.name,
    this.rating,
    this.category,
    this.pageSubCategory,
    this.isReported,
    this.isPageOnwer,
    this.username,
    this.fields,
  });

  String? pageId;
  String? userId;
  String? pageName;
  String? pageTitle;
  String? pageDescription;
  String? avatar;
  String? cover;
  String? usersPost;
  String? pageCategory;
  String? subCategory;
  String? website;
  String? facebook;
  String? google;
  String? vk;
  String? twitter;
  String? linkedin;
  String? company;
  String? phone;
  String? address;
  String? callActionType;
  String? callActionTypeUrl;
  String? backgroundImage;
  String? backgroundImageStatus;
  String? instgram;
  String? youtube;
  String? verified;
  String? active;
  String? registered;
  String? boosted;
  String? time;
  String? about;
  String? id;
  String? type;
  String? url;
  String? name;
  int? rating;
  String? category;
  String? pageSubCategory;
  bool? isReported;
  bool? isPageOnwer;
  String? username;
  List<dynamic>? fields;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        pageId: json["page_id"],
        userId: json["user_id"],
        pageName: json["page_name"],
        pageTitle: json["page_title"],
        pageDescription: json["page_description"],
        avatar: json["avatar"],
        cover: json["cover"],
        usersPost: json["users_post"],
        pageCategory: json["page_category"],
        subCategory: json["sub_category"],
        website: json["website"],
        facebook: json["facebook"],
        google: json["google"],
        vk: json["vk"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        company: json["company"],
        phone: json["phone"],
        address: json["address"],
        callActionType: json["call_action_type"],
        callActionTypeUrl: json["call_action_type_url"],
        backgroundImage: json["background_image"],
        backgroundImageStatus: json["background_image_status"],
        instgram: json["instgram"],
        youtube: json["youtube"],
        verified: json["verified"],
        active: json["active"],
        registered: json["registered"],
        boosted: json["boosted"],
        time: json["time"],
        about: json["about"],
        id: json["id"],
        type: json["type"],
        url: json["url"],
        name: json["name"],
        rating: json["rating"],
        category: json["category"],
        pageSubCategory: json["page_sub_category"],
        isReported: json["is_reported"],
        isPageOnwer: json["is_page_onwer"],
        username: json["username"],
        fields: json["fields"] == null
            ? []
            : List<dynamic>.from(json["fields"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "page_id": pageId,
        "user_id": userId,
        "page_name": pageName,
        "page_title": pageTitle,
        "page_description": pageDescription,
        "avatar": avatar,
        "cover": cover,
        "users_post": usersPost,
        "page_category": pageCategory,
        "sub_category": subCategory,
        "website": website,
        "facebook": facebook,
        "google": google,
        "vk": vk,
        "twitter": twitter,
        "linkedin": linkedin,
        "company": company,
        "phone": phone,
        "address": address,
        "call_action_type": callActionType,
        "call_action_type_url": callActionTypeUrl,
        "background_image": backgroundImage,
        "background_image_status": backgroundImageStatus,
        "instgram": instgram,
        "youtube": youtube,
        "verified": verified,
        "active": active,
        "registered": registered,
        "boosted": boosted,
        "time": time,
        "about": about,
        "id": id,
        "type": type,
        "url": url,
        "name": name,
        "rating": rating,
        "category": category,
        "page_sub_category": pageSubCategory,
        "is_reported": isReported,
        "is_page_onwer": isPageOnwer,
        "username": username,
        "fields":
            fields == null ? [] : List<dynamic>.from(fields!.map((x) => x)),
      };
}
