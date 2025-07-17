import 'package:flutter/material.dart';
import 'package:link_on/components/gloabal_comments_widgets/comment_textfiled.dart';
import 'package:link_on/consts/colors.dart';

Future commentBottomSheet(
    {required context,
    required Widget widget,
    Color? colors,
    required userId,
    required postId,
    bool? isMainPost,
    int? postIndex,
    bool? isProfilePost,
    bool? isPostDetail,
    bool? isVideoPost}) {
  return showModalBottomSheet<void>(
    enableDrag: true,
    isScrollControlled: true,
    isDismissible: true, // Set to true to allow dismissing on tap outside

    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
    backgroundColor: colors ?? AppColors.primaryColor,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: widget,
                ),
              ),
              // if (context.watch<MainCommentsProvider>().loading != false) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CommentTextField(
                    userId: userId,
                    isPostDetail: isPostDetail,
                    isProfilePost: isProfilePost,
                    isVideoScreen: isVideoPost,
                    isMainPost: isMainPost,
                    postId: postId,
                    postIndex: postIndex),
              ),
              // ]
            ],
          ),
        ),
      );
    },
  );
}
