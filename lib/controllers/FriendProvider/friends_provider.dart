import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/FriendProvider/friend_followe_provider.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendFollower extends FriendsFollowingProvider {
  List<UserModelFriendandFollow> follower = [];
  bool check2 = false;
  bool nofollower = false;
  bool hitfollowerApi = false;
  Future friendGetFollower({context, userId, afterPostId, offset}) async {
    String url = "get-friends";
    Map<String, dynamic> mapData = {
      "user_id": userId ?? getStringAsync("user_id"),
      "limit": 15,
    };
    if (offset != null) {
      mapData['offset'] = offset;
    }
    check2 = false;
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: url);

    if (res["code"] == '200') {
      List<UserModelFriendandFollow> tempList =
          List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        UserModelFriendandFollow usr = UserModelFriendandFollow.fromJson(e);
        return usr;
      }).toList();
      follower.addAll(tempList);
      check2 = true;
      hitFriendFollowerApi(false);
      notifyListeners();
    } else {
      check2 = true;
      notifyListeners();
      toast('Error: ${res['message']}');
    }
    check2 = true;
    notifyListeners();
  }

// Make the 'follower' list empty
  makeFriendFollowerEmpty() {
    check2 = false;
    follower = [];
    notifyListeners();
  }

// Set the 'hitfollowerApi' flag to control whether to make follower API requests
  hitFriendFollowerApi(bool value) {
    hitfollowerApi = value;
    notifyListeners();
  }

// Check if no more followers are found
  checkNoFriendFollower(bool value) {
    nofollower = value;
    if (value == true) {
      toast("no following to show");
      nofollower = false;
    }
    notifyListeners();
  }

// Remove a follower from the list based on the provided user index
  removeFriendFollower({index, user}) {
    for (int i = 0; i < follower.length; i++) {
      if (follower[i].id == user.id) {
        follower.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }
}
