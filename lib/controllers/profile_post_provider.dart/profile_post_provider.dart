import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/utils/reaction.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'userdata_notifier.dart';

class ProfilePostsProvider extends ChangeNotifier {
  bool loading = false; // Indicates whether loading is in progress
  String _userId = ""; // Stores the user's ID

  Usr? userInfo;

  void changeEventStatus(int index, {bool? isGoing, bool? isIntrested}) {
    if (isGoing == true) {
      // Update the "isGoing" status for the event of the post at the specified index.
      getProfilePostProviderList[index].event?.isGoing = isGoing;
    } else {
      // Update the "isInterested" status for the event of the post at the specified index.
      getProfilePostProviderList[index].event?.isInterested = isIntrested;
    }

    // Notify listeners to reflect the changes in the UI.
    notifyListeners();
  }

  Future<Map<String, dynamic>> getTheUserData({userId}) async {
    userInfo = null;
    try {
      var userid = userId ?? getStringAsync("user_id");

      var accessToken = getStringAsync("access_token");

      Response response = await dioService.dio.get('get-user-profile',
          options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
          queryParameters: {'user_id': userid});
      userInfo = Usr.fromJson(response.data['data']);
      notifyListeners();
      return response.data;
    } on SocketException {
      notifyListeners();

      return {"internet": true};
    } on DioException catch (e) {
      notifyListeners();

      log('get access token get user data response error $e');
      return e.response!.data;
    }
  }

// This function retrieves posts based on the post_type from the mapData.
  void getUsersPosts(
      {required Map<String, dynamic>? mapData, required BuildContext context}) {
    switch (mapData?["post_type"]) {
      case "1":
        {
          _getProfilePostImages(
              mapData: mapData,
              context: context); // Retrieve profile post images
          break;
        }
      case "2":
        {
          _getProfilePostVideos(
              mapData: mapData,
              context: context); // Retrieve profile post videos
          break;
        }
      default:
        {
          _getPrfofilePost(
              mapData: mapData,
              context: context); // Retrieve profile posts of other types
          break;
        }
    }
  }

// Lists to store user's profile posts and other user's profile posts.
  final List<Posts> profileList = []; // Stores the user's profile posts
  final List<Posts> otherUserProfile = []; // Stores other user's profile posts

// Getter to provide the appropriate list of profile posts based on the user's ID.
  List<Posts> get getProfilePostProviderList =>
      getUserData.value.id == _userId ? profileList : otherUserProfile;

  Future _getPrfofilePost({Map<String, dynamic>? mapData, context}) async {
    // Set the user's ID based on the mapData
    setUserId(mapData?['user_id']);

    // Set loading state to true
    loadingValue(true);

    List<Posts> tempList = [];
    // Call an API to retrieve posts
    // dynamic res = await apiClient.callApi(apiData: mapData, apiPath: "posts");
    var accessToken = getStringAsync("access_token");

    FormData form = FormData.fromMap(mapData!);
    // Fetch data from the server
    Response response = await dioService.dio.post(
      'post/newsfeed',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    var res = response.data;

    if (res["code"] == '200') {
      // Parse the response data and convert it into a list of 'Posts'
      tempList = List.from(res["data"]).map<Posts>((e) {
        Posts posts = Posts.fromJson(e);
        return posts;
      }).toList();

      for (int i = 0; i < tempList.length; i++) {
        if (getUserData.value.id == mapData['user_id']) {
          // Add posts to the user's profile list
          profileList.add(tempList[i]);
        } else {
          // Add posts to the other user's profile list
          otherUserProfile.add(tempList[i]);
        }
        int currentIndex = getUserData.value.id == mapData['user_id']
            ? profileList.length - 1
            : otherUserProfile.length - 1;

        // Update the reaction state
        _reactionState(
          userId: mapData['user_id'],
          isReacted: tempList[i].reaction!.isReacted!,
          type: tempList[i].reaction!.reactionType!,
          index: currentIndex,
          color: SetValuesReactions.checkTypeColor(
              tempList[i].reaction!.reactionType),
          imagePath: SetValuesReactions.checkTypeReaction(
              tempList[i].reaction!.reactionType),
          reactionText: SetValuesReactions.checkTypeText(
              tempList[i].reaction!.reactionType),
          count: tempList[i].reaction?.count,
        );
      }

      if (getUserData.value.id == mapData['user_id']) {
        if (tempList.isEmpty && profileList.isNotEmpty) {
          log("No more post to show");
        }
      } else {
        if (tempList.isEmpty && otherUserProfile.isNotEmpty) {
          log("No more post to show");
        }
      }

      // Set loading state to false after processing
      loadingValue(false);

      notifyListeners();
    } else {
      // Set loading state to false in case of an error
      loadingValue(false);
      notifyListeners();

      // Display an error message
    }
  }

// Lists to store user's profile images and other user's images.
  final List<Posts> _profileImage = []; // Stores the user's profile images
  final List<Posts> _otherUserImages = []; // Stores other user's images

// Getter to provide the appropriate list of profile images based on the user's ID.
  List<Posts> get getProfileImages =>
      getUserData.value.id == _userId ? _profileImage : _otherUserImages;

// This function retrieves images for the user's profile or other users based on mapData.
  Future _getProfilePostImages({Map<String, dynamic>? mapData, context}) async {
    setUserId(mapData?['user_id']); // Set the user's ID based on the mapData

    loadingValue(true); // Set loading state to true

    List<Posts> tempList = [];
    // Call an API to retrieve images

    // dynamic res = await apiClient.callApi(apiData: mapData, apiPath: "posts");
    var accessToken = getStringAsync("access_token");

    FormData form = FormData.fromMap(mapData!);
    // Fetch data from the server
    Response response = await dioService.dio.post(
      'post/newsfeed',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    var res = response.data;

    if (res["code"] == '200') {
      // Parse the response data and convert it into a list of 'Posts'
      tempList = List.from(res["data"]).map<Posts>((e) {
        Posts posts = Posts.fromJson(e);
        return posts;
      }).toList();

      for (int i = 0; i < tempList.length; i++) {
        if (getUserData.value.id == mapData['user_id']) {
          // Add images to the user's profile images list
          _profileImage.add(tempList[i]);
        } else {
          // Add images to the other user's images list
          _otherUserImages.add(tempList[i]);
        }
      }

      if (getUserData.value.id == mapData['user_id']) {
        if (tempList.isEmpty && _profileImage.isNotEmpty) {
          toast("No more images to show");
        }
      } else {
        if (tempList.isEmpty && _otherUserImages.isNotEmpty) {
          toast("No more images to show");
        }
      }

      loadingValue(false); // Set loading state to false after processing
    } else {
      loadingValue(false); // Set loading state to false in case of an error

      // Display an error message
      // toast('Error: ${res['errors']['error_text']}');
    }
  }

//Function get user videos
  final List<Posts> _profileVideos = [];
  final List<Posts> _otherUserVideos = [];
  List<Posts> get getProfileVideos =>
      getUserData.value.id == _userId ? _profileVideos : _otherUserVideos;
  Future _getProfilePostVideos(
      {required Map<String, dynamic>? mapData,
      required BuildContext context}) async {
    setUserId(mapData?['user_id']);

    loadingValue(true);
    List<Posts> tempList = [];
    // dynamic res = await apiClient.callApi(apiData: mapData, apiPath: "posts");
    var accessToken = getStringAsync("access_token");

    FormData form = FormData.fromMap(mapData!);
    // Fetch data from the server
    Response response = await dioService.dio.post(
      'post/newsfeed',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    var res = response.data;

    if (res["code"] == '200') {
      tempList = List.from(res["data"]).map<Posts>((e) {
        Posts posts = Posts.fromJson(e);
        return posts;
      }).toList();

      for (int i = 0; i < tempList.length; i++) {
        if (getUserData.value.id == mapData['user_id']) {
          _profileVideos.add(tempList[i]);
        } else {
          _otherUserVideos.add(tempList[i]);
        }
      }
      if (getUserData.value.id == mapData['user_id']) {
        if (tempList.isEmpty && _profileVideos.isNotEmpty) {
          toast("No more post to show");
        }
      } else {
        if (tempList.isEmpty && _otherUserVideos.isNotEmpty) {
          toast("No more post to show");
        }
      }

      loadingValue(false);
    } else {
      loadingValue(false);
    }
  }

// This function sets the loading state and notifies listeners.
  void loadingValue(value) {
    loading = value;
    notifyListeners();
  }

// This function sets the user's ID and optionally notifies listeners if 'flag' is true.
  void setUserId(userId, {bool? flag}) {
    _userId = userId;
    if (flag == true) {
      notifyListeners();
    }
  }

// This function removes an item at the specified index from the appropriate list based on the user's ID and notifies listeners.
  void removeAtIndex(int index) {
    if (getUserData.value.id == _userId) {
      profileList
          .removeAt(index); // Remove an item from the user's profile list
    } else {
      otherUserProfile
          .removeAt(index); // Remove an item from the other user's profile list
    }
    notifyListeners();
  }

  // This function updates the reaction of a post at the specified index and notifies listeners.
  void changePostAtIndex(index, Posts post) {
    if (_userId == getUserData.value.id) {
      profileList[index].reaction =
          post.reaction; // Update the reaction in the user's profile list
    } else {
      otherUserProfile[index].reaction =
          post.reaction; // Update the reaction in the other user's profile list
    }
    notifyListeners();
  }

// This function clears the appropriate profile lists based on the provided userId and notifies listeners.
  void makeProfileListEmpty(userId) {
    if (getUserData.value.id != userId) {
      otherUserProfile.clear();
      _otherUserImages.clear();
      _otherUserVideos.clear();
    } else {
      profileList.clear();
      _profileImage.clear();
      _profileVideos.clear();
    }
    notifyListeners();
  }

// This function toggles the comment status of a post at the specified index.
// The 'disableValue' parameter is used to explicitly set the comment status, if provided.
  void toggleCommentStatus(int index, Posts? post, {disableValue}) {
    setUserId(post!.userId); // Set the user's ID based on the post's user

    if (disableValue == null) {
      // If 'disableValue' is not provided, toggle the comment status.
      switch (profileList[index].commentsStatus) {
        case '1':
          {
            if (post.userId == getUserData.value.id) {
              profileList[index].commentsStatus =
                  "0"; // Toggle comments off in the user's profile list
            } else {
              otherUserProfile[index].commentsStatus =
                  "0"; // Toggle comments off in the other user's profile list
            }
            break;
          }
        case "0":
          {
            if (post.userId == getUserData.value.id) {
              profileList[index].commentsStatus =
                  "1"; // Toggle comments on in the user's profile list
            } else {
              otherUserProfile[index].commentsStatus =
                  "1"; // Toggle comments on in the other user's profile list
            }
            break;
          }
      }
    } else {
      // If 'disableValue' is provided, set the comment status explicitly.
      if (post.userId == getUserData.value.id) {
        profileList[index].commentsStatus =
            disableValue; // Set comments status in the user's profile list
      } else {
        otherUserProfile[index].commentsStatus =
            disableValue; // Set comments status in the other user's profile list
      }
    }

    notifyListeners();
  }

  // This function updates the number of post comments for a specific post at the specified index.
  void commentChangesProfile(int index, bool increment, userId) {
    bool flag = false;
    if (getUserData.value.id == userId) {
      flag = true;
    }
    setUserId(userId); // Set the user's ID

    switch (increment) {
      case true:
        {
          if (flag == true) {
            // Increment the number of post comments in the user's profile list
            profileList[index].commentCount =
                (profileList[index].commentCount.toInt() + 1).toString();
          } else {
            // Increment the number of post comments in the other user's profile list
            otherUserProfile[index].commentCount =
                (otherUserProfile[index].commentCount.toInt() + 1).toString();
          }
          break;
        }
      default:
        {
          if (flag == true) {
            // Decrement the number of post comments in the user's profile list
            profileList[index].commentCount =
                (profileList[index].commentCount.toInt() - 1).toString();
          } else {
            // Decrement the number of post comments in the other user's profile list
            otherUserProfile[index].commentCount =
                (otherUserProfile[index].commentCount.toInt() - 1).toString();
          }
          break;
        }
    }

    notifyListeners(); // Notify listeners after updating the comment count
  }

  Timer? _timer;
  Reaction? _tempReaction;
  void setPostReactions(int value,
      {index, required Posts posts, context}) async {
    mainReactionProvider(
        // i: index,
        posts: posts,
        value: value,
        index: index);
  }

// Function to provide reactions
  Future<void> mainReactionProvider(
      {required int value, required Posts posts, required index}) async {
    if (posts.userId == getStringAsync("user_id")) {
      _tempReaction ??= Reaction(
        isReacted: profileList[index].reaction?.isReacted,
        image: profileList[index].reaction?.image,
        text: profileList[index].reaction?.text,
        color: profileList[index].reaction?.color,
        count: profileList[index].reaction?.count,
        reactionType: profileList[index].reaction?.reactionType,
      );

      int mainCount = profileList[index].reaction!.count!;
      int tempCount = _tempReaction!.count!;
      bool isReacted = profileList[index].reaction!.isReacted!;

      if (value == 0) {
        log('Inside profile COndition');
        profileList[index].reaction?.count =
            profileList[index].reaction!.count! - 1;
      } else if ((mainCount == (tempCount - 1) || (mainCount == tempCount)) &&
          isReacted == false) {
        log('Inside profile COndition 2');

        profileList[index].reaction?.count =
            profileList[index].reaction!.count! + 1;
      }
    } else {
      _tempReaction ??= Reaction(
        isReacted: otherUserProfile[index].reaction?.isReacted,
        image: otherUserProfile[index].reaction?.image,
        text: otherUserProfile[index].reaction?.text,
        color: otherUserProfile[index].reaction?.color,
        count: otherUserProfile[index].reaction?.count,
        reactionType: otherUserProfile[index].reaction?.reactionType,
      );

      int mainCount = otherUserProfile[index].reaction!.count!;
      int tempCount = _tempReaction!.count!;
      bool isReacted = otherUserProfile[index].reaction!.isReacted!;

      if (value == 0) {
        otherUserProfile[index].reaction?.count =
            otherUserProfile[index].reaction!.count! - 1;
      } else if ((mainCount == (tempCount - 1) || (mainCount == tempCount)) &&
          isReacted == false) {
        otherUserProfile[index].reaction?.count =
            otherUserProfile[index].reaction!.count! + 1;
      }
    }

    switch (value) {
      case 1:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "1",
              index: index,
              color: const Color(0xff037aff),
              imagePath: "assets/fbImages/ic_like_fill.png",
              reactionText: "Liked");

          break;
        }
      case 2:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "2",
              index: index,
              color: const Color(0xffED5167),
              imagePath: "assets/fbImages/love2.png",
              reactionText: "Loved");

          break;
        }
      case 3:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "3",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/haha2.png",
              reactionText: "Haha");

          break;
        }
      case 4:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "4",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/wow2.png",
              reactionText: "Wow");

          break;
        }
      case 5:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "5",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/sad2.png",
              reactionText: "Sad");

          break;
        }

      case 6:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: true,
              type: "6",
              index: index,
              color: const Color(0xffF6876B),
              imagePath: "assets/fbImages/angry2.png",
              reactionText: "Angry");

          break;
        }

      default:
        {
          _reactionState(
              userId: posts.userId,
              isReacted: false,
              type: "0",
              index: index,
              color: Colors.black87,
              imagePath: "assets/fbImages/ic_like.png",
              reactionText: "Like",
              increment: false);

          break;
        }
    }

    if (_timer?.isActive == true) {
      _timer?.cancel();

      _timer = Timer(const Duration(seconds: 0), () async {
        if (_tempReaction?.reactionType != value.toString()) {
          await _hitReactionApi(index: index, posts: posts, value: value);
        }
      });
    } else {
      _timer = Timer(const Duration(seconds: 0), () async {
        await _hitReactionApi(index: index, posts: posts, value: value);
      });
    }
  }

// Function to get reactions
  Future<void> _hitReactionApi(
      {required int index, required Posts posts, required value}) async {
    dynamic res =
        await apiClient.reactionsApi(postId: posts.id, reactionType: value);

    if (res["code"] == '200') {
      _tempReaction = null;
      _timer?.cancel();

      notifyListeners();
    } else {
      if (res['errors']['error_text'] == 'reaction (POST) is missing') {
        _reactionState(
            userId: posts.userId,
            isReacted: false,
            type: "0",
            index: index,
            color: Colors.black87,
            imagePath: "assets/fbImages/ic_like.png",
            reactionText: "Like",
            count: posts.userId == getUserData.value.id
                ? profileList[index].reaction!.count! - 1
                : otherUserProfile[index].reaction!.count! - 1);
      } else {
        _reactionState(
            userId: posts.userId,
            isReacted: _tempReaction!.isReacted!,
            type: _tempReaction!.reactionType!,
            index: index,
            color: _tempReaction!.color!,
            imagePath: _tempReaction!.image!,
            reactionText: _tempReaction!.text!,
            count: _tempReaction?.count);
      }
      _timer?.cancel();
      _tempReaction = null;
      notifyListeners();
    }
  }

  _reactionState(
      {required bool isReacted,
      required String type,
      required int index,
      required Color color,
      required String imagePath,
      required String reactionText,
      required userId,
      int? count,
      bool increment = true}) {
    setUserId(userId);

    if (userId == getUserData.value.id) {
      profileList[index].reaction?.image = imagePath;

      profileList[index].reaction?.color = color;
      profileList[index].reaction?.text = reactionText;

      profileList[index].reaction?.reactionType = type;
      profileList[index].reaction?.isReacted = isReacted;
      if (count != null) {
        profileList[index].reaction?.count = count;
      }
    } else {
      otherUserProfile[index].reaction?.image = imagePath;

      otherUserProfile[index].reaction?.color = color;
      otherUserProfile[index].reaction?.text = reactionText;

      otherUserProfile[index].reaction?.reactionType = type;
      otherUserProfile[index].reaction?.isReacted = isReacted;
      if (count != null) {
        otherUserProfile[index].reaction?.count = count;
      }
    }
    notifyListeners();
    count != null ? null : notifyListeners();
  }

// Function to update reactions
  void reactionUpdate(Posts posts, int index) {
    setUserId(posts.userId);
    if (getUserData.value.id == posts.userId) {
      profileList[index].reaction?.image = posts.reaction?.image;
      profileList[index].reaction?.color = posts.reaction?.color;
      profileList[index].reaction?.text = posts.reaction?.text;
      profileList[index].reaction?.reactionType = posts.reaction?.reactionType;

      profileList[index].reaction?.isReacted = posts.reaction?.isReacted;
      profileList[index].reaction?.count = posts.reaction?.count;
    } else {
      otherUserProfile[index].reaction?.image = posts.reaction?.image;
      otherUserProfile[index].reaction?.color = posts.reaction?.color;
      otherUserProfile[index].reaction?.text = posts.reaction?.text;
      otherUserProfile[index].reaction?.reactionType =
          posts.reaction?.reactionType;

      otherUserProfile[index].reaction?.isReacted = posts.reaction?.isReacted;
      otherUserProfile[index].reaction?.count = posts.reaction?.count;
    }
    notifyListeners();
  }

  bool isPoked = false;
  bool isPokeTileEnable = true;
  DateTime? lastPokeTime;

  Future<bool> pokeUser(userid) async {
    log('value of userid : $userid');

    Map<String, dynamic> dataArray = {
      "user_id": userid,
    };
    dynamic res = await apiClient.callApiCiSocial(
      apiPath: 'poke-user',
      apiData: dataArray,
    );
    if (res["code"] == '200') {
      toast('User poked successfully');
      isPoked = true;
    } else {
      log('Error : ${res['message']}');
    }
    return isPoked;
  }

  // void disableTileFor10Minutes() {
  //   isPokeTileEnable = false;
  //   lastPokeTime = DateTime.now();
  //   Future.delayed(const Duration(minutes: 20), () {
  //     isPokeTileEnable = !isPokeTileEnable;
  //   });
  //   notifyListeners();
  // }
}
