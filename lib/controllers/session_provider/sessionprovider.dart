import 'package:flutter/material.dart';
import 'package:link_on/models/seesion_model/get_session_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';

class SessionProvider extends ChangeNotifier {
  List<Session> sessionList = [];
  bool isdata = false;
// Function to manage and save user session in app.
  Future<void> sessionlist({required BuildContext context}) async {
    isdata = false;
    log("session list api called");

    dynamic res = await apiClient.callApiCiSocialGetType(
        apiPath: 'get-sessions', context: context);
    if (res["code"] == '200') {
      var data = res['data'];
      sessionList = List.from(data).map<Session>((data) {
        return Session.fromJson(data);
      }).toList();
      log("session list api called ${sessionList[0].deviceModel}");
      isdata = true;
      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
  }

// Function to user session in app.
  Future<void> deleteSession(id) async {
    Map<String, dynamic> dataArray = {
      "session_id": id,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'delete-session', apiData: dataArray);
    if (res["code"] == '200') {
      toast(res['message']);
      notifyListeners();
    } else {
      log('Error: ${res['message']}');
    }
  }

// Function to make session list empty.
  makeListEmpty() {
    sessionList = [];
    notifyListeners();
  }

// Function to remove user session.
  removeSession(index) {
    sessionList.removeAt(index);
    notifyListeners();
  }
}
