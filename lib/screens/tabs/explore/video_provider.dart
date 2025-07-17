// ignore_for_file: avoid_print
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoPlayerProvider with ChangeNotifier {
  bool isLoading = false;

  void setVideoEditorLoading({required bool value}) {
    isLoading = value;
    notifyListeners();
  }

  CachedVideoPlayerPlusController? controller;

  // Play the video
  void play() {
    controller?.play();
    notifyListeners();
  }

  // Pause the video
  void pause() {
    controller?.pause();
    notifyListeners();
  }

  // Toggle play/pause
  void playPause() {
    if (controller?.value.isPlaying ?? false) {
      pause();
    } else {
      play();
    }
    notifyListeners();
  }

  // Function to dispose of the video controller
  void disposeController() {
    print('controller disposed');

    controller?.dispose();
    notifyListeners();
  }
}
