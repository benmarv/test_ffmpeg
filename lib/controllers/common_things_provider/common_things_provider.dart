import 'package:flutter/material.dart';
import 'package:link_on/models/CommonThingsModel/common_things_model.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonThingsProvider extends ChangeNotifier {
  CommonThingsModel? commonThingsModel;
  bool? isCommonThingDataLoading = false;
  List<User> commonUsers = [];
  bool? isCommonUserLoading = false;
  List<int>? numberOfCommontThings;
  Future<void> fetchCommonThings(String? userId) async {
    Map<String, dynamic> mapData = {"user_id": userId};
    isCommonThingDataLoading = true;
    try {
      dynamic res = await apiClient.callApiCiSocial(
          apiData: mapData, apiPath: "get-commons");
      if (res["code"] == 200) {
        commonThingsModel = CommonThingsModel.fromJson(res['data']);
        log("Respnnnn is  : ${commonThingsModel}");
        isCommonThingDataLoading = false;
      } else if (res["code"] == "400") {
        toast(res['message'].toString(),
            bgColor: const Color.fromARGB(255, 211, 208, 207),
            textColor: Colors.white);
      } else {
        log("Error Found!");
      }
    } catch (e) {
      log(e);
    }
    isCommonThingDataLoading = false;
    notifyListeners();
  }

  Future<void> fetchCommonUsers({int? offset, String? userId}) async {
    Map<String, dynamic> mapData = {"user_id": userId, 'limit': 10};
    List<User> tempList = [];
    if (offset != null) {
      mapData['offset'] = offset;
    }

    isCommonUserLoading = true;
    try {
      dynamic res = await apiClient.callApiCiSocial(
          apiData: mapData, apiPath: "get-common-users");

      if (res["code"] == 200) {
        tempList =
            (res['data'] as List).map((user) => User.fromJson(user)).toList();
        if (tempList.isNotEmpty) {
          commonUsers.addAll(tempList);
        }
      } else if (res["code"] == "400") {
        toast(res['message'].toString(),
            bgColor: const Color.fromARGB(255, 211, 208, 207),
            textColor: Colors.white);
      } else {
        log("Error Found!");
      }
    } catch (e) {
      log(e);
    } finally {
      isCommonUserLoading = false;
    }
    notifyListeners();
  }
  // Future<List<int>?> getNumberOfCommonThings(String? userId) async {
  //   Map<String, dynamic> mapData = {"user_id": userId};
  //   try {
  //     dynamic res = await apiClient.callApiCiSocial(
  //         apiData: mapData, apiPath: "get-commons");
  //     if (res["code"] == 200) {
  //       // Parse and count the number of common things
  //       List<int> count = (res['data']['pages'] as List)
  //           .map((page) =>
  //               page.toString().length) // Replace with actual logic if needed
  //           .toList();
  //       numberOfCommontThings = count;
  //       log("Number of Common Things: $count");
  //     } else if (res["code"] == "400") {
  //       toast(res['message'].toString(),
  //           bgColor: const Color.fromARGB(255, 211, 208, 207),
  //           textColor: Colors.white);
  //     } else {
  //       log("Error Found!");
  //     }
  //   } catch (e) {
  //     log("Exception: $e");
  //   }
  //   notifyListeners();
  //   return numberOfCommontThings;
  // }
}
