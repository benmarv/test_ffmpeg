import 'package:flutter/material.dart';
import 'package:link_on/models/games.dart';
import 'package:link_on/viewModel/api_client.dart';

class GamesProvider extends ChangeNotifier {
  List<Games> data = [];
  bool checkData = false;

  Future getGames() async {
    checkData = false;
    String url = "get-games";
    Map<String, dynamic> mapData = {
      "limit": 7,
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      data = List.from(res["data"]).map((item) {
        Games data = Games.fromJson(item);
        return data;
      }).toList();
      checkData = true;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();
    }
  }
}
