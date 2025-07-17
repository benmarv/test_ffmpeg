import 'dart:convert';

List<Jobs> jobsFromJson(String str) =>
    List<Jobs>.from(json.decode(str).map((x) => Jobs.fromJson(x)));

String jobsToJson(List<Jobs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jobs {
  Jobs({
    this.id,
    this.userId,
    this.pageId,
    this.title,
    this.location,
    this.lat,
    this.lng,
    this.minimum,
    this.maximum,
    this.salaryDate,
    this.jobType,
    this.category,
    this.questionOne,
    this.questionOneType,
    this.questionOneAnswers,
    this.questionTwo,
    this.questionTwoType,
    this.questionTwoAnswers,
    this.questionThree,
    this.questionThreeType,
    this.questionThreeAnswers,
    this.description,
    this.image,
    this.imageType,
    this.currency,
    this.status,
    this.time,
    this.page,
    this.apply,
    this.url,
    this.applyCount,
    this.postId,
  });

  String? id;
  String? userId;
  String? pageId;
  String? title;
  String? location;
  String? lat;
  String? lng;
  String? minimum;
  String? maximum;
  String? salaryDate;
  String? jobType;
  String? category;
  String? questionOne;
  String? questionOneType;
  dynamic questionOneAnswers;
  String? questionTwo;
  String? questionTwoType;
  dynamic questionTwoAnswers;
  String? questionThree;
  String? questionThreeType;
  dynamic questionThreeAnswers;
  String? description;
  String? image;
  String? imageType;
  String? currency;
  String? status;
  String? time;
  Page? page;
  bool? apply;
  String? url;
  String? applyCount;
  dynamic postId;

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
        id: json["id"],
        userId: json["user_id"],
        pageId: json["page_id"],
        title: json["title"],
        location: json["location"],
        lat: json["lat"],
        lng: json["lng"],
        minimum: json["minimum"],
        maximum: json["maximum"],
        salaryDate: json["salary_date"],
        jobType: json["job_type"],
        category: json["category"],
        questionOne: json["question_one"],
        questionOneType: json["question_one_type"],
        questionOneAnswers: json["question_one_answers"],
        questionTwo: json["question_two"],
        questionTwoType: json["question_two_type"],
        questionTwoAnswers: json["question_two_answers"],
        questionThree: json["question_three"],
        questionThreeType: json["question_three_type"],
        questionThreeAnswers: json["question_three_answers"],
        description: json["description"],
        image: json["image"],
        imageType: json["image_type"],
        currency: json["currency"],
        status: json["status"],
        time: json["time"],
        apply: json["apply"],
        url: json["url"],
        applyCount: json["apply_count"],
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "page_id": pageId,
        "title": title,
        "location": location,
        "lat": lat,
        "lng": lng,
        "minimum": minimum,
        "maximum": maximum,
        "salary_date": salaryDate,
        "job_type": jobType,
        "category": category,
        "question_one": questionOne,
        "question_one_type": questionOneType,
        "question_one_answers": questionOneAnswers,
        "question_two": questionTwo,
        "question_two_type": questionTwoType,
        "question_two_answers": questionTwoAnswers,
        "question_three": questionThree,
        "question_three_type": questionThreeType,
        "question_three_answers": questionThreeAnswers,
        "description": description,
        "image": image,
        "image_type": imageType,
        "currency": currency,
        "status": status,
        "time": time,
        "page": page!.toJson(),
        "apply": apply,
        "url": url,
        "apply_count": applyCount,
        "post_id": postId,
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
        fields: List<dynamic>.from(json["fields"].map((x) => x)),
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
        "fields": List<dynamic>.from(fields!.map((x) => x)),
      };
}
