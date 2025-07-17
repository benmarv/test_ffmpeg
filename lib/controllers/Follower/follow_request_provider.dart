import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';

class FollowRequestProvider extends ChangeNotifier {
  List<Usr> followRequestList = [];
  bool? checkData = false;
  bool noPostAtBottom = false;
  bool hitApi = false;
// Retrieve friend requests and store them in the followRequestList
  Future followRequest({afterPostId}) async {
    String url = 'get-general-data';
    Map<String, dynamic> mapData = {
      "fetch": "friend_requests",
      "limit": 30,
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log(res);
    if (res["api_status"] == 200) {
      followRequestList = List.from(res["friend_requests"]).map<Usr>((e) {
        Usr usr = Usr.fromJson(e);
        return usr;
      }).toList();
      checkData = true;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();
    }
  }

// Set the hitApi value to control whether to make follow request API requests
  hitFollowRequestApi(bool value) {
    hitApi = value;
    notifyListeners();
  }

// Check if no more friend requests are found
  checkNoPostFound(bool value) {
    noPostAtBottom = value;
    if (value == true) {
      toast("no more requests to show");
      noPostAtBottom = false;
    }
    notifyListeners();
  }

// Remove a friend request from the list at the specified index
  reamovAtIndex({index}) {
    followRequestList.removeAt(index);
    notifyListeners();
  }

// Make the followRequestList empty
  makeRequestEmpty() {
    followRequestList = [];
    notifyListeners();
  }
}
