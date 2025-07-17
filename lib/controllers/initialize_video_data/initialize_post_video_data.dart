import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InitializePostVideoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> initializePostVideoDataList = [];
  Map<String, dynamic> tempData = {};
  Map<String, dynamic> saveOnlyInit = {};
  int storeIndex = 0;
  int compareIndex = -1;
  bool loading = false;
  FlickManager? flickManager;
  // Initialize and load a video for a post at the given index
  initPostVideo({required index, required url}) async {
    log("Entering the main function");

    // Set a loading indicator to indicate video loading
    loadingFuntion(boolValue: true);

    // Create a FlickManager for the video using the provided URL
    flickManager = FlickManager(
      autoPlay: true,
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(url),
      ),
    );

    // Store the video data and URL in the initializePostVideoDataList
    initializePostVideoDataList[index]["data"] = flickManager;
    initializePostVideoDataList[index]["url"] = url;

    // Track the currently initialized videos by their index
    saveOnlyInit["$index"] = index;

    log("Length of initialized videos: ${saveOnlyInit.length}");

    // If the number of initialized videos exceeds a certain limit (e.g., 5),
    // release the resources of the oldest video
    if (saveOnlyInit.length > 5) {
      if (tempData.isNotEmpty) {
        try {
          var key = tempData.keys.toList()[0];
          if (tempData.containsKey(key) == true) {
            initializePostVideoDataList[tempData[key.toString()]]["data"]
                .dispose();
            initializePostVideoDataList[tempData[key.toString()]]["data"] =
                null;
            tempData.remove(key.toString());
          }
        } catch (e) {
          print(e.toString());
        }
      } else {
        log("Cleaning up...");
        for (int i = storeIndex; i < saveOnlyInit.length; i++) {
          var key = saveOnlyInit.keys.toList()[i];
          if (initializePostVideoDataList[saveOnlyInit[key.toString()]]
                  ["data"] !=
              null) {
            initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"]
                .dispose();
            initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"] =
                null;
            initializePostVideoDataList[saveOnlyInit[key.toString()]]["flag"] =
                0;
            storeIndex = i;
            break;
          }
        }
      }
    }

    // Reset the loading indicator
    loadingFuntion(boolValue: false);

    // Notify listeners about the video initialization
    notifyListeners();
  }

  // Reinitialize and load a video at the given index
  void initializeAgain({url, index}) async {
    log("Entering the second entry point");

    // Set a loading indicator to indicate video loading
    loadingFuntion(boolValue: true);

    // Create a FlickManager for the video using the provided URL
    flickManager = FlickManager(
        autoPlay: true,
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(url))
        // VideoPlayerController.network(url)

        );

    // Store the video data in the initializePostVideoDataList
    initializePostVideoDataList[index]["data"] = flickManager;

    // Track the currently initialized videos by their index
    tempData["$index"] = index;

    // If the number of temporarily initialized videos exceeds a certain limit (e.g., 3),
    // release the resources of the oldest video
    if (tempData.length > 3) {
      try {
        var key = tempData.keys.toList()[0];
        if (tempData.containsKey(key) == true) {
          initializePostVideoDataList[tempData[key.toString()]]["data"]
              .dispose();
          initializePostVideoDataList[tempData[key.toString()]]["data"] = null;
          initializePostVideoDataList[tempData[key.toString()]]["flag"] = 0;
          tempData.remove(key.toString());
        }
      } catch (e) {
        print(e.toString());
      }
    }

    // Get the current index for the last saved video
    int cIndex = saveOnlyInit.length - 1;
    var key = saveOnlyInit.keys.toList()[cIndex];

    // If the last saved video exists, dispose of its resources
    if (initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"] !=
        null) {
      initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"]
          .dispose();
      initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"] = null;
      initializePostVideoDataList[saveOnlyInit[key.toString()]]["flag"] = 0;
    }

    // Reset the loading indicator
    loadingFuntion(boolValue: false);

    // Notify listeners about the video reinitialization
    notifyListeners();
  }

  // Add data to the initializePostVideoDataList
  addDataDataToList({index}) {
    // Create a new entry in the list to store video data
    initializePostVideoDataList.add({
      "index": index, // Index of the video
      "data": null, // Video data (initially null)
      "flag": 1, // Flag indicating video initialization
    });

    // Notify listeners about the data addition
    notifyListeners();
  }

// Toggle the loading indicator
  loadingFuntion({required boolValue}) {
    loading = boolValue; // Set the loading indicator value
    notifyListeners();
  }

// Clear the video data and reset the related variables
  makeListEmpty() {
    // Dispose of video resources for the remaining saved videos
    for (int i = storeIndex; i < saveOnlyInit.length; i++) {
      var key = saveOnlyInit.keys.toList()[i];
      if (initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"] !=
          null) {
        initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"]
            .dispose();
        initializePostVideoDataList[saveOnlyInit[key.toString()]]["data"] =
            null;
        initializePostVideoDataList[saveOnlyInit[key.toString()]]["flag"] = 0;
      }
    }

    // Dispose of video resources for the temporarily initialized videos
    if (tempData.isNotEmpty) {
      for (int i = 0; i < tempData.length; i++) {
        var key = tempData.keys.toList()[0];
        if (tempData.containsKey(key) == true) {
          initializePostVideoDataList[tempData[key.toString()]]["data"]
              .dispose();
          initializePostVideoDataList[tempData[key.toString()]]["data"] = null;
          initializePostVideoDataList[tempData[key.toString()]]["flag"] = 0;
          tempData.remove(key.toString());
        }
      }
    }

    // Clear all video data and reset related variables
    initializePostVideoDataList = [];
    tempData = {};
    saveOnlyInit = {};
    storeIndex = 0;

    // Notify listeners about the list being made empty
    notifyListeners();
  }

// Initialize video at the first index in the list
  initializeVideoAtFirstIndex({url}) {
    // Insert a new entry at the beginning of the list to store video data
    initializePostVideoDataList.insert(0, {
      "data": null, // Video data (initially null)
      "url": url, // URL of the video
      "flag": 0, // Flag indicating video initialization
    });

    // Save the index of the first video
    Map<String, dynamic> map = saveOnlyInit;
    saveOnlyInit = {};
    saveOnlyInit.addAll({
      "0": 0,
    });

    // Update the indices for previously saved videos
    if (map.isNotEmpty) {
      for (int i = 0; i < map.length; i++) {
        var key = map.keys.toList()[i];
        saveOnlyInit.addAll({
          "${int.parse(key) + 1}": int.parse(key) + 1,
        });
      }
    }

    // Notify listeners about the video initialization
    notifyListeners();
  }

// Toggle the cancelVideo flag
  bool cancelVideo = true;
  cancelYoutubeVideos({cancelValue}) {
    cancelVideo = cancelValue; // Set the cancelVideo flag
    notifyListeners();
  }
}
