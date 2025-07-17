// ignore_for_file: library_private_types_in_public_api

import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/PostSkeleton/videoshimmer.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/post_details/post_details.page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPosts extends StatefulWidget {
  final dynamic userId;
  final ScrollController? controller;
  const VideoPosts({
    this.userId,
    this.controller,
    Key? key,
  }) : super(key: key);
  @override
  _VideoPostsState createState() => _VideoPostsState();
}

class _VideoPostsState extends State<VideoPosts> {
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> mapData = {
      'user_id': widget.userId ?? getStringAsync("user_id"),
      "limit": 6,
      "post_type": "2"
    };
    ProfilePostsProvider profilePostsProvider =
        Provider.of<ProfilePostsProvider>(context, listen: false);
    if (profilePostsProvider.getProfileVideos.isEmpty &&
        profilePostsProvider.loading == false) {
      profilePostsProvider.getUsersPosts(context: context, mapData: mapData);
    }
    widget.controller?.addListener(() {
      var postId = profilePostsProvider
          .getProfileVideos[profilePostsProvider.getProfileVideos.length - 1]
          .id;
      Map<String, dynamic> mapData2 = {
        'user_id': widget.userId ?? getStringAsync("user_id"),
        "limit": 6,
        "last_post_id": postId,
        "post_type": "2"
      };
      if ((widget.controller?.position.maxScrollExtent ==
              widget.controller?.position.pixels) &&
          profilePostsProvider.loading == false) {
        profilePostsProvider.getUsersPosts(mapData: mapData2, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(builder: (context, value, child) {
      return (value.loading == true && value.getProfileVideos.isEmpty)
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return VideoShimmer(
                  key: widget.key,
                );
              },
            )
          : (value.loading == false && value.getProfileVideos.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(
                      translate(context, 'no_data_found')!,
                    ),
                  ],
                )
              : SingleChildScrollView(
                  // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * .012,
                        vertical: 5),
                    child: Wrap(
                      spacing: MediaQuery.sizeOf(context).width * .014,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      children: [
                        for (int i = 0; i < value.getProfileVideos.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostDetailsPage(
                                              index: i,
                                              postid:
                                                  value.getProfileVideos[i].id,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width:
                                        MediaQuery.sizeOf(context).width * .31,
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                    ),
                                    child: VideoPlay(
                                      data: value
                                          .getProfileVideos[i].video!.mediaPath,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(
                                        Icons.play_arrow_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
    });
  }
}

class VideoPlay extends StatefulWidget {
  final String? data;
  const VideoPlay({super.key, this.data});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.data.toString()));
    controller!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(controller!);
  }
}
  // for (int i = 0;
  //                           i < value.getProfileVideos.length;
  //                           i++)
  //                         if (value.getProfileVideos[i].postFile
  //                                     ?.endsWith(".mp4") ==
  //                                 true ||
  //                             value.getProfileVideos[i].postFile
  //                                     ?.endsWith(".mov") ==
  //                                 true) ...[
  //                           Padding(
  //                             padding: const EdgeInsets.symmetric(vertical: 3),
  //                             child: InkWell(
  //                               onTap: () {
  //                                 Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                         builder: (context) => PostDetailsPage(
  //                                               index: i,
  //                                               postid: value
  //                                                   .getProfileVideos[
  //                                                       i]
  //                                                   .postId,
  //                                             )));
  //                               },
  //                               child: Stack(
  //                                 children: [
  //                                   Container(
  //                                     height: 150,
  //                                     width: MediaQuery.sizeOf(context).width *
  //                                         .31,
  //                                     decoration: const BoxDecoration(
  //                                       color: Colors.white70,
  //                                     ),
  //                                     child: VideoPlay(
  //                                       data: value
  //                                           .getProfileVideos[i]
  //                                           .postFile,
  //                                     ),
  //                                   ),
  //                                   Positioned(
  //                                       bottom: 10,
  //                                       right: 10,
  //                                       child: Container(
  //                                         child: const Icon(
  //                                           Icons.play_arrow_outlined,
  //                                           color: Colors.white,
  //                                         ),
  //                                       ))
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ]