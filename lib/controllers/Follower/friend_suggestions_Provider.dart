import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendSuggestProvider extends ChangeNotifier {
  List<Usr> suggestionfriend = [];
  bool check = false;
  bool noPostAtBottom = false;
  bool hitApi = false;
  // Fetch a list of suggested users
  Future suggestUserList({userId, mapData}) async {
      List<Usr> tempList = [];
      dynamic res = await apiClient.callApiCiSocial(
          apiData: mapData, apiPath: "fetch-recommended");

      if (res["api_status"] == 200) {
        tempList = List.from(res["data"]).map<Usr>((e) {
          Usr usr = Usr.fromJson(e);
          return usr;
        }).toList();

        check = true;
        for (int i = 0; i < tempList.length; i++) {
          suggestionfriend.add(tempList[i]);
        }
        notifyListeners();
      } else {
        check = true;
        notifyListeners();
      }
  
  }

// Update 'noPostAtBottom' to control whether more suggestions are available
  checkNoPostFound(bool value) {
    noPostAtBottom = value;
    if (value == true) {
      toast("no more suggestions to show");
      noPostAtBottom = false;
    }
    notifyListeners();
  }

// Remove a user from the list of suggested friends at a given index
  reamovAtIndex({index}) {
    suggestionfriend.removeAt(index);
    notifyListeners();
  }

// Clear the list of suggested friends
  makeSuggestedEmtyList() {
    check = false;
    suggestionfriend = [];
    notifyListeners();
  }
}
