class UserWallet {
  UserWallet({
    required this.status,
    required this.message,
    required this.amount,
    required this.earning,
    required this.sevenDayEarning,
  });

  final String? status;
  final String? message;
  final String? amount;
  final Earning? earning;
  final List<SevenDayEarning> sevenDayEarning;

  factory UserWallet.fromJson(Map<String, dynamic> json) {
    return UserWallet(
      status: json["status"],
      message: json["message"],
      amount: json["amount"],
      earning:
          json["earning"] == null ? null : Earning.fromJson(json["earning"]),
      sevenDayEarning: json["seven_day_earning"] == null
          ? []
          : List<SevenDayEarning>.from(json["seven_day_earning"]!
              .map((x) => SevenDayEarning.fromJson(x))),
    );
  }
}

class Earning {
  Earning({
    required this.likeEarnings,
    required this.commentEarnings,
    required this.shareEarnings,
    required this.withdrawEarnings,
    required this.depositEarnings,
    required this.totalEarnings,
    required this.sevenDayEarning,
  });

  final String? likeEarnings;
  final String? commentEarnings;
  final String? shareEarnings;
  final String? withdrawEarnings;
  final String? depositEarnings;
  final String? totalEarnings;
  final String? sevenDayEarning;

  factory Earning.fromJson(Map<String, dynamic> json) {
    return Earning(
      likeEarnings: json["like_earnings"],
      commentEarnings: json["comment_earnings"],
      shareEarnings: json["share_earnings"],
      withdrawEarnings: json["withdraw_earnings"],
      depositEarnings: json["deposit_earnings"],
      totalEarnings: json["total_earnings"],
      sevenDayEarning: json["seven_day_earning"],
    );
  }
}

class SevenDayEarning {
  SevenDayEarning({
    required this.day,
    required this.totalEarnings,
  });

  final DateTime? day;
  final String? totalEarnings;

  factory SevenDayEarning.fromJson(Map<String, dynamic> json) {
    return SevenDayEarning(
      day: DateTime.tryParse(json["day"] ?? ""),
      totalEarnings: json["total_earnings"],
    );
  }
}
