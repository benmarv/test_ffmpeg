import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/utils/reaction.dart';

class PostDetailProvider extends ChangeNotifier {
  // Create a private instance variable _posts of the Posts class.
  Posts _posts = Posts();

// Create a boolean variable to indicate loading status.
  bool loading = false;

// Setter method to set the value of _posts and update its reaction properties.
  set setPost(Posts posts) {
    _posts = posts;
    // Update the reaction properties based on the provided reaction type.
    posts.reaction?.image =
        SetValuesReactions.checkTypeReaction(posts.reaction?.reactionType);
    posts.reaction?.color =
        SetValuesReactions.checkTypeColor(posts.reaction?.reactionType);
    posts.reaction?.text =
        SetValuesReactions.checkTypeText(posts.reaction?.reactionType);
    // Notify listeners to reflect the changes in the UI. (You can uncomment this line)
    notifyListeners();
  }

// Getter method to access the current value of _posts.
  Posts get posts => _posts;

// Method to make the _posts instance empty.
  void makePostEmpty() {
    _posts = Posts();
    // Notify listeners to reflect the changes in the UI.
    notifyListeners();
  }

// A method to fetch data for a specific post based on the post ID.
  Future<void> getdata(String postid) async {
    // Clear the existing post data and set loading to true.
    makePostEmpty();
    loadingData(true);

    var accessToken = getStringAsync("access_token");

    Response response = await dioService.dio.get(
      'post/detail',
      queryParameters: {'post_id': postid},
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    var res = response.data;

    if (res["code"] == '200') {
      // If the API call is successful, set the fetched post data and mark loading as false.
      setPost = Posts.fromJson(res['data']);
      notifyListeners();
      loadingData(false);
    } else {
      // If there's an error, mark loading as false and display an error message.
      notifyListeners();

      loadingData(false);
      toast('Error: ${res['message']}');
    }
  }

// Setter method for setting the screen name (You can add implementation here).
  set setScreenName(screenName) {}

// Method for updating the loading status and notifying listeners.
  void loadingData(bool value) {
    loading = value;
    notifyListeners();
  }

// Method for updating the comment count in the post detail.
  void commentChangesPostDetail(bool increment) {
    String commentValue = _posts.commentCount!;
    if (increment == true) {
      _posts.commentCount = (commentValue.toInt() + 1).toString();
    } else {
      _posts.commentCount = (commentValue.toInt() - 1).toString();
    }
    notifyListeners();
  }

// Method for toggling the comment status in the post detail.
  toggleCommentStatus({disableValue}) {
    if (disableValue == true) {
      switch (_posts.commentsStatus) {
        case '1':
          {
            _posts.commentsStatus = "0";
            break;
          }
        case "0":
          {
            _posts.commentsStatus = "1";
            break;
          }
      }
    } else {
      _posts.commentsStatus = disableValue;
    }
    notifyListeners();
  }

// Timer and temporary Reaction object for handling post reactions.
  Timer? _timer;
  Reaction? _tempReaction;

// Event screen identifier to distinguish where the reaction is taking place.
  String _eventScreen = '';

// Setter method for setting the event screen.
  set setEventScreen(String value) => _eventScreen = value;

// Getter method for retrieving the event screen value.
  String get eventScreen => _eventScreen;

// Method for setting post reactions with provided parameters.
  void setPostReactions(
    int value, {
    index,
    postId,
    context,
  }) async {
    log('Post Reaction');
    mainReactionProvider(postId: postId, value: value, index: index);
  }

// This function handles post reactions.
  Future<void> mainReactionProvider(
      {required int value,
      required postId,
      required index,
      String? screenName}) async {
    // Initialize a temporary Reaction object with the current post's reaction data.
    _tempReaction ??= Reaction(
      isReacted: _posts.reaction?.isReacted,
      image: _posts.reaction?.image,
      text: _posts.reaction?.text,
      color: _posts.reaction?.color,
      count: _posts.reaction?.count,
      reactionType: _posts.reaction?.reactionType,
    );

    // Store counts and reacted state for comparison.
    int mainCount = _posts.reaction!.count!;
    int tempCount = _tempReaction!.count!;
    bool isReacted = _posts.reaction!.isReacted!;

    // Update the count of reactions based on the reaction value.
    if (value == 0) {
      _posts.reaction?.count = _posts.reaction!.count! - 1;
    } else if ((mainCount == (tempCount - 1) || (mainCount == tempCount)) &&
        isReacted == false) {
      _posts.reaction?.count = _posts.reaction!.count! + 1;
    }

    // Based on the provided reaction value, update the post's reaction state.--
    switch (value) {
      case 1:
        {
          _reactionState(
              isReacted: true,
              type: "1",
              index: index,
              color: const Color(0xff037aff),
              imagePath: "assets/fbImages/ic_like_fill.png",
              reactionText: "Liked");

          notifyListeners();
          break;
        }
      case 2:
        {
          _reactionState(
              isReacted: true,
              type: "2",
              index: index,
              color: const Color(0xffED5167),
              imagePath: "assets/fbImages/love2.png",
              reactionText: "Loved");

          notifyListeners();
          break;
        }
      case 3:
        {
          _reactionState(
              isReacted: true,
              type: "3",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/haha2.png",
              reactionText: "Haha");

          notifyListeners();
          break;
        }
      case 4:
        {
          _reactionState(
              isReacted: true,
              type: "4",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/wow2.png",
              reactionText: "Wow");

          notifyListeners();
          break;
        }
      case 5:
        {
          _reactionState(
              isReacted: true,
              type: "5",
              index: index,
              color: const Color(0xffFFD96A),
              imagePath: "assets/fbImages/sad2.png",
              reactionText: "Sad");

          notifyListeners();
          break;
        }
      case 6:
        {
          _reactionState(
              isReacted: true,
              type: "6",
              index: index,
              color: const Color(0xffF6876B),
              imagePath: "assets/fbImages/angry2.png",
              reactionText: "Angry");

          notifyListeners();
          break;
        }

      default:
        {
          // For unreacting, revert to the default "Like" state.
          _reactionState(
              isReacted: false,
              type: "0",
              index: index,
              color: Colors.black87,
              imagePath: "assets/fbImages/ic_like.png",
              reactionText: "Like",
              increment: false);

          notifyListeners();
          break;
        }
    }

    // Set a timer to update the reaction on the server after 2 seconds.
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 0), () async {
        if (_tempReaction?.reactionType != value.toString()) {
          await _hitReactionApi(index: index, postId: postId, value: value);
        }
      });
    } else {
      _timer = Timer(const Duration(seconds: 0), () async {
        await _hitReactionApi(index: index, postId: postId, value: value);
      });
    }
  }

  // This function updates the state of post reactions.
  void _reactionState(
      {required bool isReacted,
      required String type,
      required int index,
      required Color color,
      required String imagePath,
      required String reactionText,
      int? count,
      bool increment = true}) {
    // Update the post's reaction state with the provided values.
    _posts.reaction?.image = imagePath;
    _posts.reaction?.color = color;
    _posts.reaction?.text = reactionText;
    _posts.reaction?.reactionType = type;
    _posts.reaction?.isReacted = isReacted;

    // Optionally, update the reaction count.
    if (count != null) {
      // If increment is true, update the count.
      if (increment) {
        _posts.reaction?.count = count;
      }
    }
  }

  // This function is responsible for sending a reaction to a post via an API call.
  Future<void> _hitReactionApi(
      {required int index, required postId, required value}) async {
    // Call the API to submit a reaction for the specified post.
    log('Reaction Type is ${value.toString()}');
    dynamic res =
        await apiClient.reactionsApi(postId: postId, reactionType: value);

    if (res["code"] == '200') {
      // Successfully submitted the reaction.
      // Update the post data in the appropriate provider based on the event screen.
      BuildContext? context = navigatorKey.currentContext;
      switch (eventScreen) {
        case 'home':
          {
            context?.read<PostProvider>().changePostAtIndex(index, _posts);
            break;
          }
        case "profile":
          {
            context
                ?.read<ProfilePostsProvider>()
                .changePostAtIndex(index, _posts);
            break;
          }
        case "tempData":
          {
            context?.read<PostProviderTemp>().changePostAtIndex(index, _posts);
            break;
          }
      }
      _tempReaction = null;
      _timer?.cancel();
      notifyListeners();
    } else {
      // Handle errors if the reaction submission was not successful.
      if (res['errors']['error_text'] == 'reaction (POST) is missing') {
        // If the error indicates a missing reaction, handle it accordingly.
        _reactionState(
            isReacted: false,
            type: "0",
            index: index,
            color: Colors.black87,
            imagePath: "assets/fbImages/ic_like.png",
            reactionText: "Like",
            count: _posts.reaction!.count! - 1);
      } else {
        // Restore the reaction state to its previous state in case of other errors.
        _posts.reaction?.image = _tempReaction?.image;
        _posts.reaction?.color = _tempReaction?.color;
        _posts.reaction?.text = _tempReaction?.text;
        _posts.reaction?.reactionType = _tempReaction?.reactionType;
        _posts.reaction?.isReacted = _tempReaction?.isReacted;
        _posts.reaction?.count = _tempReaction?.count;
      }
      _timer?.cancel();
      _tempReaction = null;
      notifyListeners();
    }
  }

  ////////////////////////Post Content translation Function///////////////
  Future<String?> getTranslateText(
      {String? type, String? language, postId}) async {
    final dataMap = {"id": postId, "type": type, "format": language};
    dynamic res = await apiClient.callApiCiSocial(
      apiPath: "translate",
      apiData: dataMap,
    );
    log('Responseeeeeeeeee is ${res}');
    if (res["code"] == "200") {
      return res["data"];
    } else if (res["code" == "400"]) {
      toast(
        'Error found',
        bgColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    } 
    return null;
  }
  ////////////////////////Post Content translation Function END///////////
}
