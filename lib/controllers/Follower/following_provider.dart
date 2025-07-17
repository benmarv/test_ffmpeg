import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:link_on/models/get_freinds_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';


class FollowingProvider extends ChangeNotifier {
  List<Usr> following = [];
  List<bool> checkList = [];
  bool checkFollowing = false;
  bool nofollowing = false;
  bool hitfollowingApi = false;
  // Retrieve following users and store them in the 'following' list
  Future getFollowing({userId, afterPostId, context}) async {
    Map<String, dynamic> mapData = {
      "type": "following",
      "user_id": userId ?? getStringAsync("user_id"),
    };
    if (afterPostId != null) {
      mapData["after_post_id"] = afterPostId;
    }
    GetFreindsModel friendsModelVariable;
    String url = "get-friends";
    checkFollowing = false;
    hitFollowingApi(true);
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: url);
    if (res["api_status"] == 200) {
      friendsModelVariable = GetFreindsModel.fromJson(res["data"]);
      for (int i = 0; i < friendsModelVariable.following!.length; i++) {
        following.add(friendsModelVariable.following![i]);
        checkList.add(false);
      }
      checkFollowing = true;
      hitFollowingApi(false);
      if (res["data"]["following"].isEmpty) {
        checkNoFollowing(true);
      }
      notifyListeners();
    } else {}
  }

// Make the 'following' list and 'checkList' empty
  makeFollowingEmpty() {
    following = [];
    checkList = [];
    notifyListeners();
  }

// Set the 'hitfollowingApi' flag to control whether to make following API requests
  hitFollowingApi(bool value) {
    hitfollowingApi = value;
    notifyListeners();
  }

// Check if no more following users are found
  checkNoFollowing(bool value) {
    nofollowing = value;
    if (value == true) {
      toast("no following to show");
      nofollowing = false;
    }
    notifyListeners();
  }

  // Remove a user from the 'following' list
  removeFollowing({index, user}) {
    int indexValue = 0;

    for (int i = 0; i < following.length; i++) {
      if (following[i].id == user.userId) {
        following.removeAt(indexValue);
        indexValue++;
        notifyListeners();
        break;
      }
    }
  }

// Retrieve and store a list of users from a text file
  storageGroupList({@required String? textFile}) async {
    following = [];
    checkFollowing = false;
    following = List.from(jsonDecode(textFile!)).map<Usr>((e) {
      Usr groupChatModel = Usr.fromJson(e);
      return groupChatModel;
    }).toList();
    checkFollowing = true;
    notifyListeners();
  }

// Update the value of the checkbox for a user at a specific index
  checkBoxValue(value, index) {
    checkList[index] = value;
    notifyListeners();
  }
}
