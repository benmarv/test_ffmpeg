import 'package:flutter/material.dart';
import 'package:link_on/models/blogs_model.dart';
import 'package:link_on/viewModel/api_client.dart';

class BlogsProvider extends ChangeNotifier {
  List<BlogsModel> data = [];
  bool checkData = false;

  int currentIndex = 0;

  Future getBlogs({required BuildContext context}) async {
    checkData = true;
    String url = "all-blogs";

    dynamic res =
        await apiClient.callApiCiSocialGetType(apiPath: url, context: context);

    if (res["code"] == 200) {
      data = List.from(res["data"]).map((item) {
        BlogsModel data = BlogsModel.fromJson(item);

        return data;
      }).toList();
      checkData = false;
      notifyListeners();
    } else {
      checkData = false;
      notifyListeners();
    }
  }

  changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
