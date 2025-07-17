import 'package:flutter/cupertino.dart';

class SplashProvider extends ChangeNotifier {
  bool isDataLoaded = false;

  void setSiteSettingDataLoading({required bool value}) {
    isDataLoaded = value;
    notifyListeners();
  }
}
