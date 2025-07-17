// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:link_on/models/users_stories_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/new_user_model.dart';
import 'package:link_on/viewModel/api_client.dart';

class GetUserStoryProvider extends ChangeNotifier {
  Map<String, dynamic> userDataStoryMap = {};
  List<Map<String, dynamic>> otherDataStortList = [];
  List<Story> userStories = [];

  bool check = false;
  bool internet = false;
  // final controller = StoryController();

  // Get users' stories
  void getUsersStories({context}) async {
    await Future.delayed(const Duration(milliseconds: 100));

    // Clear existing data
    userDataStoryMap = {};
    otherDataStortList = [];
    userStories = [];

    // Make an API call to get user stories
    dynamic res = await apiClient.getUserstoriesApi();

    // Set to track added user IDs
    Set<String> addedUserIds = <String>{};
    if (res["code"] == "200") {
      var data = res["data"];
      // Loop through the returned stories
      for (int i = 0; i < data.length; i++) {
        // Get 1st story of every user
        Story stories = Story.fromJson(data[i]["stories"][0]);

        // Check if userId of 1st story of every user equal to logged in user
        if (stories.userId == getStringAsync("user_id")) {
          // User's stories
          userDataStoryMap = res['data'][0];
          userStories = List.from(data[0]["stories"]).map((e) {
            return Story.fromJson(e);
          }).toList();
        } else {
          // Check if the user's stories have already been added
          if (!addedUserIds.contains(stories.userId)) {
            Story stories = Story.fromJson(data[i]["stories"][0]);

            // Add the user's stories to the list
            otherDataStortList.add(data[i]);
            // Mark the user's ID as added

            addedUserIds.add(stories.userId!);
          }
        }
      }
      notifyListeners();
    } else {
      print('Error: getuserstoriesapi ${res['message']}');
    }
  }

  // delete story
  void deleteStory(
      {required storyId,
      required userId,
      required index,
      required BuildContext context}) async {
    print('delete story : $storyId');
    // Make an API call to delete story
    dynamic res = await apiClient.deleteStoryApi(storyId: storyId);

    if (res["code"] == "200") {
      userDataStoryMap.remove(index);
      getUsersStories(context: context);

      Navigator.pop(context);
      toast(res['message']);

      notifyListeners();
    } else {
      if (res != null) {
        print('Error: delete story api ${res['message']}');
      }
    }
  }

  Stories? getStories;
  String? userId;
  dynamic storyIdd;
  bool loading = false;

// increase stories seen
  Future<void> increaseStorySeen({required storyId}) async {
    // for (int i = 0; i < storiesList!.length; i++) {
    Map<String, dynamic> mapData = {
      "story_id": storyId,
    };

    // Make an API call to get the story by its ID
    await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "story/seen-story");
  }

// Clear the story items and views list
  void makeEmptyStoryitem() {
    // storyItems = [];
    viewsList = [];
    notifyListeners();
  }

// Function to retrieve story views
  List<NewUserModel> viewsList = [];
  Future getStoriesViesCount({required storyId, afterPostId}) async {
    // API endpoint for getting story views
    String? url = "story/story-seen-user";

    // Set loading to true and disable internet check
    loading = true;
    checkInternet(value: false);

    // Prepare API request data
    Map<String, dynamic> mapData = {
      "story_id": storyId,
      "limit": 10,
    };

    // Include offset if provided
    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    }

    // Make an API call to retrieve story views
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: url);

    // Check the API response
    if (res["code"] == '200') {
      // Process and add story views to the views list
      List<NewUserModel> templist = [];
      templist = List.from(res["data"]).map<NewUserModel>((e) {
        NewUserModel usr = NewUserModel.fromJson(e);
        return usr;
      }).toList();

      for (int i = 0; i < templist.length; i++) {
        viewsList.add(templist[i]);
      }

      // Set loading to false and notify listeners
      loading = false;
      notifyListeners();
    } else if (res == true) {
      // Enable internet check
      checkInternet(value: true);
    } else {
      // Set loading to false, notify listeners, and display an error message
      loading = false;
      notifyListeners();
      print("Error: ${res['message']}");
    }
  }

// Clear the views list
  void makeViewsEmpty() {
    viewsList = [];
    notifyListeners();
  }

// Check for internet connectivity and display a toast message if no internet
  void checkInternet({required bool value}) {
    internet = value;
    if (value == true) {
      toast("No Internet");
    }
    notifyListeners();
  }
}
