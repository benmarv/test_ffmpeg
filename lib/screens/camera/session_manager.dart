import 'dart:convert';
import 'dart:core';
import 'package:nb_utils/nb_utils.dart';

class SessionManager {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  static int? userId = -1;
  static String? accessToken = '';

  // Initialize the SharedPreferences instance.
  Future initPref() async {
    sharedPreferences = await _pref;
  }

  // Save a boolean value with the given key.
  void saveBoolean(String key, bool value) async {
    if (sharedPreferences != null) sharedPreferences!.setBool(key, value);
  }

  // Retrieve a boolean value with the given key.
  bool? getBool(String key) {
    return sharedPreferences == null || sharedPreferences!.getBool(key) == null
        ? false
        : sharedPreferences!.getBool(key);
  }

  // Save an integer value with the given key.
  void saveInteger(String key, int value) async {
    if (sharedPreferences != null) sharedPreferences!.setInt(key, value);
  }

  // Retrieve an integer value with the given key.
  int? getInteger(String key) {
    return sharedPreferences == null || sharedPreferences!.getInt(key) == null
        ? 0
        : sharedPreferences!.getInt(key);
  }

  void saveBearerToken(String bearerToken) {
    initPref();
    sharedPreferences!.setString('bearer_token', bearerToken);
  }

  // Save a string value with the given key.
  void saveString(String key, String? value) async {
    if (sharedPreferences != null) sharedPreferences!.setString(key, value!);
  }

  // Retrieve a string value with the given key.
  String? getString(String key) {
    return sharedPreferences == null ||
            sharedPreferences!.getString(key) == null
        ? ''
        : sharedPreferences!.getString(key);
  }

  // Save user-related information.



  // Save or remove a favorite music item.
  void saveFavouriteMusic(String id) {
    List<dynamic> fav = getFavouriteMusic();
    // ignore: unnecessary_null_comparison
    if (fav != null) {
      if (fav.contains(id)) {
        fav.remove(id);
      } else {
        fav.add(id);
      }
    } else {
      fav = [];
      fav.add(id);
    }
    if (sharedPreferences != null) {
      sharedPreferences!.setString("favourite", json.encode(fav));
    }
  }

  // Retrieve favorite music items.
  List<String> getFavouriteMusic() {
    if (sharedPreferences != null) {
      String? userString = sharedPreferences!.getString("favourite");
      if (userString != null && userString.isNotEmpty) {
        List<dynamic> dummy = json.decode(userString);
        return dummy.map((item) => item as String).toList();
      }
    }
    return [];
  }

  // Clear all stored data.
  void clean() {
    sharedPreferences!.clear();
    userId = -1;
    accessToken = '';
    removeKey('userIdF');
    removeKey('access_token');
  }
}

class NumberFormatter {
  static String formatter(String currentBalance) {
    try {
      // suffix = {' ', 'k', 'M', 'B', 'T', 'P', 'E'};
      double value = double.parse(currentBalance);

      if (value < 1000) {
        // Less than a thousand, no formatting needed.
        return value.toStringAsFixed(0);
      } else if (value >= 1000 && value < 1000000) {
        // Value is in thousands, format as K.
        double result = value / 1000;
        return result.toStringAsFixed(2) + "K";
      } else if (value >= 1000000 && value < (1000000 * 10 * 100)) {
        // Value is in millions, format as M.
        double result = value / 1000000;
        return result.toStringAsFixed(2) + "M";
      } else if (value >= (1000000 * 10 * 100) &&
          value < (1000000 * 10 * 100 * 100)) {
        // Value is in billions, format as B.
        double result = value / (1000000 * 10 * 100);
        return result.toStringAsFixed(2) + "B";
      } else if (value >= (1000000 * 10 * 100 * 100) &&
          value < (1000000 * 10 * 100 * 100 * 100)) {
        // Value is in trillions, format as T.
        double result = value / (1000000 * 10 * 100 * 100);
        return result.toStringAsFixed(2) + "T";
      } else {
        // Value is very large, return as is.
        return currentBalance;
      }
    } catch (e) {
      print(e);
      return currentBalance;
    }
  }
}
