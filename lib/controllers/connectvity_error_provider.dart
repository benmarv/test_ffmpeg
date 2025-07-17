import 'package:flutter/material.dart';
import 'package:link_on/consts/constants.dart';

class ConnectivityErrorProvider extends ChangeNotifier {
  bool noInternet = false;
  bool connectivityTimeout = false;
  bool recievingTimeout = false;

// Function to handle connectivity errors in app.
  void connectivityErrors({required String error}) {
    noInternet = false;
    connectivityTimeout = false;
    recievingTimeout = false;
    switch (error) {
      case Constants.noInternet:
        {
          noInternet = true;
          break;
        }
      case Constants.timeOutConnection:
        {
          connectivityTimeout = true;
          break;
        }
    }
    notifyListeners();
  }

// Function to make connection list empty.
  void makeConnectionEmpty() {
    noInternet = false;
    connectivityTimeout = false;
    recievingTimeout = false;
    notifyListeners();
  }
}
