import 'package:link_on/models/get_freinds_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/Follower/following_provider.dart';
import 'package:link_on/viewModel/api_client.dart';

class Follower extends FollowingProvider {
  List<Usr> follower = [];
  bool check2 = false;
  bool nofollower = false;
  bool hitfollowerApi = false;
  // Retrieve followers and store them in the 'follower' list
  Future getFollower({context, userId, afterPostId}) async {
    GetFreindsModel friendsModelVariable;
    String url = "get-friends";
    Map<String, dynamic> mapData = {
      "type": "followers",
      "user_id": userId ?? getStringAsync("user_id"),
      "limit": 30,
    };
    check2 = false;
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: url);
    if (res["api_status"] == 200) {
      friendsModelVariable = GetFreindsModel.fromJson(res["data"]);
      for (int i = 0; i < friendsModelVariable.followers!.length; i++) {
        follower.add(friendsModelVariable.followers![i]);
      }
      check2 = true;
      hitFollowerApi(false);
      notifyListeners();
    } else {}
  }

// Make the 'follower' list empty
  makeFollowerEmpty() {
    check2 = false;
    follower = [];
    notifyListeners();
  }

// Set the 'hitfollowerApi' flag to control whether to make follower API requests
  hitFollowerApi(bool value) {
    hitfollowerApi = value;
    notifyListeners();
  }

// Check if no more followers are found
  checkNoFollower(bool value) {
    nofollower = value;
    if (value == true) {
      toast("no following to show");
      nofollower = false;
    }
    notifyListeners();
  }

// Remove a follower from the list based on the provided user index
  removeFollower({index, user}) {
    for (int i = 0; i < follower.length; i++) {
      if (follower[i].id == user.userId) {
        follower.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }
}
