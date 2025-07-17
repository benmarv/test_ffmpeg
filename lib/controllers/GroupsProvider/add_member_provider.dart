import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/viewModel/api_client.dart';

class AddMemberGroup extends ChangeNotifier {
  bool? checkData = false;
  bool hitApi = false;
  // Add a member to a group
  Future addMember({groupid, userid, context}) async {
    customDialogueLoader(context: context);
    String url = 'add-group-member';
    Map<String, dynamic> mapData = {
      "group_id": groupid,
      "user_id": userid,
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    // Check if the member was added successfully
    if (res["code"] == '200') {
      checkData = true;
      Navigator.pop(context);
      toast(res['message']);
      notifyListeners();
    } else {
      checkData = true;
      Navigator.pop(context);

      // Display a message indicating that the member was already added

      notifyListeners();
    }
  }
}
