import 'package:flutter/material.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class BlockUserProvider extends ChangeNotifier {
  List<Usr> blockeduser = [];
  bool check = false;

// get all blocked users
  Future getBlockUsers({userId, required BuildContext context}) async {
    dynamic res = await apiClient.callApiCiSocialGetType(
        apiPath: "block-list", context: context);

    if (res["code"] == 200) {
      var data = res["data"];
      blockeduser = List.from(data).map<Usr>((e) {
        Usr usr = Usr.fromJson(e);
        return usr;
      }).toList();
      check = true;
      notifyListeners();
    } else {
      check = true;
      notifyListeners();
    }
  }

// block a user
  Future<void> blockUser({userid, index, context}) async {
    Map<String, dynamic> dataArray = {
      "user_id": userid,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'block-user', apiData: dataArray);

    if (res["code"] == 200) {
      toast(res['message']);
      removeBlockedUser(index: index);
    } else {
      Navigator.pop(context);
    }
  }

  removeBlockedUser({required int index}) {
    blockeduser.removeAt(index);
    notifyListeners();
  }
}
