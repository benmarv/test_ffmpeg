import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:link_on/models/movies.dart';
import 'package:link_on/viewModel/api_client.dart';

class MoviesProvider extends ChangeNotifier {
  List<Movies> moviesdata = [];
  bool checkData = false;
  int currentIndex = 0;
  int onBoardingCurrentIndex = 0;

  Future getMovies() async {
    checkData = false;
    String url = "all-movies";
    Map<String, dynamic> mapData = {'limit': 7};
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res["code"] == '200') {
      moviesdata = List.from(res["data"]).map((item) {
        Movies data = Movies.fromJson(item);
        return data;
      }).toList();
      checkData = true;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();

      log("${res['message']}");
    }
  }

  changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeOnBoardingIndex(int index) {
    onBoardingCurrentIndex = index;
    notifyListeners();
  }
}
