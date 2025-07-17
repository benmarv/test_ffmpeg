// ignore_for_file: library_prefixes, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart' as postModel;
import 'package:link_on/screens/comments/comments.page.dart';
import 'package:link_on/screens/comments/widgets/comment_bottom.dart';
import 'package:link_on/screens/tabs/home/widgets/custom_share/custom_share.dart';
import 'package:link_on/utils/Spaces/custom_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/screens/tabs/home/widgets/custom_share/group_share.dart';
import 'package:link_on/screens/tabs/home/widgets/custom_share/page_share.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'feed_reaction.dart';

class FlutterFeedReaction extends StatefulWidget {
  @override
  _FlutterFeedReactionState createState() => _FlutterFeedReactionState();
  final bool? isMainPosts;
  const FlutterFeedReaction({
    super.key,
    this.prefix,
    required this.dragSpace,
    this.dragStart = 50.0,
    this.suffix,
    this.spacing = 0.0,
    this.containerWidth = 250.0,
    this.childAnchor = Alignment.topLeft,
    this.portalAnchor = Alignment.bottomLeft,
    this.containerDecoration,
    this.posts,
    this.showShare = true,
    this.showComments = true,
    this.index,
    this.isMainPosts,
    this.isPostDetail,
    this.isProfilePost,
    this.tempPost,
  });

  final postModel.Posts? posts;
  final bool showShare;
  final bool showComments;
  final bool? isProfilePost;
  final bool? isPostDetail;
  final bool? tempPost;

  final int? index;

  final Widget? prefix;

  final Widget? suffix;

  final double dragSpace;

  final double dragStart;

  final Alignment childAnchor;

  final Alignment portalAnchor;

  final double spacing;

  final double containerWidth;

  final BoxDecoration? containerDecoration;
}

class _FlutterFeedReactionState extends State<FlutterFeedReaction>
    with TickerProviderStateMixin {
  List<FeedReaction>? reactions = [
    FeedReaction(
      id: 1,
      header: 'like',
      reaction: Image.asset(
        'assets/fbImages/like.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 2,
      header: 'love',
      reaction: Image.asset(
        'assets/fbImages/love.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 3,
      header: 'haha',
      reaction: Image.asset(
        'assets/fbImages/haha.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 4,
      header: 'wow',
      reaction: Image.asset(
        'assets/fbImages/wow.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 5,
      header: 'sad',
      reaction: Image.asset(
        'assets/fbImages/sad.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
    FeedReaction(
      id: 6,
      header: 'angry',
      reaction: Image.asset(
        'assets/fbImages/angry.gif',
        width: 40.0,
        height: 40.0,
      ),
    ),
  ];

  int indexPath = 0;
  dynamic path = "assets/fbImages/thick2.png";
  int durationAnimationBox = 500;
  int durationAnimationBtnLongPress = 150;
  int durationAnimationBtnShortPress = 500;
  int durationAnimationIconWhenDrag = 150;
  int durationAnimationIconWhenRelease = 1000;

  // For long press btn
  late AnimationController animControlBtnLongPress, animControlBox;
  late Animation zoomIconLikeInBtn, tiltIconLikeInBtn, zoomTextLikeInBtn;
  late Animation fadeInBox;
  late Animation moveRightGroupIcon;
  late Animation pushIconLikeUp;
  late Animation zoomIconLike;

  // For short press btn
  late AnimationController animControlBtnShortPress;
  late Animation zoomIconLikeInBtn2, tiltIconLikeInBtn2;

  // For zoom icon when drag
  late AnimationController animControlIconWhenDrag;
  late AnimationController animControlIconWhenDragInside;
  late AnimationController animControlIconWhenDragOutside;
  late AnimationController animControlBoxWhenDragOutside;
  late Animation zoomIconChosen, zoomIconNotChosen;
  late Animation zoomIconWhenDragOutside;
  late Animation zoomIconWhenDragInside;
  late Animation zoomBoxWhenDragOutside;
  late Animation zoomBoxIcon;

  // For jump icon when release
  late AnimationController animControlIconWhenRelease;
  late Animation zoomIconWhenRelease, moveUpIconWhenRelease;
  late Animation moveLeftIconLikeWhenRelease,
      moveLeftIconLoveWhenRelease,
      moveLeftIconHahaWhenRelease,
      moveLeftIconWowWhenRelease,
      moveLeftIconSadWhenRelease,
      moveLeftIconAngryWhenRelease;

  Duration durationLongPress = const Duration(milliseconds: 250);
  late Timer holdTimer;
  late Timer holdTimer2;
  bool isLongPress = false;
  bool isLiked = false;

  int whichIconUserChoose = 0;

  int currentIconFocus = -1;
  int previousIconFocus = 0;
  bool isDragging = false;
  bool isDraggingOutside = false;
  bool isJustDragInside = true;

  @override
  void initState() {
    super.initState();

    // like btn
    _initAnimationBtnLike();

    // Box and Emoji
    _initAnimationBoxAndIcons();

    // Emoji when drag
    _initAnimationIconWhenDrag();

    // Emoji when drag outside
    _initAnimationIconWhenDragOutside();

    // Emoji when drag outside
    _initAnimationBoxWhenDragOutside();

    // Emoji when first drag
    _initAnimationIconWhenDragInside();

    // Emoji when release
    _initAnimationIconWhenRelease();
  }

  void _initAnimationBtnLike() {
    // long press
    animControlBtnLongPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnLongPress));
    zoomIconLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);
    tiltIconLikeInBtn =
        Tween(begin: 0.0, end: 0.2).animate(animControlBtnLongPress);
    zoomTextLikeInBtn =
        Tween(begin: 1.0, end: 0.85).animate(animControlBtnLongPress);

    zoomIconLikeInBtn.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn.addListener(() {
      setState(() {});
    });
    zoomTextLikeInBtn.addListener(() {
      setState(() {});
    });

    // short press
    animControlBtnShortPress = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationBtnShortPress));
    zoomIconLikeInBtn2 =
        Tween(begin: 1.0, end: 0.2).animate(animControlBtnShortPress);
    tiltIconLikeInBtn2 =
        Tween(begin: 0.0, end: 0.8).animate(animControlBtnShortPress);

    zoomIconLikeInBtn2.addListener(() {
      setState(() {});
    });
    tiltIconLikeInBtn2.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationBoxAndIcons() {
    animControlBox = AnimationController(
        vsync: this, duration: Duration(milliseconds: durationAnimationBox));

    // General
    moveRightGroupIcon = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 1.0)),
    );
    moveRightGroupIcon.addListener(() {
      setState(() {});
    });

    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.7, 1.0)),
    );
    fadeInBox.addListener(() {
      setState(() {});
    });

    // Emoji
    pushIconLikeUp = Tween(begin: 10.0, end: 15.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.5)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.5)),
    );

    pushIconLikeUp.addListener(() {
      setState(() {});
    });
    zoomIconLike.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationIconWhenDrag() {
    animControlIconWhenDrag = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));

    zoomIconChosen =
        Tween(begin: 1.0, end: 1.8).animate(animControlIconWhenDrag);
    zoomIconNotChosen =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDrag);
    zoomBoxIcon =
        Tween(begin: 50.0, end: 40.0).animate(animControlIconWhenDrag);

    zoomIconChosen.addListener(() {
      setState(() {});
    });
    zoomIconNotChosen.addListener(() {
      setState(() {});
    });
    zoomBoxIcon.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationIconWhenDragOutside() {
    animControlIconWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragOutside =
        Tween(begin: 0.8, end: 1.0).animate(animControlIconWhenDragOutside);
    zoomIconWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationBoxWhenDragOutside() {
    animControlBoxWhenDragOutside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomBoxWhenDragOutside =
        Tween(begin: 40.0, end: 50.0).animate(animControlBoxWhenDragOutside);
    zoomBoxWhenDragOutside.addListener(() {
      setState(() {});
    });
  }

  void _initAnimationIconWhenDragInside() {
    animControlIconWhenDragInside = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenDrag));
    zoomIconWhenDragInside =
        Tween(begin: 1.0, end: 0.8).animate(animControlIconWhenDragInside);
    zoomIconWhenDragInside.addListener(() {
      setState(() {});
    });
    animControlIconWhenDragInside.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isJustDragInside = false;
      }
    });
  }

  void _initAnimationIconWhenRelease() {
    animControlIconWhenRelease = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationAnimationIconWhenRelease));

    zoomIconWhenRelease = Tween(begin: 1.8, end: 0.0).animate(CurvedAnimation(
        parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveUpIconWhenRelease = Tween(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    moveLeftIconLikeWhenRelease = Tween(begin: 20.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconLoveWhenRelease = Tween(begin: 68.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconHahaWhenRelease = Tween(begin: 116.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconWowWhenRelease = Tween(begin: 164.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconSadWhenRelease = Tween(begin: 212.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));
    moveLeftIconAngryWhenRelease = Tween(begin: 260.0, end: 10.0).animate(
        CurvedAnimation(
            parent: animControlIconWhenRelease, curve: Curves.decelerate));

    zoomIconWhenRelease.addListener(() {
      setState(() {});
    });
    moveUpIconWhenRelease.addListener(() {
      setState(() {});
    });

    moveLeftIconLikeWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconLoveWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconHahaWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconWowWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconSadWhenRelease.addListener(() {
      setState(() {});
    });
    moveLeftIconAngryWhenRelease.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animControlBtnLongPress.dispose();
    animControlBox.dispose();
    animControlIconWhenDrag.dispose();
    animControlIconWhenDragInside.dispose();
    animControlIconWhenDragOutside.dispose();
    animControlBoxWhenDragOutside.dispose();
    animControlIconWhenRelease.dispose();
    animControlBtnShortPress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalDragEndBoxIcon,
      onHorizontalDragUpdate: _onHorizontalDragUpdateBoxIcon,
      onVerticalDragEnd: _onHorizontalDragEndBoxIcon,
      onVerticalDragUpdate: _onHorizontalDragUpdateBoxIcon,
      child: Portal(
        child: PortalTarget(
          visible: true,
          anchor: Aligned(
            follower: widget.portalAnchor,
            target: widget.childAnchor,
          ),
          portalFollower: Padding(
            padding: EdgeInsets.only(bottom: widget.spacing),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                if (reactions!.isNotEmpty) _backgroudBoxBuilder(),
                _reactionsBuilder(),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                Platform.isIOS ? 20 : 20, 0, Platform.isIOS ? 20 : 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _reactionButtonBuilder(),
                if (widget.isPostDetail != true)
                  checkDisability(
                      postId: widget.posts?.id,
                      userId: getStringAsync("user_id")),
                iconText(
                  mainAxisAlignment: MainAxisAlignment.center,
                  size: 18,
                  icon: CupertinoIcons.arrowshape_turn_up_right,
                  color: AppColors.postBottomColor,
                  text: translate(context, 'share').toString(),
                  press: () {
                    showModelBottomSheet(
                      colors: Theme.of(context).colorScheme.secondary,
                      context: context,
                      widget: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            bottomSheetTopDivider(
                                color: AppColors.primaryColor),
                            const SizedBox(height: 20),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showModelBottomSheet(
                                  colors:
                                      Theme.of(context).colorScheme.secondary,
                                  context: context,
                                  widget: CustomShare(
                                    post: widget.posts,
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey.withOpacity(0.1),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                  translate(context, 'share_on_timeline')
                                      .toString()),
                              subtitle: Text(
                                translate(context, 'share_on_your_timeline')
                                    .toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  isDismissible: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) =>
                                      GroupShare(posts: widget.posts),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    const Color(0xffffc928).withOpacity(0.15),
                                child: const Image(
                                  width: 16,
                                  image: AssetImage("assets/images/groups.png"),
                                ),
                              ),
                              title: Text(translate(context, 'share_on_group')
                                  .toString()),
                              subtitle: Text(
                                translate(
                                        context, 'share_on_your_joined_groups')
                                    .toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  isDismissible: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) =>
                                      PageShare(posts: widget.posts),
                                );
                              },
                              leading: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    const Color(0xff90caf8).withOpacity(0.15),
                                child: const Image(
                                  width: 16,
                                  image: AssetImage("assets/images/page.png"),
                                ),
                              ),
                              title: Text(translate(context, 'share_on_page')
                                  .toString()),
                              subtitle: Text(
                                translate(context, 'share_on_your_pages')
                                    .toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                // String url = LinkGenerator().createCustomLink(
                                //   AppRoutes.postDetails,
                                //   {"post_id": widget.posts!.id},
                                // );
                                Share.share(widget.posts!.postLink!);
                              },
                              leading: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey.withOpacity(0.1),
                                child: const Icon(
                                  LineIcons.paper_plane,
                                  color: Colors.green,
                                  size: 14,
                                ),
                              ),
                              title: Text(translate(context, 'more_options')
                                  .toString()),
                              subtitle: Text(
                                translate(context, 'share_on_other_platforms')
                                    .toString(),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkDisability({postId, userId, List<postModel.Posts>? list}) {
    if ((widget.posts?.commentsStatus == "1")) {
      return iconText(
        size: 18,
        icon: CupertinoIcons.bubble_left,
        color: AppColors.postBottomColor,
        text: translate(context, 'comments').toString(),
        press: () {
          commentBottomSheet(
            userId: widget.posts?.userId,
            colors: Theme.of(context).colorScheme.secondary,
            isMainPost: widget.isMainPosts,
            postId: widget.posts?.id,
            postIndex: widget.index,
            context: context,
            isPostDetail: widget.isPostDetail,
            isProfilePost: widget.isProfilePost,
            widget: CommentsPage(
              isPostDetail: widget.isPostDetail,
              isProfilePost: widget.isProfilePost,
              isMainPost: widget.isMainPosts,
              postid: widget.posts!.id,
              postIndex: widget.index,
            ),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  iconText(
      {text,
      icon,
      String? image,
      color = AppColors.postBottomColor,
      press,
      double angle = 0.0,
      double? size,
      mainAxisAlignment}) {
    return GestureDetector(
      onTap: press,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          if (image != null) ...[
            Image.asset(
              image,
              height: size,
            )
          ] else ...[
            Transform.rotate(
              angle: angle,
              child: Icon(
                icon,
                size: size,
                color: color,
              ),
            ),
          ],
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _backgroudBoxBuilder() {
    return Opacity(
      opacity: fadeInBox.value,
      child: Container(
        decoration: widget.containerDecoration ??
            BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: const Color(0xffe0e0e0),
                width: 0.3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
        width: widget.containerWidth,
        height: isDragging
            ? (previousIconFocus == 0 ? zoomBoxIcon.value : 40.0)
            : isDraggingOutside
                ? zoomBoxWhenDragOutside.value
                : 50.0,
        margin: const EdgeInsets.only(left: 10.0, bottom: 10.0),
      ),
    );
  }

  Widget _reactionsBuilder() {
    return Container(
      width: widget.containerWidth,
      margin: EdgeInsets.only(
        left: moveRightGroupIcon.value,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (int i = 0; i < reactions!.length; i++)
            Transform.scale(
              scale: isDragging
                  ? (currentIconFocus == i
                      ? zoomIconChosen.value
                      : (previousIconFocus == i
                          ? zoomIconNotChosen.value
                          : isJustDragInside
                              ? zoomIconWhenDragInside.value
                              : 0.8))
                  : isDraggingOutside
                      ? zoomIconWhenDragOutside.value
                      : zoomIconLike.value,
              child: Container(
                margin: EdgeInsets.only(bottom: pushIconLikeUp.value),
                width: 40.0,
                height: currentIconFocus == i ? 70.0 : 40.0,
                child: Column(
                  children: <Widget>[
                    currentIconFocus == i
                        ? Text(translate(context, reactions![i].header)!)
                        : Container(),
                    reactions![i].reaction,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  checkImage(postId, data) {
    for (var e in data) {
      if (e['postId'] == postId) {
        path = e['imagePath'];

        break;
      }
    }
    return path;
  }

  checkText(postId, data) {
    String text = "Like";
    for (var e in data) {
      if (e['postId'] == postId) {
        text = e['reactionText'];

        break;
      }
    }
    return text;
  }

  checkColor(postId, data) {
    Color textColor = AppColors.postBottomColor;
    for (var e in data) {
      if (e['postId'] == postId) {
        if (e["reactionText"] == "Like") {
          textColor = AppColors.postBottomColor;
        } else {
          textColor = e['reationColor'];
        }
        break;
      }
    }
    return textColor;
  }

  checkColor2(postId, data) {
    dynamic textColor = '';
    for (var e in data) {
      if (e['postId'] == postId) {
        if (e["reactionText"] == "Like") {
          textColor = AppColors.postBottomColor;
        }

        break;
      }
    }
    return textColor;
  }

  Widget _reactionButtonBuilder() {
    return GestureDetector(
      onTapDown: _onTapDownBtn,
      onTapUp: _onTapUpBtn,
      onTap: _onTapBtn,
      child: Row(
        children: [
          Transform.scale(
            scale: !isLongPress
                ? _handleOutputRangeZoomInIconLike(zoomIconLikeInBtn2.value)
                : zoomIconLikeInBtn.value,
            child: Transform.rotate(
              angle: !isLongPress
                  ? _handleOutputRangeTiltIconLike(tiltIconLikeInBtn2.value)
                  : tiltIconLikeInBtn.value,
              child: widget.posts!.reaction!.text != 'Like'
                  ? Image.asset(
                      widget.posts!.reaction!.image!,
                      height: 24.0,
                    )
                  : Image.asset(
                      widget.posts!.reaction!.image!,
                      color: AppColors.postBottomColor,
                      height: 24.0,
                    ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            translate(
                  context,
                  widget.posts!.reaction!.text!.toLowerCase(),
                ) ??
                '',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.postBottomColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onHorizontalDragEndBoxIcon(DragEndDetails dragEndDetail) {
    isDragging = false;
    isDraggingOutside = false;
    isJustDragInside = true;
    previousIconFocus = 0;
    currentIconFocus = 0;

    _onTapUpBtn(null);
  }

  void _onHorizontalDragUpdateBoxIcon(DragUpdateDetails dragUpdateDetail) {
    if (!isLongPress) return;
    if (dragUpdateDetail.localPosition.dy >= -100 &&
        dragUpdateDetail.localPosition.dy <= 100) {
      isDragging = true;
      isDraggingOutside = false;

      if (isJustDragInside && !animControlIconWhenDragInside.isAnimating) {
        animControlIconWhenDragInside.reset();
        animControlIconWhenDragInside.forward();
      }

      var a = widget.dragStart;
      var b = a + widget.dragSpace;

      for (int i = 1; i <= reactions!.length; i++) {
        if (dragUpdateDetail.globalPosition.dx >= a &&
            dragUpdateDetail.globalPosition.dx < b) {
          if (currentIconFocus != (i - 1)) {
            _handleWhenDragBetweenIcon(
              (i - 1),
            );
          }
        }

        a = b;
        b = a + widget.dragSpace;
      }
    } else {
      whichIconUserChoose = -1;
      previousIconFocus = -1;
      currentIconFocus = -1;
      isJustDragInside = true;

      if (isDragging && !isDraggingOutside) {
        isDragging = false;
        isDraggingOutside = true;
        animControlIconWhenDragOutside.reset();
        animControlIconWhenDragOutside.forward();
        animControlBoxWhenDragOutside.reset();
        animControlBoxWhenDragOutside.forward();
      }
    }
  }

  void _handleWhenDragBetweenIcon(int currentIcon) {
    whichIconUserChoose = currentIcon;
    previousIconFocus = currentIconFocus;
    currentIconFocus = currentIcon;
    animControlIconWhenDrag.reset();
    animControlIconWhenDrag.forward();
  }

  void _onTapDownBtn(TapDownDetails tapDownDetail) {
    holdTimer = Timer(durationLongPress, () {
      _showBox();
    });
  }

  void _onTapUpBtn(TapUpDetails? tapUpDetail) {
    if (isLongPress) {
      if (reactions!.isNotEmpty) {
        if (whichIconUserChoose == 0) {
          indexPath = 1;
          reactionTrigger(indexPath: indexPath);
        } else if (whichIconUserChoose == 1) {
          indexPath = 2;
          reactionTrigger(indexPath: indexPath);
        } else if (whichIconUserChoose == 2) {
          indexPath = 3;
          reactionTrigger(indexPath: indexPath);
        } else if (whichIconUserChoose == 3) {
          indexPath = 4;
          reactionTrigger(indexPath: indexPath);
        } else if (whichIconUserChoose == 4) {
          indexPath = 5;
          reactionTrigger(indexPath: indexPath);
        } else if (whichIconUserChoose == 5) {
          indexPath = 6;
          reactionTrigger(indexPath: indexPath);
        }
      }

      currentIconFocus = -1;
    }
    holdTimer2 = Timer(Duration(milliseconds: durationAnimationBox), () {
      isLongPress = false;
    });

    holdTimer.cancel();

    animControlBtnLongPress.reverse();

    _setReverseValue();
    animControlBox.reverse();

    animControlIconWhenRelease.reset();
    animControlIconWhenRelease.forward();
  }

  void _onTapBtn() {
    if (!isLongPress) {
      if (whichIconUserChoose == 0) {
        isLiked = !isLiked;
        whichIconUserChoose = 1;
      } else {
        whichIconUserChoose = 0;
      }
      if (isLiked) {
        animControlBtnShortPress.forward();
      } else {
        animControlBtnShortPress.reverse();
      }

      if (reactions!.isNotEmpty) {
        if (widget.posts?.reaction?.image != "assets/fbImages/ic_like.png") {
          indexPath = 0;
          reactionTrigger(indexPath: indexPath);
        } else {
          indexPath = 1;
          reactionTrigger(indexPath: indexPath);
        }
      }
    }
  }

  void reactionTrigger({required int indexPath}) {
    if (widget.isPostDetail == true) {
      context.read<PostDetailProvider>().setPostReactions(indexPath,
          index: widget.index, postId: widget.posts!.id, context: context);
    } else if (widget.isMainPosts == true) {
      context.read<PostProvider>().setPostReactions(indexPath,
          index: widget.index, postId: widget.posts!.id);
    } else if (widget.isProfilePost == true) {
      context.read<ProfilePostsProvider>().setPostReactions(indexPath,
          index: widget.index, posts: widget.posts!, context: context);
    } else if (widget.tempPost == true) {
      context.read<PostProviderTemp>().setPostReactions(indexPath,
          index: widget.index, postId: widget.posts!.id, context: context);
    }
  }

  double _handleOutputRangeZoomInIconLike(double value) {
    if (value >= 0.8) {
      return value;
    } else if (value >= 0.4) {
      return 1.6 - value;
    } else {
      return 0.8 + value;
    }
  }

  double _handleOutputRangeTiltIconLike(double value) {
    if (value <= 0.2) {
      return value;
    } else if (value <= 0.6) {
      return 0.4 - value;
    } else {
      return -(0.8 - value);
    }
  }

  void _showBox() {
    isLongPress = true;

    animControlBtnLongPress.forward();

    _setForwardValue();
    animControlBox.forward();
  }

  void _setReverseValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 10.0, end: 15.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, 1.0)),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.5, 1.0)),
    );
  }

  void _setForwardValue() {
    // Icons
    pushIconLikeUp = Tween(begin: 10.0, end: 15.0).animate(
      CurvedAnimation(
        parent: animControlBox,
        curve: const Interval(0.0, 0.5),
      ),
    );
    zoomIconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animControlBox,
        curve: const Interval(0.0, 0.5),
      ),
    );
  }
}
