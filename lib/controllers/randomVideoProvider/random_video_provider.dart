// ignore_for_file: use_build_context_synchronously
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/controllers/videolike/video_like_provider.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/controllers/connectvity_error_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'dart:developer' as dev;

class RandomVideoProvider extends ConnectivityErrorProvider {
  late VideoPlayerController videoPlayerController;
  List<Posts> randomVideoListProvider = [];
  bool check = false;
  bool noData = false;
  bool loadRequest = false;
  bool internetValue = false;
  CachedVideoPlayerPlusController? controller;
  List<String> tempVideoUrls = [];
  Future<void> preCacheVideos(List<String> videoUrls) async {
    for (String url in videoUrls) {
      if (!tempVideoUrls.contains(url)) {
        tempVideoUrls.add(url);
        print('cached video url : $url');
        CachedVideoPlayerPlusController.networkUrl(Uri.parse(url)).initialize();
      }
    }
    notifyListeners();
  }

  Future<void> gertRandomVideo(
      {afterPostIdVideo, context, onRefresh, required bool isHome}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    checkInternet(boolValue: false);
    super.makeConnectionEmpty();
    if (onRefresh == true) {
      checkData(false);
    }
    VideosLikeProvider provider =
        Provider.of<VideosLikeProvider>(context, listen: false);

    var accessToken = getStringAsync("access_token");

    Map<String, dynamic> mapData = {
      'post_type': '2',
      'limit': 6,
    };
    if (afterPostIdVideo != null) {
      mapData["last_post_id"] = afterPostIdVideo;
    }

    FormData form = FormData.fromMap(mapData);
    Response response = await dioService.dio.post(
      'post/newsfeed',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );
    var res = response.data;
    if (res['code'] == '200') {
      List<Posts> tempList = [];
      var productsData = res["data"];

      tempList = List.from(productsData).map<Posts>((post) {
        return Posts.fromJson(post);
      }).toList();

      if (tempList.isEmpty || tempList == []) {
        loadNewData(load: false);

        checkNoData(isEnd: true);
      } else {
        if (onRefresh != true) {
          print('get random videos onrefresh false');
          for (int i = 0; i < tempList.length; i++) {
            // add videos in cache
            List<String> videoUrls = [];
            videoUrls.add(tempList[i].video!.mediaPath!);
            // cache videos
            if (isHome) {
              preCacheVideos(videoUrls);
            }

            // Directly add the element from tempList to randomVideoListProvider
            if (!randomVideoListProvider
                .any((post) => post.id == tempList[i].id)) {
              randomVideoListProvider.add(tempList[i]);
              check = true;
              loadNewData(load: false);
              checkNoData(isEnd: false);
              notifyListeners();

              // Use the element from tempList directly for saving reaction data
              provider.saveReactionData({
                "reactionType": tempList[i].reaction?.reactionType,
                "postId": tempList[i].id,
                "isReacted": tempList[i].reaction?.isReacted,
                "count": tempList[i].reaction?.count,
              });
            }
          }
        } else {
          print('get random videos onrefresh true');

          makeEmptyList();

          provider.makeEmptyList();

          for (int i = 0; i < tempList.length; i++) {
            if (!randomVideoListProvider
                .any((post) => post.id == tempList[i].id)) {
              randomVideoListProvider.add(tempList[i]);

              checkData(true);
              loadNewData(load: false);
              checkNoData(isEnd: false);

              provider.saveReactionData({
                "reactionType": tempList[i].reaction!.reactionType,
                "postId": tempList[i].id,
                "isReacted": tempList[i].reaction!.isReacted,
                "count": tempList[i].reaction!.count,
              }, insertAt: 0);
            }
          }

          notifyListeners();
        }
      }
    } else {
      checkData(true);
      loadNewData(load: false);
      notifyListeners();
      if (res.containsKey(Constants.timeOutConnection)) {
        super.connectivityErrors(error: res[Constants.timeOutConnection]);
      } else if (res.containsKey(Constants.noInternet)) {
        toast("No internet");
        super.connectivityErrors(error: Constants.noInternet);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['errors']['error_text']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

// Function to report a post.
  Future<void> reportPost({postId, BuildContext? context, int? index}) async {
    customDialogueLoader(context: context);
    Map<String, dynamic> mapData = {"post_id": postId, "action": "report"};
    dynamic res = await apiClient.callApiCiSocial(
      apiData: mapData,
      apiPath: "post/action",
    );
    dev.log("report response is $res");
    if (res["code"] == '200') {
      context!.pop();

      toast("Report successfully");
      notifyListeners();
    } else {
      context!.pop();
      if (res != Constants.noInternet && res != Constants.receivingTimeOut) {
        log("Error: ${res['message']}");
      }
    }
  }

// Function for no data dialog.
  void checkNoData({isEnd}) {
    noData = isEnd;
    if (noData == true) {
      log("No more videos to show");
    }
    notifyListeners();
  }

// Function to load more data.
  void loadNewData({load}) {
    loadRequest = load;
    notifyListeners();
  }

// Function to check data.
  void checkData(boolCheck) {
    check = boolCheck;
    notifyListeners();
  }

  makeEmptyList() {
    randomVideoListProvider = [];
    notifyListeners();
  }

// Function to remove video from list.
  removeAtIndex({index}) {
    randomVideoListProvider.removeAt(index);
    notifyListeners();
  }

// Function to check internet connectivity.
  checkInternet({boolValue}) {
    internetValue = boolValue;
    notifyListeners();
  }

// Function for comment changes in random videos.
  void commentChangesRandomVideos(int index, bool increment) {
    String commentValue = randomVideoListProvider[index].commentCount!;
    if (increment == true) {
      randomVideoListProvider[index].commentCount =
          (commentValue.toInt() + 1).toString();
    } else {
      randomVideoListProvider[index].commentCount =
          (commentValue.toInt() - 1).toString();
    }
    notifyListeners();
  }
}
