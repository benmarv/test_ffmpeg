import 'package:flutter/material.dart';

class CreatStoryProgress extends ChangeNotifier {
  // Dynamic variable to store progress data
  dynamic progress = 0.0;

// Boolean variable to check visibility
  bool? check = false;

// Dynamic variable to store circular progress data
  dynamic circulrProgress;

// Function to set the progress value
  void setProgress(value, {context}) {
    // Update the progress variable
    progress = value;

    notifyListeners();

    if (value == 100) {
      // If progress reaches 100%, reset it to 0 and close the context
      progress = 0;
      Navigator.pop(context);
    }
  }

// Getter to access progress data
  get getProgressValue => progress;

// Getter to access the visibility status
  bool? get getVisible => check;
}
