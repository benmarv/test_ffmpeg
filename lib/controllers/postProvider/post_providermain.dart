// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/CommentsProvider/comment_provider2.dart';
import 'package:link_on/controllers/connectvity_error_provider.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/utils/reaction.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:overlay_support/overlay_support.dart' as toast;
import 'package:provider/provider.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'dart:developer' as dev;

class GreetingsProvider extends ChangeNotifier {
  int currentIndex = 0;
  void setCurrentTabIndex({required int index}) {
    currentIndex = index;
    notifyListeners();
  }

  bool greetingVisibilty = true;
  void closeGreetingCard() {
    greetingVisibilty = false;
    notifyListeners();
  }

  bool homeMenuTab = true;
  void closeHomeMenuTab() {
    homeMenuTab = false;
    notifyListeners();
  }
}

class BackgroundPostColor {
  final String className;
  final Decoration decoration;

  BackgroundPostColor({required this.className, required this.decoration});
}

class PostProvider extends ConnectivityErrorProvider {
  ScrollController scrollController = ScrollController();

  bool isAudioData = false;
  bool checkBottom = false;
  bool endPostItem = false;
  bool hitApi = false;
  bool internet = false;
  bool datacheck = false;
  void initScrollController() {
    scrollController = ScrollController();
  }

  List<String> taggedUserIds = [];
  List<String> taggedUserNames = [];

  List<BackgroundPostColor> availableDarkModeColors = [
    BackgroundPostColor(
      className: '_23ju',
      decoration: const BoxDecoration(
        color: Color(0xFFc600ff),
      ),
    ),
    BackgroundPostColor(
      className: '_23jo',
      decoration: const BoxDecoration(
        color: Color(0xFFffffff),
      ),
    ),
    BackgroundPostColor(
      className: '_2j78',
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
      ),
    ),
    BackgroundPostColor(
      className: '_2j79',
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF0047), Color(0xFF2c34c7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j80',
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFfc36fd), Color(0xFF5d3fda)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j81',
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5d6374), Color(0xFF16181d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j82',
      decoration: const BoxDecoration(
        color: Color(0xFF00a859),
      ),
    ),
    BackgroundPostColor(
      className: '_2j83',
      decoration: const BoxDecoration(
        color: Color(0xFF0098da),
      ),
    ),
    BackgroundPostColor(
      className: '_2j84',
      decoration: const BoxDecoration(
        color: Color(0xFF3e4095),
      ),
    ),
    BackgroundPostColor(
      className: '_2j85',
      decoration: const BoxDecoration(
        color: Color(0xFF4b4f56),
      ),
    ),
    BackgroundPostColor(
      className: '_2j86',
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
      ),
    ),
    BackgroundPostColor(
      className: '_2j87',
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.socioon.com/assets/images/post/bgpst1.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j88',
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.socioon.com/assets/images/post/bgpst2.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j89',
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.socioon.com/assets/images/post/bgpst3.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
    BackgroundPostColor(
      className: '_2j90',
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.socioon.com/assets/images/post/bgpst4.png'),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ];

  void updateTaggedUser(
      {required bool checkvalue,
      required String id,
      required String firstName,
      required String lastName}) {
    if (checkvalue == true) {
      taggedUserIds.add(id);
      taggedUserNames.add("$firstName $lastName");
    } else {
      taggedUserIds.remove(id);
      taggedUserNames.remove("$firstName $lastName");
    }
    notifyListeners();
  }

  double? lastScrollingPosition;
  setLastScrollingPosition({required double position}) {
    lastScrollingPosition = position;
    notifyListeners();
  }

  List<Posts> postListProvider = [];
  Future<void> getApiDataProvider({context, afterPostId}) async {
    try {
      internetCheck(boolValue: false);
      hitPostApi(true);
      datacheck = false;
      super.makeConnectionEmpty();
      var accessToken = getStringAsync("access_token");

      var postComments = Provider.of<PostComments2>(context, listen: false);
      Map<String, dynamic> mapData = {'limit': 6};

      if (afterPostId != null) {
        mapData["last_post_id"] = afterPostId;
      }
      FormData form = FormData.fromMap(mapData);
      Response response = await dioService.dio.post(
        'post/newsfeed',
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      var res = response.data;

      if (res['code'] == '200') {
        datacheck = true;
        log('get posts api res: ${res['data']}');

        List<Posts> tempList = [];

        var productsData = res["data"];

        tempList = List.from(productsData).map<Posts>((post) {
          Posts myposts = Posts.fromJson(post);
          return myposts;
        }).toList();
        log('get posts api templist : $tempList');

        for (int i = 0; i < tempList.length; i++) {
          if (!postListProvider.any((post) => post.id == tempList[i].id)) {
            postListProvider.add(tempList[i]);
            checkBottomBool(false);
            hitPostApi(false);
            int currentIndex = postListProvider.length - 1;
            postListProvider[currentIndex].reaction?.image =
                SetValuesReactions.checkTypeReaction(
                    tempList[i].reaction!.reactionType);
            postListProvider[currentIndex].reaction?.color =
                SetValuesReactions.checkTypeColor(
                    tempList[i].reaction!.reactionType);
            postListProvider[currentIndex].reaction?.text =
                SetValuesReactions.checkTypeText(
                    tempList[i].reaction!.reactionType);

            postComments.addPostComment(
                addAtFirstIndex: false,
                postId: tempList[i].id,
                totalComments: tempList[i].comments);
          }
        }

        if (tempList.isEmpty) {
          // If the response data is empty, mark the end of post items
          endPostItemCheck(true, context);
        } else {
          // If there is data in the response, there are more posts to show
          endPostItemCheck(false, context);
        }
        notifyListeners();

        // Check for errors in the response and handle them
      } else {
        hitPostApi(false);

        if (res.containsKey(Constants.timeOutConnection)) {
          // Handle timeout errors
          super.connectivityErrors(error: res[Constants.timeOutConnection]);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${res['errors']['error_text']}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    } catch (e) {
      log('Something went wrong! : $e');
    } finally {
      hitPostApi(false);
    }
    notifyListeners();
  }

  Future<bool> votePoll({pollOptionId, pollId}) async {
    var accessToken = getStringAsync("access_token");

    Map<String, dynamic> mapData = {
      'poll_id': pollId,
      'poll_option_id': pollOptionId
    };
    log("voted map data $mapData");
    FormData form = FormData.fromMap(mapData);
    Response res = await dioService.dio.post(
      'post/poll-vote',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );
    if (res.data['status'] == '200') {
      log('voted : ${res.data['message']}');
      return true;
    } else {
      log('voted error : ${res.data['message']}');

      return false;
    }
  }

  void addAmountInCollectedDonation(
      {required int index, required String amount}) {
    postListProvider[index].donation!.collectedAmount = amount;
    notifyListeners();
  }

  // Function to toggle the 'hitApi' value
  void hitPostApi(value) {
    hitApi = value;
    notifyListeners();
  }

// Function to set the 'checkBottom' value
  void checkBottomBool(value) {
    checkBottom = value;
    notifyListeners();
  }

// Function to set the 'internet' value
  void internetCheck({boolValue}) {
    internet = boolValue;
    notifyListeners();
  }

// Function to mark the end of post items and display a message if 'checkBottom' is true
  void endPostItemCheck(value, context) {
    endPostItem = value;
    if (value == true) {
      checkBottomBool(false);
      hitPostApi(false);
      // Show a Snackbar message when there are no more posts to show
      // toast.toast('No more posts to show');
    }
    notifyListeners();
  }

// Function to remove a post at a specified index
  void removePostAtIndex(int? indexvalue) {
    postListProvider.removeAt(indexvalue!);
    notifyListeners();
  }

// Function to insert a post at a specified index
  void insertAtIndex({index, Posts? data, context}) async {
    postListProvider.insert(index, data!);
    //
    if (data.video != null) {
      Provider.of<InitializePostVideoProvider>(context, listen: false)
          .initializeVideoAtFirstIndex(url: data.video!.mediaPath);
    }
//
    int currentIndex = index;
    postListProvider[currentIndex].reaction?.image =
        SetValuesReactions.checkTypeReaction(data.reaction?.reactionType);
    postListProvider[currentIndex].reaction?.color =
        SetValuesReactions.checkTypeColor(data.reaction?.reactionType);
    postListProvider[currentIndex].reaction?.text =
        SetValuesReactions.checkTypeText(data.reaction?.reactionType);
    notifyListeners();
  }

// Function to refresh the posts
  void resfreshPosts({context}) async {
    internetCheck(boolValue: false);
    super.makeConnectionEmpty();
    forNotificationBadge();
    var postComments = Provider.of<PostComments2>(context, listen: false);
    var initializeVideo =
        Provider.of<InitializePostVideoProvider>(context, listen: false);

    var accessToken = getStringAsync("access_token");
    Map<String, dynamic> mapData = {
      'limit': 6,
    };
    FormData form = FormData.fromMap(mapData);
    // Fetch data from the server
    Response response = await dioService.dio.post(
      'post/newsfeed',
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );
    var res = response.data;
    if (res['code'] == '200') {
      initializeVideo.makeListEmpty();
      postComments.makePostEmptyList();
      makeListEmpty();
      List<Posts> tempList = [];
      var decodedData = res;
      var productsData = decodedData["data"];
      tempList = List.from(productsData).map<Posts>((post) {
        Posts myposts = Posts.fromJson(post);
        return myposts;
      }).toList();

      for (int i = 0; i < tempList.length; i++) {
        postListProvider.add(tempList[i]);
        initializeVideo.addDataDataToList(index: i);
        int currentIndex = postListProvider.length - 1;
        postListProvider[currentIndex].reaction?.image =
            SetValuesReactions.checkTypeReaction(
                tempList[i].reaction!.reactionType);
        postListProvider[currentIndex].reaction?.color =
            SetValuesReactions.checkTypeColor(
                tempList[i].reaction!.reactionType);
        postListProvider[currentIndex].reaction?.text =
            SetValuesReactions.checkTypeText(
                tempList[i].reaction!.reactionType);

        postComments.addPostComment(
            addAtFirstIndex: true,
            postId: tempList[i].id,
            totalComments: tempList[i].comments);
        notifyListeners();
      }
    } else {
      if (res.containsKey(Constants.timeOutConnection)) {
        // Handle timeout errors
        super.connectivityErrors(error: res[Constants.timeOutConnection]);
      } else if (res.containsKey(Constants.noInternet)) {
        toast.toast("No internet");
        super.connectivityErrors(error: Constants.noInternet);
      } else {
        // Show an error message as a Snackbar
        print('Error: ${res['message']}');
      }
    }
  }

  // Function to clear the post list
  void makeListEmpty() {
    postListProvider = [];
    print('post list empty called');
    notifyListeners();
  }

// Function to change the "isPostSaved" value at a specific index
  void changeSavePostValue({index, value}) {
    postListProvider[index].isSaved = value;
    notifyListeners();
  }

// Function to change the post at a specific index
  void changePostAtIndex(index, Posts post) {
    postListProvider[index].reaction = post.reaction;
    notifyListeners();
  }

// Function to delete a post
  Future<void> deletePostProvider({
    required postId,
    index,
    bool? flag,
    required BuildContext context,
    String? eventScreen,
  }) async {
    // Prepare the API request data
    Map<String, dynamic> mapData = {
      "action": "delete",
      "post_id": postId,
    };
    String url = "post/action";

    // Show a custom loader dialogue while making the API request
    customDialogueLoader(context: context);
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res["code"] == '200') {
      // Successfully deleted the post

      toast.toast(
        "Post deleted successfully",
      );

      Navigator.pop(context);

      // Determine which screen the action originated from and remove the post accordingly
      switch (eventScreen) {
        case "home":
          removePostAtIndex(index);
          break;
        case "profile":
          context.read<ProfilePostsProvider>().removeAtIndex(index);
          break;
        case "tempData":
          context.read<PostProviderTemp>().removeAtIndex(index, context);
          break;
      }

      if (flag == true) {
        context.read<PostDetailProvider>().makePostEmpty();
      }
    } else {
      // Handle errors and show an error message
      Navigator.pop(context);
      log("Error: ${res['message']}");
    }
    // notifyListeners();
  }

  void remvoveController() {
    scrollController.dispose();
  }

// Function to share a post on the timeline
  Future<void> sharePostonTimeLine(
      {required BuildContext context,
      required Posts post,
      String? text,
      String? groupId,
      String? pageId}) async {
    // Show a custom loader dialogue while making the API request
    customDialogueLoader(context: context);

    // Prepare the API request data
    Map<String, dynamic> mapData = {
      "post_id": post.id,
    };

    if (text != '') {
      mapData["shared_text"] = text;
    }
    if (groupId != '') {
      mapData["group_id"] = groupId;
    }
    if (pageId != '') {
      mapData["page_id"] = pageId;
    }

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "post/share");
    log("share response is ${res['message']}");

    if (res["code"] == '200') {
      post.shareCount = ((int.tryParse(post.shareCount!) ?? 0) + 1).toString();

      var data = res["data"];

      // Successfully shared the post
      toast.toast(res['message']);

      Navigator.pop(context);
      Navigator.pop(context);

      // Insert the shared post at index 0
      insertAtIndex(index: 0, data: Posts.fromJson(data), context: context);
    } else {
      // Handle errors and show an error message
      Navigator.pop(context);
      Navigator.pop(context);
      toast.toast(res['messag              e']);

      log("Error: ${res['message']}");
    }
    notifyListeners();
  }

// Function to share a post
  Future sharposts({context, Map<String, dynamic>? mapData, url}) async {
    // Show a custom loader dialogue while making the API request
    customDialogueLoader(context: context);

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);

    if (res["code"] == '200') {
      // Successfully shared the post
      Posts myposts = Posts.fromJson(res["data"]);
      insertAtIndex(context: context, index: 0, data: myposts);
      toast.toast("Share post successfully");

      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      // Handle errors and show an error message
      Navigator.pop(context);
      log("Error: ${res['message']}");
    }
  }

// Function to handle notification badges
  bool hideNotification = false;
  int totalNotifications = 0;

  void markAllAsRead() {
    totalNotifications = 0;
    notifyListeners();
  }

  Future<void> forNotificationBadge() async {
    // Prepare the API request data
    Map<String, dynamic> mapData = {};

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "notifications/new");

    if (res["code"] == '200') {
      // If there are new notifications, update the badge
      totalNotifications = res["data"].length;

      notifyListeners();
    } else {
      // Handle errors and show appropriate messages
      if (res.containsKey(Constants.timeOutConnection)) {
        super.connectivityErrors(error: res[Constants.timeOutConnection]);
      } else if (res.containsKey(Constants.noInternet)) {
        toast.toast("No internet");
        super.connectivityErrors(error: Constants.noInternet);
      } else {
        log("Error: ${res['message']}");
      }
    }
  }

// Function to hide or show notification badge
  void hideBadge({bool? value}) {
    hideNotification = value!;
    notifyListeners();
  }

  String? _disableValue;

// Function to toggle comment status
  void _toggleCommentStatus(int index, {bool? toggle}) {
    _disableValue ??= postListProvider[index].commentsStatus;
    if (toggle == null) {
      switch (postListProvider[index].commentsStatus) {
        case '1':
          {
            postListProvider[index].commentsStatus = "0";
            break;
          }
        case "0":
          {
            postListProvider[index].commentsStatus = "1";
            break;
          }
      }
    } else {
      postListProvider[index].commentsStatus = _disableValue;
    }
    notifyListeners();
  }

  Future<void> setCommentDisable(
      {required int index,
      String? eventScreen,
      required BuildContext context,
      Posts? posts,
      bool? flag}) async {
    // Check the event screen to determine which context to use.
    switch (eventScreen) {
      case "home":
        {
          // Toggle comment status for the home screen.
          _toggleCommentStatus(index);
          break;
        }
      case "profile":
        {
          // Toggle comment status for the profile screen.
          context
              .read<ProfilePostsProvider>()
              .toggleCommentStatus(index, posts);
          break;
        }
      case "tempData":
        {
          // Toggle comment status for temporary data screen.
          context.read<PostProviderTemp>().toggleCommentStatus(index);
          break;
        }
    }
    if (flag == true) {
      // Toggle comment status for the post detail provider if needed.
      context.read<PostDetailProvider>().toggleCommentStatus();
    }
    // Call the API to disable comments for the given post.
    dynamic res = await apiClient.commentDisableApi(postId: posts?.id);

    if (res["code"] == '200') {
      // Reset the disableValue if the API call is successful.
      _disableValue = null;
    } else {
      switch (eventScreen) {
        case "home":
          {
            // Revert comment status for the home screen if there was an error.
            _toggleCommentStatus(index, toggle: true);
            break;
          }
        case "profile":
          {
            // Revert comment status for the profile screen if there was an error.
            context
                .read<ProfilePostsProvider>()
                .toggleCommentStatus(index, posts, disableValue: _disableValue);
            break;
          }
        case "tempData":
          {
            // Revert comment status for temporary data screen if there was an error.
            context
                .read<PostProviderTemp>()
                .toggleCommentStatus(index, disableValue: _disableValue);
            break;
          }
      }
      if (flag == true) {
        // Revert comment status for the post detail provider if needed.
        context
            .read<PostDetailProvider>()
            .toggleCommentStatus(disableValue: _disableValue);
      }
      // Show an error toast message with the error text from the API response.
      _disableValue = null;
      log("Error: ${res['message']}");
    }
  }

  void commentChangesMain(int index, bool increment) {
    // Get the current comment count for the post at the specified index.
    String commentValue = postListProvider[index].commentCount!;
    if (increment == true) {
      // Increment the comment count by 1 if 'increment' is true.
      postListProvider[index].commentCount =
          (commentValue.toInt() + 1).toString();
    } else {
      // Decrement the comment count by 1 if 'increment' is false.
      postListProvider[index].commentCount =
          (commentValue.toInt() - 1).toString();
    }
    notifyListeners();
  }

  Timer? _timer;
  Reaction? _tempReaction;

  void setPostReactions(int value, {index, postId, context}) async {
    dev.log("value data ios $value");

    // Call the main reaction provider to handle post reactions.
    mainReactionProvider(i: index, postId: postId, value: value, index: index);
  }

  Future<void> mainReactionProvider(
      {required int value, required i, required postId, required index}) async {
    // Initialize _tempReaction with the reaction details of the current post.
    _tempReaction ??= Reaction(
      isReacted: postListProvider[index].reaction?.isReacted,
      image: postListProvider[index].reaction?.image,
      text: postListProvider[index].reaction?.text,
      color: postListProvider[index].reaction?.color,
      count: postListProvider[index].reaction?.count,
      reactionType: postListProvider[index].reaction?.reactionType,
    );

    // Get the main reaction count, temp reaction count, and reaction status.
    int mainCount = postListProvider[index].reaction!.count!;
    int tempCount = _tempReaction!.count!;
    bool isReacted = postListProvider[index].reaction!.isReacted!;

    log('Count of postListProvider value ${value.toString()}');
    log('Count of postListProvider mainCount ${mainCount.toString()}');
    log('Count of postListProvider tempCount ${tempCount.toString()}');
    log('Count of postListProvider isReacted ${isReacted.toString()}');

    // Update the reaction count based on the value provided.
    if (value == 0) {
      log('Count of postListProvider on Unlike ${postListProvider[index].reaction?.count.toString()}');

      postListProvider[index].reaction?.count =
          postListProvider[index].reaction!.count! - 1;

      log('Count of postListProvider on After Unlike ${postListProvider[index].reaction?.count.toString()}');
    } else if ((mainCount == (tempCount - 1) || (mainCount == tempCount)) &&
        isReacted == false) {
      log('Count of postListProvider on Like ${postListProvider[index].reaction?.count.toString()}');

      postListProvider[index].reaction?.count =
          postListProvider[index].reaction!.count! + 1;

      log('Count of postListProvider After Like ${postListProvider[index].reaction?.count.toString()}');
    }

    // Handle different reaction types.
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
          );
          notifyListeners();
          break;
        }
    }

    // Handle the reaction timer to update the server with the reaction.
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

  Future<void> _hitReactionApi({
    required int index,
    required String postId,
    required int value,
  }) async {
    // Make an API call to update the reaction for the specified post.
    log("Hit Reaction Api ${value.toString()}");
    try {
      dynamic res =
          await apiClient.reactionsApi(postId: postId, reactionType: value);

      log('Response of reaction api ${res.toString()}');

      if (res["code"] == '200') {
        // If the API call is successful, reset the temporary reaction data and cancel the timer.
        _tempReaction = null;
        _timer?.cancel();
        notifyListeners();
        // You might want to display a success message here.
      } else {
        if (res['errors']['error_text'] == 'reaction (POST) is missing') {
          // Handle the case where the reaction is missing with a default reaction.
          _reactionState(
              isReacted: false,
              type: "0",
              index: index,
              color: Colors.black87,
              imagePath: "assets/fbImages/ic_like.png",
              reactionText: "Like",
              count: postListProvider[index].reaction!.count! - 1);
        } else {
          // Restore the previous reaction data (stored in _tempReaction) in case of an error.
          _reactionState(
              isReacted: _tempReaction!.isReacted!,
              type: _tempReaction!.reactionType!,
              index: index,
              color: _tempReaction!.color!,
              imagePath: _tempReaction!.image!,
              reactionText: _tempReaction!.text!,
              count: _tempReaction?.count);
        }

        // Cancel the timer, clear _tempReaction, and notify listeners of the error.
        _timer?.cancel();
        _tempReaction = null;
        notifyListeners();
        // Display an error message to the user.
        log("Error: ${res['message']}");
      }
    } catch (e) {
      // Handle network errors or other exceptions
      _timer?.cancel();
      _tempReaction = null;
      notifyListeners();
      // Display an error message to the user.
      log("Network error: $e");
    }
  }

  void _reactionState({
    required bool isReacted,
    required String type,
    required int index,
    required Color color,
    required String imagePath,
    required String reactionText,
    int? count,
  }) {
    // Update the reaction properties for the post at the specified index.
    postListProvider[index].reaction?.image = imagePath;
    postListProvider[index].reaction?.color = color;
    postListProvider[index].reaction?.text = reactionText;
    postListProvider[index].reaction?.reactionType = type;
    postListProvider[index].reaction?.isReacted = isReacted;

    // Only update the count if it's not null and the count is greater than 0.
    if (count != null && postListProvider[index].reaction!.count! > 0) {
      postListProvider[index].reaction?.count = count;
    }
  }

  void reactionUpdate(Posts posts, int index) {
    // Update the reaction properties for the post at the specified index using data from another Posts object.
    postListProvider[index].reaction?.image = posts.reaction?.image;
    postListProvider[index].reaction?.color = posts.reaction?.color;
    postListProvider[index].reaction?.text = posts.reaction?.text;
    postListProvider[index].reaction?.reactionType =
        posts.reaction?.reactionType;
    postListProvider[index].reaction?.isReacted = posts.reaction?.isReacted;

    // Update the count from the Posts object only if it's not null.
    postListProvider[index].reaction?.count = posts.reaction?.count;

    // Notify listeners to reflect the changes in the UI.
    notifyListeners();
  }

// Change event status for a specific post at the given index.
  void changeEventStatus(int index, {bool? isGoing, bool? isIntrested}) {
    if (isGoing == true) {
      // Update the "isGoing" status for the event of the post at the specified index.
      postListProvider[index].event?.isGoing = isGoing;
    } else {
      // Update the "isInterested" status for the event of the post at the specified index.
      postListProvider[index].event?.isInterested = isIntrested;
    }

    // Notify listeners to reflect the changes in the UI.
    notifyListeners();
  }
}
