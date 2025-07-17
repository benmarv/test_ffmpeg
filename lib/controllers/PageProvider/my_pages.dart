import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/viewModel/api_client.dart';

class MyPagesProvider extends ChangeNotifier {
  // List to store GetLikePage objects
  List<GetLikePage> myPageList = [];
  bool search = false;

// Function to fetch and populate the user's pages
  Future myPages() async {
    myPageList = [];
    search = false;
    String url = "get-my-pages";
    Map<String, dynamic> mapData = {
      'type': "my_pages",
    };
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["api_status"] == 200) {
      // Parse and map the response data to GetLikePage objects
      myPageList = List.from(res["data"]).map<GetLikePage>((e) {
        GetLikePage getLikePage = GetLikePage.fromJson(e);
        return getLikePage;
      }).toList();
      log("My pages Data ${myPageList.length}");
      search = true;
      notifyListeners();
    } else {
      // Handle API error
    }
  }

// Getter to access the myPageList
  List<GetLikePage> get getMyPageList => myPageList;
}
