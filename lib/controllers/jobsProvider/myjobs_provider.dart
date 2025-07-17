import 'package:flutter/material.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';


class MyJobList extends ChangeNotifier {
  bool loading = false;
  String pageid = "";
  List<MyJobModel> myjoblist = [];
  List<MyJobModel> alljoblist = [];

// Search for jobs based on various parameters
  Future<void> searchjob({
    String? afterPostId,
    String? keyword,
    String? jobType,
    currentJobTab,
  }) async {
    loading = true;

    Map<String, dynamic> mapData = {
      "limit": 6,
    };

    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    }
    if (currentJobTab == "myjobs") {
      mapData['type'] = 'my';
    } else if (currentJobTab == "alljobs") {
      mapData['type'] = 'all';
    }
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: 'get-jobs', apiData: mapData);
    if (res["code"] == '200') {
      if (currentJobTab == "myjobs") {
        List<MyJobModel> tempmyjoblist;
        var data = res['data'];
        tempmyjoblist = List.from(data).map<MyJobModel>((data) {
          return MyJobModel.fromJson(data);
        }).toList();
        myjoblist.addAll(tempmyjoblist);
        if (myjoblist.isNotEmpty && tempmyjoblist.isEmpty) {
          toast('No more data to show');
        }
        loading = false;
      } else {
        var data = res['data'];
        List<MyJobModel> tempalljoblist;
        tempalljoblist = List.from(data).map<MyJobModel>((data) {
          return MyJobModel.fromJson(data);
        }).toList();
        alljoblist.addAll(tempalljoblist);
        if (alljoblist.isNotEmpty && tempalljoblist.isEmpty) {
          toast('No more data to show');
        }
        loading = false;
      }
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
    notifyListeners();
  } // Clear the list of job data and notify listeners

  void makeListEmpty() {
    myjoblist.clear();
    notifyListeners();
  }

  void makeMyJobsListEmpty() {
    myjoblist.clear();
    notifyListeners();
  }

  void makeAllJobsListEmpty() {
    alljoblist.clear();
    notifyListeners();
  }
}
