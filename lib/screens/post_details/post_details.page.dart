import 'package:link_on/components/gloabal_comments_widgets/comment_textfiled.dart';
import 'package:link_on/components/gloabal_comments_widgets/custum_comment_list.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:flutter/material.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class PostDetailsPage extends StatefulWidget {
  final String? postid;
  final bool? isMainPosts;
  final bool? tempPost;
  final int? index;
  final bool? isProfilePost;

  const PostDetailsPage(
      {Key? key,
      this.postid,
      this.isMainPosts,
      this.tempPost,
      this.index,
      this.isProfilePost})
      : super(key: key);

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  void initState() {
    super.initState();
    var postDetailProvider =
        Provider.of<PostDetailProvider>(context, listen: false);
    var commentsProvider =
        Provider.of<MainCommentsProvider>(context, listen: false);

    postDetailProvider.setEventScreen = widget.isMainPosts == true
        ? "home"
        : widget.isProfilePost == true
            ? "profile"
            : widget.tempPost == true
                ? "tempData"
                : "";
    commentsProvider.makemainListEmpty();
    commentsProvider.getMainComments(postId: widget.postid);
    postDetailProvider.getdata(widget.postid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostDetailProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value.posts.id != null && value.loading == false) ...[
                Text(
                  (value.posts.user!.firstName != null &&
                              value.posts.user!.lastName != null) &&
                          (value.posts.user!.firstName != "" &&
                              value.posts.user!.lastName != "")
                      ? "${value.posts.user!.firstName!} ${value.posts.user!.lastName!}"
                      : value.posts.user!.username.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.sw,
                value.posts.user!.isVerified == "1"
                    ? verified()
                    : const SizedBox.shrink(),
              ],
            ],
          ),
        ),
        body: value.posts.id == null && value.loading == true
            ? Center(
                child: Loader(),
              )
            : value.posts.id == null && value.loading == false
                ? Center(
                    child: Text(
                      translate(context, 'no_data_found')!,
                    ),
                  )
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PostTile(
                              isMainPosts: widget.isMainPosts,
                              isProfilePosts: widget.isProfilePost,
                              posts: value.posts,
                              tempPost: widget.tempPost,
                              detailPost: true,
                              index: widget.index,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                translate(context, 'comments')!,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            if (value.posts.commentsStatus == "0") ...[
                              AspectRatio(
                                aspectRatio: 3 / 1,
                                child: Center(
                                  child: Text(
                                    translate(context, 'comments_disabled')!,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                            Consumer<MainCommentsProvider>(
                              builder: (context, commentValue, child) {
                                return commentValue.mainCommentsList.isEmpty &&
                                        commentValue.loading == true
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : value.posts.commentsStatus != "0"
                                        ? commentValue.mainCommentsList.isEmpty
                                            ? AspectRatio(
                                                aspectRatio: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    loading(),
                                                    Text(
                                                      translate(context,
                                                          'no_data_found')!,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey.shade800,
                                                          fontSize: 16),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        commentValue
                                                            .getMainComments(
                                                                postId: value
                                                                    .posts.id);
                                                      },
                                                      child: Text(
                                                        translate(context,
                                                            'load_again')!,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : CustomCommentList(
                                                posts: value.posts,
                                                isPostDetail: true,
                                                isMainPost: widget.isMainPosts,
                                                isProfilePost:
                                                    widget.isProfilePost,
                                                isVideoPost: false,
                                                commentList: commentValue
                                                    .mainCommentsList,
                                              )
                                        : const SizedBox.shrink();
                              },
                            ),
                            100.sh,
                          ],
                        ),
                      ),
                      value.posts.commentsStatus != "0"
                          ? Positioned(
                              bottom: 0.0,
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: CommentTextField(
                                  isPostDetail: true,
                                  isMainPost: widget.isMainPosts,
                                  isProfilePost: widget.isProfilePost,
                                  postId: widget.postid,
                                  postIndex: widget.index ?? 0,
                                  userId: value.posts.userId,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
      ),
    );
  }
}
