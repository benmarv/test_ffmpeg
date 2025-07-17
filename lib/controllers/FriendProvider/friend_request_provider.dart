import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendFollowRequestProvider extends ChangeNotifier {
  List<UserModelFriendandFollow> followRequestList = [];
  bool? checkData = false;
  bool noPostAtBottom = false;
  bool hitApi = false;

  Future friendFollowRequest({afterPostId, offset}) async {
    String url = 'friend-requests';
    Map<String, dynamic> mapData = {
      "limit": 15,
    };

    if (offset != null) {
      mapData['offset'] = offset;
    }

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log(res);
    if (res["code"] == '200') {
      List<UserModelFriendandFollow> tempList =
          List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        UserModelFriendandFollow usr = UserModelFriendandFollow.fromJson(e);
        return usr;
      }).toList();

      followRequestList.addAll(tempList);

      checkData = true;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();
      toast('Error: ${res['message']}');
    }
  }

  List<UserModelFriendandFollow> yourFollowRequestList = [];
  // Retrieve Your friend requests and store them in the yourFollowRequestList
  Future<List<UserModelFriendandFollow>?> friendYourFollowRequest(
      {afterPostId, offset}) async {
    String url = 'get-sent-requests';
    Map<String, dynamic> mapData = {
      "limit": 15,
    };

    if (offset != null) {
      mapData['offset'] = offset;
    }

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log(res);
    if (res["code"] == '200') {
      if (res['data'] == null || res['data'] == '') {
        yourFollowRequestList.clear();
        notifyListeners();
      }
      yourFollowRequestList =
          List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        UserModelFriendandFollow usr = UserModelFriendandFollow.fromJson(e);
        return usr;
      }).toList();

      checkData = true;
      notifyListeners();
      return yourFollowRequestList;
    } else {
      checkData = true;
      notifyListeners();
      toast('Error: ${res['message']}');
    }
    return null;
  }

// Set the hitApi value to control whether to make follow request API requests
  hitFriendFollowRequestApi(bool value) {
    hitApi = value;
    notifyListeners();
  }

// Check if no more friend requests are found
  checkNoFriendPostFound(bool value) {
    noPostAtBottom = value;
    if (value == true) {
      toast("no more requests to show");
      noPostAtBottom = false;
    }
    notifyListeners();
  }

// Remove a friend request from the list at the specified index
  reamovFriendAtIndex({index}) {
    followRequestList.removeAt(index);
    notifyListeners();
  }

  // Remove a friend request from the list at the specified index
  reamovYourSentFriendAtIndex({index}) {
    yourFollowRequestList.removeAt(index);
    notifyListeners();
  }

// Make the followRequestList empty
  makeFriendRequestEmpty() {
    followRequestList = [];
    notifyListeners();
  }

  // Make the yourFollowRequestList empty
  makeUserSentFriendRequestEmpty() {
    yourFollowRequestList = [];
    notifyListeners();
  }
}
