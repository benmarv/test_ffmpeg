import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/comments/widgets/comment_tile.dart';
import 'package:provider/provider.dart';
import 'package:link_on/models/posts.dart';

class CustomCommentList extends StatefulWidget {
  final List<Comment> commentList;
  final bool? isMainPost;
  final bool? isProfilePost;
  final bool? isVideoPost;
  final bool? isPostDetail;
  final Posts? posts;

  const CustomCommentList({
    Key? key,
    required this.posts,
    required this.commentList,
    this.isProfilePost,
    this.isMainPost,
    this.isVideoPost,
    this.isPostDetail,
  }) : super(key: key);

  @override
  State<CustomCommentList> createState() => _CustomCommentListState();
}

class _CustomCommentListState extends State<CustomCommentList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 100.0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.commentList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return CommentTile(
            comment: widget.commentList[index],
            index: index,
            iconOnPress: () => _showDialog(
              index: index,
              commentId: widget.commentList[index].id!,
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 2),
      ),
    );
  }

  void _showDialog({required int index, required String commentId}) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(translate(context, 'confirm_delete_comment')
            .toString()), // Translated text for "Are you sure you want to delete this comment?"
        actions: [
          CupertinoDialogAction(
            onPressed: () => _deleteComment(index, commentId),
            child: Text(
              translate(context, 'delete')
                  .toString(), // Translated text for "Delete"
              style: const TextStyle(color: Colors.red),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              translate(context, 'cancel').toString(),
            ), // Translated text for "Cancel"
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(int index, String commentId) async {
    Navigator.pop(context);
    await Provider.of<MainCommentsProvider>(context, listen: false)
        .deleteMainComments(
      userId: widget.posts?.userId,
      isPostDetail: widget.isPostDetail,
      isProfileScreen: widget.isProfilePost,
      isVideoScreen: widget.isVideoPost,
      isMainPost: widget.isMainPost,
      commentId: commentId,
      index: index,
      context: context,
    );
  }
}
