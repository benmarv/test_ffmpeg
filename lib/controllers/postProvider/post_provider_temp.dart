import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:link_on/controllers/CommentsProvider/comment_provider2.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/utils/reaction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/controllers/connectvity_error_provider.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/viewModel/api_client.dart';

class PostProviderTemp extends ConnectivityErrorProvider {
  // List to temporarily store posts data
  final List<Posts> _postFileTemp = [];

// Variable to track loading state
  bool loading = false;

// Function to fetch and process post data
  Future getPostData({
    required Map<String, dynamic> mapData,
    required BuildContext context,
    String? postType,
  }) async {
    // Obtain the PostComments2 provider
    var postComments = Provider.of<PostComments2>(context, listen: false);

    // Set loading state to true
    loadData(true);

    // Temporary list to store fetched posts
    List<Posts> tempList = [];
    log("page posts payload : $mapData");

    // Fetch posts data from the API
    dynamic res = await apiClient.callApiCiSocial(
      apiData: mapData,
      apiPath: 'post/newsfeed',
    );
    log("page posts : ${res}");
    if (res["code"] == '200') {
      // Map the response data to Posts objects
      var data = res['data'];

      tempList = List.from(data).map<Posts>((e) {
        Posts posts = Posts.fromJson(e);
        return posts;
      }).toList();
      for (int i = 0; i < tempList.length; i++) {
        if (!_postFileTemp.any((element) => element.id == tempList[i].id)) {
          _postFileTemp.add(tempList[i]);
          int currentIndex = _postFileTemp.length - 1;

          // Set reaction data for the post
          _postFileTemp[currentIndex].reaction?.image =
              SetValuesReactions.checkTypeReaction(
                  tempList[i].reaction!.reactionType);
          _postFileTemp[currentIndex].reaction?.color =
              SetValuesReactions.checkTypeColor(
                  tempList[i].reaction!.reactionType);
          _postFileTemp[currentIndex].reaction?.text =
              SetValuesReactions.checkTypeText(
                  tempList[i].reaction!.reactionType);

          // Add comments to the postComments provider
          postComments.addComment2(
            addAtFirstIndex: false,
            postId: tempList[i].id,
            totalComments: tempList[i].comments,
          );
        }
      }

      if (tempList.isEmpty && _postFileTemp.isNotEmpty) {
        toast('No more posts to show');
      }

      // Set loading state to false
      loadData(false);
      notifyListeners();
    } else {
      if (res.runtimeType == String) {
        // Handle connectivity errors
        super.connectivityErrors(error: res);
      } else if (res == null) {
        toast("No internet");
        super.connectivityErrors(error: Constants.noInternet);
      }
      // Set loading state to false
      loadData(false);
      notifyListeners();
    }
    notifyListeners();
  }

  // Function to update the loading state
  void loadData(bool value) {
    loading = value;
    notifyListeners();
  }

// Function to remove a post at a specific index
  void removeAtIndex(int index, BuildContext context) {
    postListTemp.removeAt(index);
    notifyListeners();
  }

// Function to clear the post list
  makePostListEmpty() {
    _postFileTemp.clear();
    notifyListeners();
  }

// Function to update a post at a specific index
  void changePostAtIndex(index, Posts post) {
    _postFileTemp[index].reaction = post.reaction;
    notifyListeners();
  }

// Function to insert a post at a specific index
  void insertAtIndex({index, Posts? data, context}) {
    var postComments = Provider.of<PostComments2>(context, listen: false);
    _postFileTemp.insert(index, data!);

    Provider.of<InitializePostVideoProvider>(context, listen: false)
        .initializeVideoAtFirstIndex(url: data.video!.mediaPath);
    int currentIndex = index;
    _postFileTemp[currentIndex].reaction?.image =
        SetValuesReactions.checkTypeReaction(data.reaction!.reactionType);
    _postFileTemp[currentIndex].reaction?.color =
        SetValuesReactions.checkTypeColor(data.reaction!.reactionType);
    _postFileTemp[currentIndex].reaction?.text =
        SetValuesReactions.checkTypeText(data.reaction!.reactionType);
    postComments.addComment2(
        addAtFirstIndex: true, postId: data.id, totalComments: data.comments);
    notifyListeners();
  }

// Getter to access the post list
  List<Posts> get postListTemp => _postFileTemp;

// Function to toggle comment status for a post
  toggleCommentStatus(int index, {disableValue}) {
    if (disableValue == null) {
      switch (_postFileTemp[index].commentsStatus) {
        case '1':
          {
            _postFileTemp[index].commentsStatus = "0";
            break;
          }
        case "0":
          {
            _postFileTemp[index].commentsStatus = "1";
            break;
          }
      }
    } else {
      _postFileTemp[index].commentsStatus = disableValue;
    }
    notifyListeners();
  }

// Function to update comment count for a post
  void commentChangesTemp(int index, bool increment) {
    String commentValue = _postFileTemp[index].commentCount!;
    if (increment == true) {
      _postFileTemp[index].commentCount = (commentValue.toInt() + 1).toString();
    } else {
      _postFileTemp[index].commentCount = (commentValue.toInt() - 1).toString();
    }
    notifyListeners();
  }

// Function to set post reactions
  Timer? _timer;
  Reaction? _tempReaction;
  void setPostReactions(int value, {index, postId, context}) async {
    dev.log("value data ios ${value.toString()}");

    mainReactionProvider(i: index, postId: postId, value: value, index: index);
  }

// Function to provide reaction
  Future<void> mainReactionProvider(
      {required int value, required i, required postId, required index}) async {
    _tempReaction ??= Reaction(
      isReacted: postListTemp[index].reaction?.isReacted,
      image: postListTemp[index].reaction?.image,
      text: postListTemp[index].reaction?.text,
      color: postListTemp[index].reaction!.color,
      count: postListTemp[index].reaction?.count,
      reactionType: postListTemp[index].reaction?.reactionType,
    );
    int mainCount = postListTemp[index].reaction!.count!;
    int tempCount = _tempReaction!.count!;
    bool isReacted = postListTemp[index].reaction!.isReacted!;
    if (value == 0) {
      postListTemp[index].reaction?.count =
          postListTemp[index].reaction!.count! - 1;
    } else if ((mainCount == (tempCount - 1) || (mainCount == tempCount)) &&
        isReacted == false) {
      postListTemp[index].reaction?.count =
          postListTemp[index].reaction!.count! + 1;
    }
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
    if (_timer?.isActive == true) {
      _timer?.cancel();

      _timer = Timer(const Duration(seconds: 2), () async {
        if (_tempReaction?.reactionType != value.toString()) {
          await _hitReactionApi(index: index, postId: postId, value: value);
        }
      });
    } else {
      _timer = Timer(const Duration(seconds: 2), () async {
        await _hitReactionApi(index: index, postId: postId, value: value);
      });
    }
  }

// Function to handle the API call for post reactions
  Future<void> _hitReactionApi(
      {required int index, required postId, required value}) async {
    dynamic res =
        await apiClient.reactionsApi(postId: postId, reactionType: value);

    if (res["code"] == '200') {
      _tempReaction = null;
      _timer?.cancel();
      notifyListeners();
    } else {
      if (res['errors']['error_text'] == 'reaction (POST) is missing') {
        _reactionState(
          isReacted: false,
          type: "0",
          index: index,
          color: Colors.black87,
          imagePath: "assets/fbImages/ic_like.png",
          reactionText: "Like",
          count: _postFileTemp[index].reaction!.count! - 1,
        );
      } else {
        _postFileTemp[index].reaction?.image = _tempReaction?.image;
        _postFileTemp[index].reaction?.color = _tempReaction!.color;
        _postFileTemp[index].reaction?.text = _tempReaction?.text;
        _postFileTemp[index].reaction?.reactionType =
            _tempReaction?.reactionType;
        _postFileTemp[index].reaction?.isReacted = _tempReaction?.isReacted;
        _postFileTemp[index].reaction?.count = _tempReaction?.count;
      }
      _timer?.cancel();
      _tempReaction = null;
      notifyListeners();
      log(
        'Error: ${res['message']}',
      );
    }
  }

  // Function to update the reaction state for a post
  void _reactionState(
      {required bool isReacted,
      required String type,
      required int index,
      required Color color,
      required String imagePath,
      required String reactionText,
      int? count,
      bool increment = true}) {
    postListTemp[index].reaction?.image = imagePath;
    postListTemp[index].reaction?.color = color;
    postListTemp[index].reaction?.text = reactionText;
    postListTemp[index].reaction?.reactionType = type;
    postListTemp[index].reaction?.isReacted = isReacted;

    if (count != null) {
      postListTemp[index].reaction?.count = count;
    }
  }

// Function to update the reaction of a post
  void reactionUpdate(Posts posts, int index) {
    _postFileTemp[index].reaction?.image = posts.reaction?.image;
    _postFileTemp[index].reaction?.color = posts.reaction!.color;
    _postFileTemp[index].reaction?.text = posts.reaction?.text;
    _postFileTemp[index].reaction?.reactionType = posts.reaction?.reactionType;
    _postFileTemp[index].reaction?.isReacted = posts.reaction?.isReacted;
    _postFileTemp[index].reaction?.count = posts.reaction?.count;
    notifyListeners();
  }
}
