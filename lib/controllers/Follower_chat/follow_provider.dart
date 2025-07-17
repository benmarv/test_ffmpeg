import 'package:flutter/cupertino.dart';
import 'package:link_on/models/get_freinds_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';


class FollowProvider extends ChangeNotifier {
  List<Usr> follower = [];
  List<Usr> following = [];
  bool check = false;
  Future followProvider({userId}) async {
    GetFreindsModel friendsModelVariable;
    follower = [];
    following = [];
    check = false;
    String url = "get-friends";
    Map<String, dynamic> mapData = {
      "type": "followers,following",
      "user_id": userId ?? getStringAsync("user_id"),
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: url);
    log("follow response is $res");
    if (res["api_status"] == 200) {
      friendsModelVariable = GetFreindsModel.fromJson(res["data"]);
      for (int i = 0; i < friendsModelVariable.followers!.length; i++) {
        follower.add(friendsModelVariable.followers![i]);
      }
      for (int i = 0; i < friendsModelVariable.following!.length; i++) {
        following.add(friendsModelVariable.following![i]);
      }
      check = true;

      notifyListeners();
    } else {
      check = true;
      notifyListeners();
      toast('Error: ${res['errors']['error_text']}');
    }
  }

  removeFollower({index, user}) {
    for (int i = 0; i < follower.length; i++) {
      if (follower[i].id == user.userId) {
        follower.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }

  addFollower({user}) {
    follower.add(user);
    notifyListeners();
  }

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

  addFollowing({Usr? user}) {
    user?.isFriend = '1';
    following.add(user!);
    notifyListeners();
  }
}
