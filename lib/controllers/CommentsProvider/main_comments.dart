// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';
import 'comment_provider2.dart';

class MainCommentsProvider extends ChangeNotifier {
  List<Comment> mainCommentsList = [];
  bool loading = false;
  bool noInternet = false;

  Future<void> getMainComments({@required postId}) async {
    try {
      loading = true;
      internetConnectivity(value: false);
      var accessToken = getStringAsync("access_token");

      Response response = await dioService.dio.get(
        'post/comments/getcomment',
        queryParameters: {'post_id': postId},
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      var res = response.data;
      if (res['code'] == '200') {
        var commentsData = res['data'];
        mainCommentsList = List.from(commentsData).map<Comment>((comment) {
          return Comment.fromJson(comment);
        }).toList();
        loading = false;
      } else if (res['code'] == '400') {
        loading = false;
        print("comments api message : ${res['message']}");
      }
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  void setLikeComments(
      {@required context,
      @required commentId,
      @required postId,
      @required index,
      value,
      isReplyComment}) async {
    dynamic res =
        await apiClient.likeComment(commentid: commentId, postId: postId);

    if (res['code'] == '200') {
      log(" Response is $res");

      if (res['message'] == 'You remove like ') {
        mainCommentsList[index].isCommentLiked = false;
      } else {
        mainCommentsList[index].isCommentLiked = true;
      }
      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
  }

// Function to update internet connectivity status
  internetConnectivity({required bool value}) {
    noInternet = value;
    notifyListeners();
  }

// Function to make the main comments list empty
  makemainListEmpty() {
    mainCommentsList = [];
    notifyListeners();
  }

// Function to add data to the main comments list
  addDataInList({required data}) {
    mainCommentsList.add(data);
  }

  Future<void> createComment({
    final flag,
    required postId,
    required content,
    required isMainPost,
    bool? isVideoPost,
    bool? isProfileScreen,
    bool? isPostDetail,
    required List<String> mentionedUserIds,
    required userId,
    required BuildContext context,
    required postIndex,
  }) async {
    // String mentionedUsers = mentionedUserIds.join(",");

    var postComments = Provider.of<PostComments2>(context, listen: false);
    internetConnectivity(value: false);

    Map<String, dynamic> mapData = {
      'post_id': postId,
      'comment_text': content,
    };

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "post/comments/add");

    log('Response of comment ${res}');

    if (res['code'] == '200') {
      var data = Comment.fromJson(res['data']);

      mainCommentsList.add(data);

      if (isPostDetail == true) {
        context.read<PostDetailProvider>().commentChangesPostDetail(true);
      }

      if (isMainPost == true) {
        context.read<PostProvider>().commentChangesMain(postIndex, true);
      } else if (isProfileScreen == true) {
        context
            .read<ProfilePostsProvider>()
            .commentChangesProfile(postIndex, true, userId);
      } else if (isVideoPost == true) {
        context
            .read<RandomVideoProvider>()
            .commentChangesRandomVideos(postIndex, true);
      } else {
        context.read<PostProviderTemp>().commentChangesTemp(postIndex, true);
      }

      if (flag == null) {
        if (isMainPost == true) {
          postComments.addPostComment(postId: postId, index: postIndex);
        } else {
          postComments.addComment2(postId: postId, index: postIndex);
        }
      }

      notifyListeners();
    } else if (res == true) {
      internetConnectivity(value: true);
    } else {}
  }

  Future<void> deleteMainComments({
    required commentId,
    required int index,
    bool? isMainPost,
    bool? isPostDetail,
    required bool? isProfileScreen,
    bool? isVideoScreen,
    required userId,
    required BuildContext context,
  }) async {
    customDialogueLoader(context: context);

    // Prepare data for deleting a comment
    Map<String, dynamic> mapData = {
      "comment_id": commentId,
    };

    // Call the API to delete a comment
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "post/comments/delete");

    if (res["code"] == '200') {
      // Navigator.of(context).pop();

      if (isPostDetail == true) {
        context.read<PostDetailProvider>().commentChangesPostDetail(false);
      }

      if (isMainPost == true) {
        context.read<PostProvider>().commentChangesMain(index, false);
      } else if (isProfileScreen == true) {
        context
            .read<ProfilePostsProvider>()
            .commentChangesProfile(index, false, userId);
      } else if (isVideoScreen == true) {
        context
            .read<RandomVideoProvider>()
            .commentChangesRandomVideos(index, false);
      } else {
        context.read<PostProviderTemp>().commentChangesTemp(index, false);
      }

      mainCommentsList.removeAt(index);
      Navigator.of(context).pop();

      toast(res['message']);
      notifyListeners();
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

////////////////////////////////////////////////////////////
  ///
  /// Replies

  List<Comment> fetchCommentsReply = [];
  Comment? mainCommentData;
  int mainCommentListIndex = 0;
  String saveIndex = "";

  // Fetch reply comments
  Future<void> fetchCommentReplyApi({commentId}) async {
    makeFetchCommentLisEmpty(flag: true);

    // Call the API to fetch reply comments
    dynamic res = await apiClient.fetchReplyComment(
      commentId: commentId,
    );

    if (res['code'] == '200') {
      var decodedData = res;
      var reponse = decodedData['data'];

      log("Fetch reply Response is $reponse");
      fetchCommentsReply =
          List.from(reponse).map<Comment>((e) => Comment.fromJson(e)).toList();

      log("Fetch reply Response is ${fetchCommentsReply[0].comment}");

      saveIndex = commentId;
      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
  }

  // Create a reply comment
  Future<void> createCommentReply({commentId, message, int? index}) async {
    saveIndex = commentId;

    // Call the API to create a reply comment
    dynamic res =
        await apiClient.commentReplyApi(commentId: commentId, message: message);

    if (res['code'] == '200') {
      var decodedData = res;
      Comment? commentReplyFetch;

      var createcommentdata = decodedData['data'];
      commentReplyFetch = Comment.fromJson(createcommentdata);
      log("add comment reply response is $res");
      fetchCommentsReply.add(commentReplyFetch);
      mainCommentsList[mainCommentListIndex].replyCount =
          (mainCommentsList[mainCommentListIndex].replyCount.toInt() + 1)
              .toString();

      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
  }

// Delete a reply comment
  Future<void> deleteCommentReply({replyId, int? index}) async {
    // Call the API to delete a reply comment
    dynamic res = await apiClient.deleteCommentReply(replyId: replyId);

    if (res['code'] == '200') {
      log("delete comment response is $res");
      for (var value in fetchCommentsReply) {
        if (value.id == replyId) {
          fetchCommentsReply.remove(value);
          mainCommentsList[index!].replyCount =
              (mainCommentsList[index].replyCount.toInt() - 1).toString();
          break;
        }
      }
      toast(res["message"]);
      notifyListeners();
    } else {
      toast(res["message"]);
    }
  }

// Set main comment data
  void commentData({required Comment data, int? index, String? saveIndex}) {
    mainCommentData = data;
    mainCommentListIndex = index!;
    this.saveIndex = saveIndex!;
    notifyListeners();
  }

// Remove main comment data
  void removeCommentData() {
    mainCommentData = null;
    notifyListeners();
  }

// Make the reply comments list empty
  void makeFetchCommentLisEmpty({bool? flag}) {
    fetchCommentsReply = [];
    if (flag == true) {
    } else {
      mainCommentData = null;
    }
    notifyListeners();
  }
}
