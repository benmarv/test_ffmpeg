import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/reactionlist/reaction_list.dart';

class PostsAction extends StatefulWidget {
  const PostsAction({super.key, this.posts, this.isDetailPost = false});
  final Posts? posts;
  final bool? isDetailPost;

  @override
  State<PostsAction> createState() => _PostsActionState();
}

class _PostsActionState extends State<PostsAction> {
  @override
  initState() {
    log('Detail Post: ${widget.isDetailPost}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Platform.isIOS ? 20 : 10, 0, Platform.isIOS ? 20 : 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReactionsList(
                          postid: widget.posts?.id,
                        ))),
            child: Row(
              children: [
                Text(
                  widget.posts!.reaction!.count.toString(),
                  style: const TextStyle(
                      color: AppColors.postBottomColor, fontSize: 12),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  translate(context, 'reaction')!,
                  style: TextStyle(
                    color: AppColors.postBottomColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (widget.isDetailPost == false ||
                  widget.isDetailPost == null) ...[
                iconText(
                  icon: Icons.remove_red_eye_outlined,
                  text: widget.posts!.viewCount == null
                      ? '0'
                      : widget.posts!.viewCount!,
                  size: 14.0,
                ),
                const SizedBox(width: 7),
              ],
              iconText(
                icon: CupertinoIcons.bubble_left,
                text: widget.posts?.commentCount == ""
                    ? "${0}"
                    : "${widget.posts?.commentCount}",
                size: 14.0,
              ),
              const SizedBox(width: 7),
              iconText(
                icon: CupertinoIcons.arrowshape_turn_up_right,
                text: widget.posts?.shareCount == ""
                    ? "${0}"
                    : "${widget.posts?.shareCount}",
                size: 14.0,
              )
            ],
          ),
        ],
      ),
    );
  }
}
