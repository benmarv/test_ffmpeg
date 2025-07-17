import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';

import 'package:link_on/viewModel/api_client.dart';

class FriendSuggestProvider extends ChangeNotifier {
  List<Usr> suggestionfriend = [];
  bool check = false;

  Future suggestUserList({userId}) async {
    Map<String, dynamic> mapData = {
      "type": "users",
      "limit": 40,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "fetch-recommended");
    log("follow response is $res");
    if (res["api_status"] == 200) {
      suggestionfriend = List.from(res["data"]).map<Usr>((e) {
        Usr usr = Usr.fromJson(e);
        return usr;
      }).toList();
      check = true;
      notifyListeners();
    } else {
      check = true;
      notifyListeners();
      toast('Error: ${res['errors']['error_text']}');
    }
  }

  reamovAtIndex({index}) {
    suggestionfriend.removeAt(index);
    notifyListeners();
  }
}
