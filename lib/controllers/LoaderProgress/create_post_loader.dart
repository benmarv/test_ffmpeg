import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';

class CreatePostLoader extends ChangeNotifier {
 // Dynamic variable to store progress
dynamic progress = 0;
// Nullable boolean to check if a pop action is needed
bool? checkPop;
// Dynamic variable to store circular progress
dynamic circulrProgress;

// Function to set the progress value
void setProgress(value, {context, ispop}) async {
  progress = await value;
  if (progress == 100) {
    if (ispop == true) {
      // Pop the current route if ispop is true
      Navigator.of(context).pop();
    } else {
      // Pop the current route and navigate to the TabsPage
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>const TabsPage(
        
          ),
        ),
      );
    }
    // Reset progress to 0
    progress = 0;
  }
  notifyListeners();
}

// Function to set the circular progress value
void setCircularProgress(value, {context}) async {
  circulrProgress = await value;
  notifyListeners();
}

// Function to set the checkPop value and reset it to false
void setCheckPop(value) {
  checkPop = value;
  notifyListeners();
  checkPop = false; // Reset checkPop to false
}

  // Dynamic variable to store progress data
dynamic _progressData = 0.0;

// Getter to access progress data
get progressData => _progressData;

// Setter to update sendingProgress with a progress value
set sendingProgress(progress) {
  log("$progressData");
  _progressData = progress;
  if (_progressData == 100) {
    // When progress reaches 100%, call updataProgressData
    updataProgressData();
  }
  notifyListeners();
}

// Function to reset _progressData to 0 and notify listeners
void updataProgressData() {
  _progressData = 0;
  notifyListeners();
}

// Getter to access progress data
get getProgressValue => progress;

// Getter to access circular progress value
get getCircularProgressValue => circulrProgress;

}