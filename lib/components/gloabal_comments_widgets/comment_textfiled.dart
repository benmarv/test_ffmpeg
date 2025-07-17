// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/mention_provider/mention_provider.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';

class CommentTextField extends StatefulWidget {
  final String? postId;
  final String? userId;
  final bool? isMainPost;
  final int? postIndex;
  final bool? isVideoScreen;
  final bool? isProfilePost;
  final bool? isPostDetail;

  const CommentTextField({
    Key? key,
    required this.postId,
    required this.userId,
    required this.isMainPost,
    required this.postIndex,
    this.isVideoScreen,
    this.isProfilePost,
    this.isPostDetail,
  }) : super(key: key);

  @override
  _CommentTextFieldState createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final mentionProvider =
        Provider.of<MentionProvider>(context, listen: false);
    final friendProvider = Provider.of<FriendFollower>(context, listen: false);

    friendProvider.makeFriendFollowerEmpty();
    friendProvider.friendGetFollower();
    mentionProvider.initProvider();

    _controller
        .addListener(() => mentionProvider.onTextChanged(context, _controller));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          left: 10,
          right: 10,
        ),
        child: Consumer<MainCommentsProvider>(
          builder: (context, mainCommentsProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (mainCommentsProvider.mainCommentData != null)
                  _buildCommentPreview(mainCommentsProvider),
                _buildMentionSuggestions(),
                _buildCommentInput(mainCommentsProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCommentPreview(MainCommentsProvider mainCommentsProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "${mainCommentsProvider.mainCommentData?.firstName} ${mainCommentsProvider.mainCommentData?.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: mainCommentsProvider.removeCommentData,
                child: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
          Text(
            mainCommentsProvider.mainCommentData?.comment ?? '',
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMentionSuggestions() {
    final mentionProvider = Provider.of<MentionProvider>(context);
    if (mentionProvider.isShowingSuggestions) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mentionProvider.filteredUsers.length,
            itemBuilder: (context, index) {
              final user = mentionProvider.filteredUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar!),
                  radius: 25,
                ),
                title: Text("${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500)),
                subtitle: Text("@${user.username}"),
                onTap: () =>
                    mentionProvider.onSelectMention(index, _controller),
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCommentInput(MainCommentsProvider mainCommentsProvider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: translate(context, 'write_a_comment'),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _handleSubmit(mainCommentsProvider),
          child: const CircleAvatar(
            child: Icon(Icons.send),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(MainCommentsProvider mainCommentsProvider) {
    if (_controller.text.isEmpty) {
      toast(translate(context, 'write_something'));

      return;
    }
    if (mainCommentsProvider.mainCommentData != null) {
      mainCommentsProvider.createCommentReply(
        commentId: mainCommentsProvider.mainCommentData?.id,
        message: _controller.text.trim(),
      );
      setState(() {
        mainCommentsProvider.mainCommentData = null;
      });
    } else {
      mainCommentsProvider.createComment(
        userId: widget.userId,
        isProfileScreen: widget.isProfilePost,
        isVideoPost: widget.isVideoScreen,
        context: context,
        isPostDetail: widget.isPostDetail,
        postId: widget.postId,
        content: _controller.text.trim(),
        isMainPost: widget.isMainPost,
        mentionedUserIds: Provider.of<MentionProvider>(context, listen: false)
            .matchingUserIds,
        postIndex: widget.postIndex,
      );
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.clear();
  }
}
