import 'package:flutter/material.dart';
import 'package:link_on/controllers/SavePostProvider/save_post_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/post_details/post_details.page.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:video_player/video_player.dart';

class SavedPostList extends StatefulWidget {
  const SavedPostList({super.key, this.post, this.index});

  final Posts? post;
  final int? index;
  @override
  State<SavedPostList> createState() => _SavedPostListState();
}

class _SavedPostListState extends State<SavedPostList> {
  VideoPlayerController? _videoPlayerController;
  Future<void> initializeVideoPlayer() async {
    if (widget.post!.video == null && widget.post!.sharedPost!.video != null) {
      _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.post!.sharedPost!.video!.mediaPath.toString()));
    } else {
      _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.post!.video!.mediaPath.toString()));
    }

    await Future.wait([_videoPlayerController!.initialize()]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVideoPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * .45,
        // height: 225,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsPage(
                      index: widget.index,
                      postid: widget.post!.id,
                    ),
                  ),
                );
              },
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.post?.sharedPost == null
                        ? Container(
                            height: 140,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0)),
                            ),
                            child: widget.post!.product != null
                                ? Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(widget
                                              .post!.product!.images[0].image
                                              .toString()),
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : widget.post!.event != null
                                    ? Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              image: NetworkImage(widget
                                                  .post!.event!.cover!
                                                  .toString()),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : widget.post!.imageOrVideo == '2'
                                        ? Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                            child: VideoPlayer(
                                              _videoPlayerController!,
                                            ),
                                          )
                                        : widget.post!.imageOrVideo == '3'
                                            ? const SizedBox(
                                                height: 140,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Icon(
                                                        Icons.volume_up,
                                                        size: 60,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : widget.post!.images != null
                                                ? Container(
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              widget
                                                                  .post!
                                                                  .images![0]
                                                                  .mediaPath
                                                                  .toString()),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  )
                                                : widget.post!.postType
                                                            .toString() ==
                                                        "offer"
                                                    ? Container(
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  widget.post!
                                                                      .offer
                                                                      .toString()),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 140,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Icon(
                                                                Icons
                                                                    .text_format,
                                                                size: 60,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                        : Container(
                            height: 140,
                            decoration: const BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0)),
                            ),
                            child: widget.post!.sharedPost!.product != null
                                ? Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(widget
                                              .post!
                                              .sharedPost!
                                              .product!
                                              .images[0]
                                              .image
                                              .toString()),
                                          fit: BoxFit.cover),
                                    ),
                                  )
                                : widget.post!.sharedPost!.event != null
                                    ? Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              image: NetworkImage(widget.post!
                                                  .sharedPost!.event!.cover!
                                                  .toString()),
                                              fit: BoxFit.cover),
                                        ),
                                      )
                                    : widget.post!.sharedPost!.imageOrVideo ==
                                            '2'
                                        ? Container(
                                            height: 140,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300),
                                            child: VideoPlayer(
                                              _videoPlayerController!,
                                            ),
                                          )
                                        : widget.post!.sharedPost!
                                                    .imageOrVideo ==
                                                '3'
                                            ? const SizedBox(
                                                height: 140,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Icon(
                                                        Icons.volume_up,
                                                        size: 60,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : widget.post!.sharedPost!.images !=
                                                    null
                                                ? Container(
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              widget
                                                                  .post!
                                                                  .sharedPost!
                                                                  .images![0]
                                                                  .mediaPath
                                                                  .toString()),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  )
                                                : widget.post!.sharedPost!
                                                            .postType
                                                            .toString() ==
                                                        "offer"
                                                    ? Container(
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  widget
                                                                      .post!
                                                                      .sharedPost!
                                                                      .offer
                                                                      .toString()),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      )
                                                    : const SizedBox(
                                                        height: 140,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Icon(
                                                                Icons
                                                                    .text_format,
                                                                size: 60,
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (widget.post!.user!.firstName != null &&
                                              widget.post!.user!.lastName !=
                                                  null) &&
                                          (widget.post!.user!.firstName != "" &&
                                              widget.post!.user!.lastName != "")
                                      ? "${widget.post!.user!.firstName!} ${widget.post!.user!.lastName!}"
                                      : widget.post!.user!.username.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                widget.post!.product != null
                                    ? Text(
                                        translate(context, 'product')
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : widget.post!.event != null
                                        ? Text(
                                            translate(context, 'events')
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Text(
                                            widget.post!.postType.toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
                                          ),
                                const SizedBox(
                                  height: 3,
                                ),
                                if (widget.post!.postText != null &&
                                    widget.post!.postText != " ")
                                  Text(
                                    widget.post!.postText.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Center(
                    child: InkWell(
                  onTap: () {
                    Provider.of<SaveProvider>(context, listen: false)
                        .deleteSavePost(
                            index: widget.index,
                            post: widget.post!,
                            context: context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.bookmark,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
