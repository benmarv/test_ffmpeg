import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class InitializePostsVideos extends ChangeNotifier {
  List<Map<String, dynamic>> initalizeVideo = [];
  FlickManager? flickManager;
  // Initialize a video using FlickManager
  Future initializePostVideos({videoId, videoUrl}) async {
    // Create a FlickManager for the video with the given URL
    flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
        autoInitialize: true, // Automatically initialize the video
        autoPlay: false); // Video does not auto-play

    // Check if the FlickManager is not null
    if (flickManager != null) {
      // Add the FlickManager and video ID to the initialization list
      initalizeVideo.add({
        "controller": flickManager, // Video controller
        "videoId": videoId, // Video ID
      });
    }

    // Notify listeners about the video initialization
    notifyListeners();
  }

// Add a video to the beginning of the initialization list
  void addAtFirstIndex({videoUrl, videoId}) {
    // Create a FlickManager for the video with the given URL
    flickManager = FlickManager(
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
        autoInitialize: true, // Automatically initialize the video
        autoPlay: false); // Video does not auto-play

    // Insert the FlickManager and video ID at the first index in the list
    initalizeVideo.insert(0, {
      "controller": flickManager, // Video controller
      "videoId": videoId, // Video ID
    });

    // Notify listeners about the video addition
    notifyListeners();
  }

// Reinitialize a video using FlickManager
  void againVideoNotInitialize({videoId, videoIndex, url}) {
    // Create a FlickManager for the video with the given URL
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(url)),
        autoInitialize: true, // Automatically initialize the video
        autoPlay: false); // Video does not auto-play

    // Check if the FlickManager is not null
    if (flickManager != null) {
      // Update the FlickManager for the video at the specified index
      initalizeVideo[videoIndex]["controller"] = flickManager;
      // Notify listeners about the video reinitialization
      notifyListeners();
    }
  }

// Play or pause a video
  void playPauseVideo({currentIndex}) {
    // Check if the video is currently playing
    if (initalizeVideo[currentIndex]["controller"].value.isPlaying == true) {
      // If playing, pause the video
      initalizeVideo[currentIndex]["controller"].pause();
    } else {
      // If not playing, play the video
      initalizeVideo[currentIndex]["controller"].play();
    }
    // Notify listeners about the change in video playback
    notifyListeners();
  }

// Boolean flag to control whether the YouTube video should be canceled
  bool cancelVideo = true;

// Update the cancelVideo flag to stop or allow playing the video
  cancelYoutubeVideos({cancelValue}) {
    cancelVideo = cancelValue;
    // Notify listeners about the change in the cancelVideo flag
    notifyListeners();
  }
}
