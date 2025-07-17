import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendFriendSuggestProvider extends ChangeNotifier {
  List<UserModelFriendandFollow> suggestionfriend = [];
  bool check = false;
  bool noPostAtBottom = false;
  bool hitApi = false;
  bool isLoading = false;

  // Fetch a list of suggested users
  Future friendSuggestUserList({userId, mapData, offset}) async {
    isLoading = true;
    if (offset != null) {
      mapData['offset'] = offset;
    }

    List<UserModelFriendandFollow> tempList = [];

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "fetch-recommended");
    log("suggested friends : ${res["data"]}");
    if (res["code"] == '200') {
      tempList = List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        UserModelFriendandFollow usr = UserModelFriendandFollow.fromJson(e);
        return usr;
      }).toList();

      check = true;
      if (tempList.isEmpty) {
        toast('No more suggestions to show');
      }
      for (int i = 0; i < tempList.length; i++) {
        suggestionfriend.add(tempList[i]);
      }
      isLoading = false;
      notifyListeners();
    } else {
      check = true;
      isLoading = false;
      notifyListeners();
    }
  }

// Update 'noPostAtBottom' to control whether more suggestions are available
  checkNoFriendPostFound(bool value) {
    noPostAtBottom = value;
    if (value == true) {
      toast("no more suggestions to show");
      noPostAtBottom = false;
    }
    notifyListeners();
  }

// Remove a user from the list of suggested friends at a given index
  reamovFriendAtIndex({index}) {
    suggestionfriend.removeAt(index);
    notifyListeners();
  }

// Clear the list of suggested friends
  makeFriendSuggestedEmtyList() {
    check = false;
    suggestionfriend = [];
    notifyListeners();
  }
}
