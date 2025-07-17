import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/viewModel/api_client.dart';

class UserJoinedGroups extends ChangeNotifier {
  // List to store joined group data
  List<JoinGroupModel> joinedGroupList = [];

// Flag to indicate if search is in progress
  bool search = false;

// Fetch joined groups data
  Future joinedGroupsProvider() async {
    joinedGroupList = [];
    search = false;

    Map<String, dynamic> mapData = {
      // "offset": afterPostId,
      'limit': 10
    };

    String endPoint = 'joined-groups';
    // Make an API call to fetch user's joined groups
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: endPoint);

    if (res['code'] == '200') {
      // Parse the response data and add it to the list of joinGroups
      List<JoinGroupModel> tempList = List.from(res['data'])
          .map<JoinGroupModel>((e) => JoinGroupModel.fromJson(e))
          .toList();

      joinedGroupList.addAll(tempList);
      search = true;

      notifyListeners();
    } else if (res['code'] == '400') {
      if (res['message'] == 'No data found') {
        toast('No more data to show');
      } else {
        toast(res['message']);
      }
      notifyListeners();
    } else {
      // Finish loading data and display an error message

      notifyListeners();
    }
  }

// Get the list of joined groups
  List<JoinGroupModel> get getJoinGroupData => joinedGroupList;
}
