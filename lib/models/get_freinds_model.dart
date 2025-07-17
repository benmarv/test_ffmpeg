import 'dart:convert';
import 'package:link_on/models/usr.dart';

GetFreindsModel getFreindsModelFromJson(String str) =>
    GetFreindsModel.fromJson(json.decode(str));

class GetFreindsModel {
  GetFreindsModel({
    this.following,
    this.followers,
  });

  List<Usr>? following;
  List<Usr>? followers;

  factory GetFreindsModel.fromJson(Map<String, dynamic> json) =>
      GetFreindsModel(
          following:
              List<Usr>.from(json["following"].map((x) => Usr.fromJson(x))),
          followers:
              List<Usr>.from(json["followers"].map((x) => Usr.fromJson(x))));
}
