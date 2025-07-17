import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';

class FollowRequestProvider extends ChangeNotifier {
  List<Usr> followRequestList = [];
  bool? checkData = false;
  Future followRequest() async {
    followRequestList = [];
    checkData = false;
    String url = 'get-general-data';
    Map<String, dynamic> mapData = {"fetch": "friend_requests"};
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["api_status"] == 200) {
      followRequestList = List.from(res["friend_requests"]).map<Usr>((e) {
        Usr usr = Usr.fromJson(e);
        return usr;
      }).toList();
      checkData = true;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();
      toast('Error: ${res['errors']['error_text']}');
    }
  }

  reamovAtIndex({index}) {
    followRequestList.removeAt(index);
    notifyListeners();
  }
}
