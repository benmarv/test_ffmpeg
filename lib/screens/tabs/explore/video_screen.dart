// ignore_for_file: use_build_context_synchronously
import 'dart:developer' as dev;
import 'dart:async';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:link_on/components/save_post/global_save_post_id.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/controllers/videolike/video_like_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/comments/comments.page.dart';
import 'package:link_on/screens/comments/widgets/comment_bottom.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/tabs/profile/report_user.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_cache_netword_imge.dart';
import 'package:link_on/models/posts.dart' as postModel;
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'dart:math' as math;

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.posts,
    required this.allGifts,
    this.currentIndex,
  });
  final postModel.Posts? posts;
  final int? currentIndex;
  final List<Gifts> allGifts;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late CachedVideoPlayerPlusController videoPlayerController;
  double downloadProgress = 0.0;
  @override
  initState() {
    funtion();
    super.initState();
  }

  Future funtion() async {
    var provider = Provider.of<VideoPlayerProvider>(context, listen: false);
    if (mounted) {
      provider.controller = CachedVideoPlayerPlusController.networkUrl(
        invalidateCacheIfOlderThan: const Duration(days: 1),
        Uri.parse(widget.posts!.video!.mediaPath!),
      );
      videoPlayerController = provider.controller!;
      videoPlayerController.initialize().then((value) {
        videoPlayerController.play();
        setState(() {});
      }).catchError((e) {
        dev.log("logical error has throne $e");
      });
      videoPlayerController.setLooping(true);
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    disposeController();
    super.dispose();
  }

  void disposeController() {
    final pro = Provider.of<VideoPlayerProvider>(context, listen: false);
    // Access the VideoPlayerProvider instance
    pro.controller!.dispose();
    // Dispose of the video player controller
    // pro.disposeController();
  }

  Future<void> savepost() async {
    dynamic res = await apiClient.save_post(postid: widget.posts!.id!);
    if (res['code'] == '200') {
      if (res["type"] == 0) {
        widget.posts!.isSaved = false;
        savePostMap[widget.posts!.id!] = "unsave";
        setState(() {});
      } else if (res["type"] == 1) {
        widget.posts!.isSaved = true;
        savePostMap[widget.posts!.id!] = "save";
        setState(() {});
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['errors']['error_text']}'),
        backgroundColor: Colors.red.shade300,
      ));
      Navigator.pop(context);
    }
  }

  Future<void> saveVideo() async {
    final tempdir = await getTemporaryDirectory();
    final path = '${tempdir.path}/video';

    Navigator.pop(context);

    try {
      await dioService.dio.download(
        widget.posts!.video!.mediaPath!,
        path,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = (count / total);
              toast(
                  '${translate(context, 'downloading')} ${(downloadProgress * 100).toStringAsFixed(0)}%');
            });
          }
        },
      );

      toast(translate(context, 'saving'));

      await GallerySaver.saveVideo(widget.posts!.video!.mediaPath!,
          albumName: "LinkOn");
      toast(translate(context, 'download_completed'));
    } catch (e) {
      toast(translate(context, 'failed_to_download'));
      dev.log('video saving error $e');
      Navigator.pop(context);
    }
  }

  Widget reactedIcon({saveData, postId}) {
    var reacted;
    for (var i in saveData) {
      if (postId == i["postId"]) {
        reacted = i["isReacted"];
        break;
      }
    }
    return Icon(
      reacted == true ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
      size: 30,
      color: reacted == true ? Colors.red : Colors.white,
    );
  }

  String checkCount(postId, data) {
    dynamic count = widget.posts?.reaction?.count;
    for (var e in data) {
      if (e['postId'] == postId) {
        count = e['count'];
        break;
      }
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Size videoSize = videoPlayerController.value.size;
    return Consumer<VideoPlayerProvider>(
        builder: (context, provider, child) => Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                if (videoPlayerController.value.isInitialized == true &&
                    provider.controller != null)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTap: () {
                          provider.playPause();
                        },
                        child: Container(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth /
                              (videoPlayerController.value.isInitialized
                                  ? videoPlayerController.value.aspectRatio
                                  : 16 / 9),
                          child: CachedVideoPlayerPlus(videoPlayerController),
                        ),
                      );
                    },
                  )
                else
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            funtion();
                          },
                          child: CustomCachedNetworkImage(
                            imageUrl: widget.posts?.videoThumbnail,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (videoPlayerController.value.isPlaying == false &&
                    videoPlayerController.value.isInitialized == true)
                  Center(
                    child: InkWell(
                      onTap: () {
                        provider.play();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                if (videoPlayerController.value.isInitialized == false)
                  const Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      minHeight: 1,
                      color: AppColors.primaryColor,
                    ),
                  )
                else if (videoPlayerController.value.isInitialized == true)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(
                      videoPlayerController,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: AppColors.primaryColor,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (widget.posts != null) ...[
                  _rightSideButtonsWidgets(),
                  _textDataWidgetBottom()
                ]
              ],
            ));
  }

  String formatCount(String countString) {
    int count = int.tryParse(countString) ?? 0;
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }

  Widget _rightSideButtonsWidgets() {
    return Positioned(
      right: 15,
      bottom: 40,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        context: context,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        builder: (context) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    bottomSheetTopDivider(
                                        color: AppColors.primaryColor),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      translate(context, "send_gifts")
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: widget.allGifts.length,
                                        itemBuilder: (context, giftIndex) {
                                          return GestureDetector(
                                            onTap: () {
                                              Provider.of<LiveStreamProvider>(
                                                      context,
                                                      listen: false)
                                                  .sendGift(
                                                      context: context,
                                                      giftId: widget
                                                          .allGifts[giftIndex]
                                                          .id!,
                                                      hostUserId:
                                                          widget.posts!.userId!,
                                                      giftUrl: widget
                                                          .allGifts[giftIndex]
                                                          .lottie_animation!)
                                                  .then((value) {
                                                // if (value!) {
                                                // _sendGiftToHost(giftIndex);
                                                // }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,

                                                // mainAxisSize:
                                                //     MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            Colors.grey[300]),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image(
                                                        image: NetworkImage(
                                                            widget
                                                                .allGifts[
                                                                    giftIndex]
                                                                .image!),
                                                        fit: BoxFit.cover,
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    widget.allGifts[giftIndex]
                                                        .name!,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "\$${widget.allGifts[giftIndex].price!}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ]));
                        },
                      );
                    },
                    child: Image(
                        image: AssetImage("assets/icons/gift.png"),
                        height: 40)),
                const SizedBox(height: 15),
                Consumer<VideosLikeProvider>(builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      if (widget.posts!.id ==
                          value.saveData[widget.currentIndex!]["postId"]) {
                        if (value.saveData[widget.currentIndex!]["isReacted"] ==
                            true) {
                          value.setVideoiLikeProvider(0,
                              id: widget.posts!.id,
                              context: context,
                              index: widget.currentIndex);
                        } else if (value.saveData[widget.currentIndex!]
                                ["isReacted"] ==
                            false) {
                          value.setVideoiLikeProvider(2,
                              id: widget.posts!.id,
                              context: context,
                              index: widget.currentIndex);
                        }
                      }
                    },
                    child: (reactedIcon(
                        postId: widget.posts!.id, saveData: value.saveData)),
                  );
                }),
                const SizedBox(height: 3),
                Consumer<VideosLikeProvider>(builder: (context, value, child) {
                  return Text(
                    formatCount(checkCount(widget.posts?.id, value.saveData)),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  );
                })
              ],
            ),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    commentBottomSheet(
                      userId: widget.posts?.userId,
                      colors: Theme.of(context).colorScheme.secondary,
                      context: context,
                      postId: widget.posts?.id,
                      postIndex: widget.currentIndex,
                      isVideoPost: true,
                      widget: CommentsPage(
                        isProfilePost: false,
                        isVideoScreen: true,
                        postid: widget.posts!.id,
                        postIndex: widget.currentIndex,
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Adjust the shape as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      // This is the SVG image layer
                      SvgPicture.asset(
                        'assets/images/comment-white.svg',
                        height: 36,
                        width: 36,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                widget.posts!.commentCount == '0'
                    ? const SizedBox.shrink()
                    : Consumer<MainCommentsProvider>(
                        builder: (context, value, child) {
                        return Text(
                          formatCount(widget.posts!.commentCount!),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        );
                      })
              ],
            ),
            InkWell(
              onTap: () {
                Share.share(widget.posts!.postLink.toString());
              },
              child: Icon(CupertinoIcons.paperplane,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ],
                  color: Colors.white,
                  size: 25),
            ),
            InkWell(
              onTap: () {
                _dwonBottomSheet(context);
              },
              child: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: Icon(Icons.more_horiz,
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ],
                    color: Colors.white,
                    size: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textDataWidgetBottom() {
    return Positioned(
      bottom: 30,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              videoPlayerController.pause();
              Navigator.of(context).pushNamed(
                AppRoutes.profile,
                arguments: widget.posts!.user!.id,
              );
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.posts!.user!.avatar.toString(),
                          ),
                          fit: BoxFit.contain),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${widget.posts!.user!.username}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    4.sw,
                    widget.posts!.user!.isVerified == "1"
                        ? const SizedBox(
                            height: 12,
                            width: 12,
                            child: Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.posts!.postText != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: MediaQuery.sizeOf(context).width * .75,
                  child: ReadMoreText(
                    "${widget.posts!.postText}",
                    trimLines: 1,
                    trimLength: 70,
                    style: const TextStyle(
                        color: Colors.white,
                        textBaseline: TextBaseline.alphabetic,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    colorClickableText: Colors.white70,
                    trimCollapsedText: ' ...',
                    trimExpandedText: '... ${translate(context, 'show_less')}',
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _dwonBottomSheet(context) {
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        context: context,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        builder: (BuildContext bc) {
          return Container(
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getStringAsync("user_id") == widget.posts!.userId
                        ? const SizedBox.shrink()
                        : ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.report,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: Consumer<RandomVideoProvider>(
                                builder: (context, value, child) {
                              return Text(
                                translate(context, 'report')!,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportUser(
                                    postid: widget.posts!.id,
                                  ),
                                ),
                              );
                            }),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.download,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      title: Text(
                        translate(context, 'download')!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () => saveVideo(),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.bookmark,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      title: Text(
                        savePostMap.containsKey(widget.posts!.id)
                            ? (savePostMap[widget.posts!.id] == "save"
                                ? translate(context, 'unsave_video')!
                                : translate(context, 'save_video')!)
                            : (widget.posts!.isSaved == false
                                ? translate(context, 'save_video')!
                                : translate(context, 'unsave_video')!),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      onTap: () => savepost(),
                    ),
                  ],
                ),
              ));
        });
  }

  Future reportDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(translate(context, 'report')!),
          content: Text(translate(context, 'report_confirmation')!),
          actions: [
            CupertinoDialogAction(
              onPressed: () async => await context
                  .read<RandomVideoProvider>()
                  .reportPost(
                      postId: widget.posts?.id,
                      context: context,
                      index: widget.currentIndex)
                  .then((value) {
                context.pop();
              }),
              child: Text(
                translate(context, 'report_action')!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => context.pop(),
              child: Text(
                translate(context, 'go_back')!,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }
}
