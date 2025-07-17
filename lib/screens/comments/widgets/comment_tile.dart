// ignore_for_file: use_build_context_synchronously
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/gestures.dart';
import 'package:link_on/components/custom_form_field_alt.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart' as postModel;
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/comments/comments.page.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatefulWidget {
  final postModel.Comment? comment;
  final void Function()? iconOnPress;
  final int? index;
  const CommentTile({Key? key, this.comment, this.iconOnPress, this.index})
      : super(key: key);

  @override
  State<CommentTile> createState() => CommentTileState();
}

class CommentTileState extends State<CommentTile> {
  bool isKeyboard = false;
  bool isVisible = false;
  TextEditingController controller = TextEditingController();

  int index = 0;
  bool isShowingTranslation = false;
  String translateText = "";
  String currentLanguag = "";
  List<postModel.Comment> tempList = [];

  CommentsPageState page = CommentsPageState();
  bool showComment = false;
  @override
  void initState() {
    currentLanguag = getStringAsync("current_language_code");
    super.initState();
    context.read<MainCommentsProvider>().makeFetchCommentLisEmpty();
  }

  void setLikeComments({@required commentId, value, isReplyComment}) async {
    dynamic res = await apiClient.likeComment(
        commentid: commentId, postId: widget.comment!.postId);

    if (res['code'] == '200') {
      log(" Response is $res");

      if (res['message'] == 'You have unliked the comment.') {
        widget.comment?.isCommentLiked = false;

        widget.comment!.likeCount =
            (int.parse(widget.comment!.likeCount!) - 1).toString();
      } else {
        widget.comment?.isCommentLiked = true;

        widget.comment!.likeCount =
            (int.parse(widget.comment!.likeCount!) + 1).toString();
      }
      setState(() {});
    } else {
      toast('Error: ${res['message']}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider =
        Provider.of<PostDetailProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer<MainCommentsProvider>(builder: (context, value, child) {
        return CommentTreeWidget<postModel.Comment, postModel.Comment>(
            widget.comment!,
            value.fetchCommentsReply.isEmpty
                ? tempList
                : value.fetchCommentsReply[0].commentId == widget.comment!.id
                    ? value.fetchCommentsReply
                    : tempList,
            treeThemeData: TreeThemeData(
                lineColor: context
                            .watch<MainCommentsProvider>()
                            .fetchCommentsReply
                            .isNotEmpty &&
                        value.fetchCommentsReply[0].commentId ==
                            widget.comment!.id
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.transparent,
                lineWidth: 1),
            avatarRoot: (context, data) => PreferredSize(
                  preferredSize: const Size.fromRadius(18),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRoutes.profile, arguments: data.userId),
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage('${data.avatar}')),
                  ),
                ),
            avatarChild: (context, data) => PreferredSize(
                  preferredSize: const Size.fromRadius(12),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRoutes.profile, arguments: data.userId),
                    child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage('${data.avatar}')),
                  ),
                ),
            contentChild: (context, data) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${data.firstName} ${data.lastName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              4.sw,
                              data.isVerified == "1"
                                  ? verified()
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            data.comment.toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            data.createdHuman ?? "now",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                          data.userId == getStringAsync("user_id")
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<MainCommentsProvider>()
                                        .deleteCommentReply(
                                            replyId: data.id,
                                            index: widget.index);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.primaryColor,
                                    size: 20,
                                  ))
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ]);
            },
            contentRoot: (context, data) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${data.firstName} ${data.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            4.sw,
                            data.isVerified == "1"
                                ? verified()
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        CommentWidget(comment: data.comment!),
                        currentLanguag == "en"
                            ? SizedBox.shrink()
                            : GestureDetector(
                                onTap: isShowingTranslation == false
                                    ? () {
                                        postProvider
                                            .getTranslateText(
                                                type: "comment",
                                                language: "en",
                                                postId: widget.comment!.id)
                                            .then((val) {
                                          if (val != null) {
                                            setState(() {
                                              translateText = val;
                                              isShowingTranslation = true;
                                            });
                                          }
                                        });
                                      }
                                    : () {
                                        setState(() {
                                          isShowingTranslation = false;
                                        });
                                      },
                                child: Text(
                                  isShowingTranslation
                                      ? "Hide Translation"
                                      : "See Translation",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                        // Display Translated Text
                        if (isShowingTranslation)
                          Text(
                            translateText,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        // Text(
                        //   data.comment.toString(),
                        //   style:
                        //       Theme.of(context).textTheme.bodySmall?.copyWith(
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.comment!.createdHuman}",
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                          onTap: () {
                            setLikeComments(
                                commentId: widget.comment?.id,
                                value: widget.comment?.isCommentLiked);
                          },
                          child: widget.comment?.isCommentLiked == true
                              ? Text(
                                  translate(context, 'liked')!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                    fontSize: 11,
                                  ),
                                )
                              : Text(
                                  translate(context, 'like')!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                    fontSize: 11,
                                  ),
                                )),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                          onTap: () async {
                            context.read<MainCommentsProvider>().commentData(
                                data: widget.comment!,
                                index: widget.index,
                                saveIndex: widget.comment?.id);
                            if ((widget.comment?.commentReplies != "0" &&
                                    widget.comment?.commentReplies != null) &&
                                value.saveIndex == widget.comment?.id) {
                              if (value.fetchCommentsReply.isEmpty ||
                                  value.fetchCommentsReply[0].id !=
                                      widget.comment?.id) {
                                await value.fetchCommentReplyApi(
                                    commentId: widget.comment?.id);
                              }
                            } else {
                              value.makeFetchCommentLisEmpty(flag: true);
                            }
                          },
                          child: Text(
                            translate(context, 'reply')!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: AppColors.primaryColor),
                          )),
                      if (data.userId == getStringAsync("user_id")) ...[
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: widget.iconOnPress,
                          child: const Icon(
                            Icons.delete,
                            size: 15,
                          ),
                        )
                      ],

                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        int.parse(widget.comment!.likeCount!) < 0
                            ? '0'
                            : "${widget.comment!.likeCount}",
                        style: TextStyle(
                            fontSize: 11, color: AppColors.primaryColor),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        translate(context, 'likes')!,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryColor,
                        ),
                      )
                      // Image.asset(
                      //   'assets/fbImages/like.gif',
                      //   width: 15.0,
                      //   height: 15.0,
                      // ),
                    ],
                  ),
                  (widget.comment?.replyCount != "0" &&
                          widget.comment?.replyCount != null)
                      ? TextButton(
                          onPressed: () {
                            context
                                .read<MainCommentsProvider>()
                                .fetchCommentReplyApi(
                                    commentId: widget.comment?.id);
                          },
                          child: Text(
                            translate(context, 'view_comment_replies')!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      : const SizedBox.shrink(),
                ]));
      }),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    // Split the comment into parts
    final parts = comment.split(' ');

    // Create a list to hold the TextSpans
    List<InlineSpan> textSpans = [];

    for (var part in parts) {
      if (part.startsWith('@')) {
        // This is a mention, make it bold and tappable
        textSpans.add(
          TextSpan(
            text: part,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                log(part);
              },
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.blue[900]),
          ),
        );
      } else {
        // This is regular text
        textSpans.add(
          TextSpan(
            text: part,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }

      // Add a space after each part except the last one
      if (part != parts.last) {
        textSpans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class CustomReplyMessage extends StatelessWidget {
  final dynamic controller;
  final dynamic onPressed;
  const CustomReplyMessage({super.key, this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        elevation: 2,
        child: CustomFormFieldAlt(
          controller: controller,
          hintText: translate(context, 'write_reply_hint'),
          bottomPadding: 0,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              LineIcons.paper_plane,
              color: AppColors.primaryColor,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
