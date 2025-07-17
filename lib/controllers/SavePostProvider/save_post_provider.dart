import 'package:flutter/material.dart';
import 'package:link_on/components/save_post/global_save_post_id.dart';
import 'package:link_on/models/posts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/viewModel/api_client.dart';

class SaveProvider extends ChangeNotifier {
  List<Posts> savepostlist = [];
  bool isdata = false;

  // Function to save post.
  Future<void> savePostList({required BuildContext context}) async {
    savepostlist = [];
    isdata = false;
    log("get saved posts api called");

    dynamic res = await apiClient.callApiCiSocialGetType(
        apiPath: 'post/saved', context: context);
    if (res["code"] == '200') {
      log("get saved posts api code is 200 ");

      var data = res['data'];
      savepostlist = List.from(data).map<Posts>((data) {
        return Posts.fromJson(data);
      }).toList();
      log("get saved posts api ${savepostlist.length} ");

      isdata = true;
      notifyListeners();
    } else {
      isdata = true;
      notifyListeners();
    }
  }
  // Function to delete save posts.

  Future<void> deleteSavePost({required Posts post, index, context}) async {
    customDialogueLoader(context: context);
    Map<String, dynamic> dataArray = {
      "post_id": post.id,
      "action": "save",
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'post/action', apiData: dataArray);
    if (res["code"] == '200') {
      PostProvider postsData =
          Provider.of<PostProvider>(context, listen: false);
      Navigator.pop(context);
      toast("Unsaved Post Successfull");

      // removePost(index: index,post: post);
      for (int i = 0; i < postsData.postListProvider.length; i++) {
        if (postsData.postListProvider[i].id == post.id) {
          postsData.changeSavePostValue(index: i, value: false);
          break;
        }
      }
      if (savePostMap.containsKey(post.id.toString()) == true) {
        savePostMap[post.id.toString()] = "unsave";
      }
      reamovAtIndex(index: index);
      notifyListeners();
    } else {
      Navigator.pop(context);
    }
  }

// Function to remove save post at index.
  reamovAtIndex({index}) {
    savepostlist.removeAt(index);
    notifyListeners();
  }
}
