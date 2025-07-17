import 'package:dio/dio.dart';

class Constants {
  // Name of the app
  static const String appName = "LinkOn";
  static const String appPurchaseCode = "15a5d786-765e-48f1-8d56-34338d357051";

  // Primary font for the app

  static bool isFriendSystem = true;

// Cancel token for API requests
  static CancelToken cancelToken = CancelToken();

// deepar keys
  static String androidKey =
      "eae9309739ebccb95155ae3f1e3ee02baae3fcd968dee56d63723f513d478801ea10bf6f576e47e6";
  static String iosKey =
      "66fb018505963fabbaa309ea6a0adbdaf8330a1ce4ccd47f5f0fcc43d6b12fd49e24849e05beb123";

// Error constants
  static const String noInternet = "no_internet";
  static const String timeOutConnection = "timeoutConnection";
  static const String receivingTimeOut = "receivingTimeOut";
  static const String invalidToken = "Invalid or expired access_token";

  // end-points
  static const String baseUrl = 'https://hiphop.socioon.com/api';
  static const String baseUrlK = 'https://hiphop.socioon.com';
  static const String favourite = 'favourite';
  static const String keyWord = 'keyword';
  static const String getSearchSoundList = "$baseUrl/get-search-sound-list";
  static const String authorization = 'Authorization';
  static const String addRemoveFavSounds = '$baseUrl/post/fav-unfav-sound';
  static const String getFavouriteSoundList =
      "$baseUrl/post/get-fav-sound-list";
  static const String chatItemBaseUrl = '$baseUrlK/uploads/videos/';
  static const String fetchSoundList = '$baseUrl/get-sound-by-category';
  static const String camera = '';
  static const bool isDialog = false;
}
