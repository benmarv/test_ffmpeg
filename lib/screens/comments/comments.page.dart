// ignore_for_file: must_be_immutable, unused_import
import 'package:link_on/components/gloabal_comments_widgets/custum_comment_list.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/components/gloabal_comments_widgets/comment_textfiled.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  CommentsPage(
      {super.key,
      this.post,
      this.postid,
      this.postIndex,
      this.isMainPost,
      this.isPostDetail,
      required this.isProfilePost,
      this.isVideoScreen});
  final int? postIndex;
  Posts? post;
  String? postid;

  final bool? isMainPost;
  final bool? isProfilePost;
  final bool? isVideoScreen;
  final bool? isPostDetail;
  @override
  CommentsPageState createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<MainCommentsProvider>(context, listen: false);
    provider.makemainListEmpty();
    provider.getMainComments(postId: widget.postid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Column(
      children: [
        10.sh,
        bottomSheetTopDivider(color: AppColors.primaryColor),
        10.sh,
        Consumer<MainCommentsProvider>(
          builder: (context, value, child) {
            return value.mainCommentsList.isEmpty && value.loading == true
                ? SizedBox(
                    height: size.height * 0.8,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  )
                : value.mainCommentsList.isEmpty && value.loading == false
                    ? SizedBox(
                        height: size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loading(),
                            Center(
                              child: Text(
                                translate(context, 'no_comments_yet')
                                    .toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Center(
                              child: Text(
                                translate(context, 'be_the_first_to_comment')
                                    .toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )
                    : CustomCommentList(
                        posts: widget.post,
                        isPostDetail: widget.isPostDetail,
                        isMainPost: widget.isMainPost,
                        isProfilePost: widget.isProfilePost,
                        isVideoPost: widget.isVideoScreen,
                        commentList: value.mainCommentsList,
                      );
          },
        ),
        // 80.sh,
      ],
    );

    // );
  }
}
