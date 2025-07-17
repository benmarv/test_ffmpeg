import 'package:flutter/cupertino.dart';

class IntializeVideoDataProvider extends ChangeNotifier {
  // List to store video initialization data
  List<Map<String, dynamic>> initalizeVideo = [];

// Method to initialize a video with the provided data
  initializeVideo({videoId, initData, controller, indexCheck}) {
    // Future to initialize the video player
    Future<void>? initializeVideoPlayerFuture = controller?.initialize();

    bool check = false;

    // Check if the 'initalizeVideo' list is not empty
    if (initalizeVideo.isNotEmpty) {
      // Check if the video with the given 'videoId' already exists in the list
      if (initalizeVideo[indexCheck]["videoId"] == videoId) {
        check = true;
      }
    } else {
      // If the list is empty, insert the video data into the list
      initalizeVideo.insert(indexCheck, {
        "controller": controller,
        "videoId": videoId,
        "initData": initializeVideoPlayerFuture,
      });

      // Notify listeners of the change
      notifyListeners();
    }

    // If the video is not already in the list, insert it and notify listeners
    if (check == false) {
      initalizeVideo.insert(indexCheck, {
        "controller": controller,
        "videoId": videoId,
        "initData": initializeVideoPlayerFuture,
      });

      // Notify listeners of the change
      notifyListeners();
    }
  }

  // Method to play or pause a video at the given 'currentIndex'
  playPauseVideo({currentIndex}) {
    // Check if the video at the current index is playing
    if (initalizeVideo[currentIndex]["controller"].value.isPlaying == true) {
      // If it is playing, pause the video
      initalizeVideo[currentIndex]["controller"].pause();
      notifyListeners();
    } else {
      // If it is not playing, play the video
      initalizeVideo[currentIndex]["controller"].play();
      notifyListeners();
    }
  }

// Method to clear the 'initalizeVideo' list and notify listeners
  makeEmptyList() {
    initalizeVideo = [];
    notifyListeners();
  }
}
