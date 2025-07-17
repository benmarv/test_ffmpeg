import 'dart:convert';

WalletDetails walletDetailsFromJson(String str) =>
    WalletDetails.fromJson(json.decode(str));

String walletDetailsToJson(WalletDetails data) => json.encode(data.toJson());

class WalletDetails {
  String? wallet;
  String? balance;
  dynamic points;
  dynamic dailyPoints;
  dynamic pointDayExpire;

  WalletDetails({
    this.wallet,
    this.balance,
    this.points,
    this.dailyPoints,
    this.pointDayExpire,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) => WalletDetails(
        wallet: json["wallet"],
        balance: json["balance"],
        points: json["points"],
        dailyPoints: json["daily_points"],
        pointDayExpire: json["point_day_expire"],
      );

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "balance": balance,
        "points": points,
        "daily_points": dailyPoints,
        "point_day_expire": pointDayExpire,
      };
}
