// ignore_for_file: prefer_conditional_assignment

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:link_on/models/page_data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';

class LikePageProvider extends ChangeNotifier {
  List<Map<String, dynamic>> likesData = [];
  bool? isReactedValue;
  String? globallPageId;
  Timer? _timer;

  /// Function to handle liking a page.
  ///
  /// [pageId] - The ID of the page to like.
  /// [index] - The index of the page in the list.
  /// [value] - The like value (true for like, false for unlike).
  Future likePage(
      {required PageData pageId, required index, required value}) async {
    pageId.isLiked = value;
    if (globallPageId == null) {
      // Enter this block if no page is being processed.
      globallPageId = pageId.id;
      isReactedValue = null;
      isReactedValue = likesData[index]["is_liked"];
      pageLikeProvider(index: index, value: value);
      await setValue("pageLikeValue", value);

      _timer = Timer(const Duration(seconds: 2), () async {
        switch (getBoolAsync("pageLikeValue")) {
          case false:
            {
              if (isReactedValue == true) {
                await hitPageApi(pageId: pageId.id);
                isReactedValue = null;
                globallPageId = null;
                await removeKey("pageLikeValue");
              }
              break;
            }
          case true:
            {
              if (isReactedValue == false) {
                await hitPageApi(pageId: pageId.id);
                isReactedValue = null;
                globallPageId = null;
                await removeKey("pageLikeValue");
              }
              break;
            }
        }
      });
    } else {
      // Enter this block if there's an ongoing page operation.
      if (pageId.id != globallPageId) {
        // If the requested page is different from the ongoing operation.
        await removeKey("pageLikeValue");
        isReactedValue = null;
        if (isReactedValue == null) {
          isReactedValue = likesData[index]["is_liked"];
        }
        pageLikeProvider(index: index, value: value);
        await setValue("pageLikeValue", value);

        _timer = Timer(const Duration(seconds: 2), () async {
          switch (getBoolAsync("pageLikeValue")) {
            case false:
              {
                if (isReactedValue == true) {
                  await hitPageApi(pageId: pageId.id);
                  isReactedValue = null;
                  globallPageId = null;
                  await removeKey("pageLikeValue");
                }
                break;
              }
            case true:
              {
                if (isReactedValue == false) {
                  await hitPageApi(pageId: pageId.id);
                  isReactedValue = null;
                  globallPageId = null;
                  await removeKey("pageLikeValue");
                }
                break;
              }
          }
        });
      } else {
        // Enter this block if the requested page is the same as the ongoing operation.
        _timer?.cancel();
        if (isReactedValue == null) {
          isReactedValue = likesData[index]["is_liked"];
        }
        pageLikeProvider(index: index, value: value);
        await setValue("pageLikeValue", value);

        _timer = Timer(const Duration(seconds: 2), () async {
          switch (getBoolAsync("pageLikeValue")) {
            case false:
              {
                if (isReactedValue == true) {
                  await hitPageApi(pageId: pageId.id);
                  isReactedValue = null;
                  globallPageId = null;
                  await removeKey("pageLikeValue");
                }
                break;
              }
            case true:
              {
                if (isReactedValue == false) {
                  await hitPageApi(pageId: pageId.id);
                  isReactedValue = null;
                  globallPageId = null;
                  await removeKey("pageLikeValue");
                }
                break;
              }
          }
        });
      }
    }
    notifyListeners();
  }

// Function to initialize the like count list
  likeCountList({isLike, userId, likesCount, pageId}) async {
    isReactedValue = null;
    globallPageId = null;
    await removeKey("pageLikeValue");
    likesData = [];
    likesData.add({
      "is_liked": isLike,
      "user_id": userId,
      "likes_count": likesCount,
      "page_id": pageId,
    });
    log("list length=>${likesData.length}");
    notifyListeners();
  }

// Function to update page like information based on the value (true or false)
  pageLikeProvider({@required index, @required value}) {
    switch (value) {
      case true:
        {
          // If value is true, set is_liked to true and increment the likes_count.
          likesData[0]["is_liked"] = true;
          likesData[0]["likes_count"] =
              (int.parse(likesData[0]["likes_count"]) + 1).toString();
          notifyListeners();
          break;
        }
      case false:
        {
          // If value is false, set is_liked to false and decrement the likes_count.
          likesData[0]["is_liked"] = false;
          likesData[0]["likes_count"] =
              (int.parse(likesData[0]["likes_count"]) - 1).toString();
          notifyListeners();
          break;
        }
    }
  }

// Function to make an API call to like a page
  hitPageApi({required pageId}) async {
    String url = "like-unlike-page";
    Map<String, dynamic> mapData = {"page_id": pageId};
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      log("response is $res");
    } else {
      log('Error: ${res['message']}');
    }
  }
}
