import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendsFollowingProvider extends ChangeNotifier {
  List<UserModelFriendandFollow> following = [];
  List<bool> checkList = [];
  bool checkFollowing = false;
  bool nofollowing = false;
  bool hitfollowingApi = false;
  bool isLoading = false;

  // Retrieve following users and store them in the 'following' list
  Future friendGetFollowing({userId, afterPostId, context}) async {
    isLoading = true;
    Map<String, dynamic> mapData = {
      'limit': 10,
      "user_id": userId ?? getStringAsync("user_id"),
    };
    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    }

    checkFollowing = false;
    hitFriendFollowingApi(true);

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: 'get-friends');
    if (res["code"] == '200') {
      following = List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        UserModelFriendandFollow usr = UserModelFriendandFollow.fromJson(e);
        return usr;
      }).toList();

      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
    isLoading = false;
    notifyListeners();
  }

// Make the 'following' list and 'checkList' empty
  makeFriendFollowingEmpty() {
    following = [];
    checkList = [];
    notifyListeners();
  }

// Set the 'hitfollowingApi' flag to control whether to make following API requests
  hitFriendFollowingApi(bool value) {
    hitfollowingApi = value;
    notifyListeners();
  }

// Check if no more following users are found
  checkNoFriendFollowing(bool value) {
    nofollowing = value;
    if (value == true) {
      toast("no following to show");
      nofollowing = false;
    }
    notifyListeners();
  }

  // Remove a user from the 'following' list
  removeFriendFollowing({index, user}) {
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
    following =
        List.from(jsonDecode(textFile!)).map<UserModelFriendandFollow>((e) {
      UserModelFriendandFollow groupChatModel =
          UserModelFriendandFollow.fromJson(e);
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
