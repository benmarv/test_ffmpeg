import 'dart:developer' as dev;
import 'package:link_on/models/posts.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class InitializeVideoData extends ChangeNotifier {
  // Initialize variables
  VideoPlayerController? controller;
  List<Map<String, dynamic>> initializeVideoList = [];
  bool loading = false;
  Map<String, dynamic> tempData = {};
  int? jumpIndexValue;
  bool loadRequest = false;

// Add video data to the list
  void addDataInList({required List<Posts> videoModel}) async {
    for (int i = 0; i < videoModel.length; i++) {
      initializeVideoList.add({
        "load": false,
        "data": null,
        "url": videoModel[i].sharedPost != null
            ? videoModel[i].sharedPost!.video!.mediaPath
            : videoModel[i].video!.mediaPath,
        "videoId": videoModel[i].id,
        "thumbnail": videoModel[i].sharedPost != null
            ? videoModel[i].sharedPost!.videoThumbnail
            : videoModel[i].videoThumbnail,
      });

      notifyListeners();
    }
  }

// Handle the initialization of the next video
  void initializeNextHandler({
    required int index,
    bool? forward,
    bool? reverse,
  }) async {
    try {
      int previousIndex = forward == true
          ? index + 4
          : reverse == true
              ? index - 4
              : -1;
      if (initializeVideoList.asMap().containsKey(previousIndex) == true) {
        dev.log("index previous $previousIndex");
        if (initializeVideoList[previousIndex]['data'] != null) {
          initializeVideoList[previousIndex]['data'].dispose();
          setIndexValue(previousIndex, null, actualIndex: index);
        }
      }
    } catch (e) {
      dev.log("catch exception (002) => $e");
      throw Exception(e.toString());
    }
  }

// Set the controller and load status for a specific index
  void setIndexValue(index, dynamic controller, {actualIndex}) {
    tempData = {};
    tempData['$actualIndex'] = actualIndex;
    initializeVideoList[index]["data"] = controller;
    initializeVideoList[index]["load"] = false;
    notifyListeners();
  }

// Load or unload data for a specific index
  void loadPreviousData(index, bool value) {
    initializeVideoList[index]["load"] = value;
    notifyListeners();
  }

// Dispose of the video controller and update data for a specific index
  void disposeCurrentInit({required int index}) {
    dev.log("dispose=>");
    controller?.dispose();
    setIndexValue(index, null, actualIndex: index);
  }

// Clear the entire list and dispose of video controllers
  void makeListEmpty() {
    for (int i = 0; i < 4; i++) {
      try {
        if (tempData.isNotEmpty) {
          int key = tempData.entries.elementAt(0).value;
          if (initializeVideoList.asMap().containsKey(key + i) == true) {
            if (initializeVideoList[key + i]["data"] != null) {
              initializeVideoList[key + i]["data"].dispose();
            }
          }
          if (initializeVideoList.asMap().containsKey(key - i) == true) {
            if (initializeVideoList[key - i]["data"] != null) {
              initializeVideoList[key - i]["data"].dispose();
            }
          }
        }
      } catch (e) {
        dev.log("deleting error ------->>>>>>>> ${e.toString()}");
      }
    }
    tempData = {};
    initializeVideoList.clear();
    notifyListeners();
  }

// Set the loading state and notify listeners
  void loadingData({boolValue}) {
    loading = boolValue;
    notifyListeners();
  }

  bool pauseVideo = false;

// Set the pause state for the video and notify listeners
  playPuseVideo({value}) {
    pauseVideo = value;
    notifyListeners();
  }

// Set the index to jump to and notify listeners
  jumpToSpecificIndex({indexValue}) {
    jumpIndexValue = indexValue;
    notifyListeners();
  }

  bool isJumP = false;
}
