import 'package:flutter/cupertino.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';

class UpdatePageDataProvider extends ChangeNotifier {
  // Function to update page data via an API call
  Future updatePageData({url, mapData}) async {
    dynamic res =
        await apiClient.callApiCiSocial(apiData: url, apiPath: mapData);
    if (res["api_status"] == 200) {
      // Display a success message
      toast("${res['message']}");
    } else {
      // Handle and display an error message
    }
  }

  bool isLoading = false;
  List<GetLikePage> discoverPages = [];
  Future getAllPages() async {
    isLoading = true;
    dynamic res = await apiClient.discoverPagelist(offset: 0);
    if (res['code'] == '200') {
      List<GetLikePage> tempList = [];
      tempList = List.from(res['data']).map<GetLikePage>((e) {
        GetLikePage list = GetLikePage.fromJson(e);
        return list;
      }).toList();
      discoverPages = tempList;
      isLoading = false;
    } else {
      isLoading = false;
    }
    notifyListeners();
  }

  void makeDiscoverPagesEmpty() {
    discoverPages.clear();
    notifyListeners();
  }
}
