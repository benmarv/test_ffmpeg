import 'package:flutter/material.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class ReactionListController extends ChangeNotifier {
  List<Usr> reactionlist1 = [];
  List<Usr> reactionlist2 = [];
  List<Usr> reactionlist3 = [];
  List<Usr> reactionlist4 = [];
  List<Usr> reactionlist5 = [];
  List<Usr> reactionlist6 = [];

  bool isdata = false;

  void clearList() {
    reactionlist1.clear();
    reactionlist2.clear();
    reactionlist3.clear();
    reactionlist4.clear();
    reactionlist5.clear();
    reactionlist6.clear();
    notifyListeners();
  }

  Future<void> fetchReactionList(String postId) async {
    isdata = false;
    Map<String, dynamic> dataArray = {
      "post_id": postId,
    };

    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'post/get-post-reaction', apiData: dataArray);

    if (res["code"] == "200") {
      var data = res['data'];
      _updateReactionLists(data);
      isdata = true;
    } else {
      isdata = true;
      toast('Error: ${res['message']}');
    }

    notifyListeners();
  }

  void _updateReactionLists(Map<String, dynamic> data) {
    reactionlist1 = _mapToUsrList(data["1"]);
    reactionlist2 = _mapToUsrList(data["2"]);
    reactionlist3 = _mapToUsrList(data["3"]);
    reactionlist4 = _mapToUsrList(data["4"]);
    reactionlist5 = _mapToUsrList(data["5"]);
    reactionlist6 = _mapToUsrList(data["6"]);
  }

  List<Usr> _mapToUsrList(dynamic data) {
    return List.from(data).map<Usr>((item) => Usr.fromJson(item)).toList();
  }
}
