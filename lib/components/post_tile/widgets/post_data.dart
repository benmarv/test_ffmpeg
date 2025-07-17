import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/post_tile/widgets/post_gridview.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_cache_netword_imge.dart';
import 'package:link_on/components/post_content.dart';
import 'package:link_on/models/posts.dart' as post;
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:rxdart/rxdart.dart';

class PostData extends StatefulWidget {
  const PostData({
    super.key,
    this.index,
    this.posts,
    this.shareInfo,
    this.isProfilePost = false,
    this.postDetailRoute,
  });
  final int? index;
  final post.Posts? posts;
  final bool? isProfilePost;
  final Widget? shareInfo;
  final void Function()? postDetailRoute;

  @override
  State<PostData> createState() => _PostDataState();
}

class _PostDataState extends State<PostData>
    with SingleTickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  late StreamController<DurationState> _durationStateController;
  StreamSubscription<DurationState>? _durationStateSubscription;
  TextStyle? _labelStyle;
  double? imageHeight;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    // final _postProvider = Provider.of<PostProvider>(context, listen: false);

    super.initState();
    audioPlayer = AudioPlayer();
    _durationStateController = StreamController<DurationState>.broadcast();

    if (widget.posts!.imageOrVideo == '3') {
      _initAudio();
    }
    // if (widget.isProfilePost == null || widget.isProfilePost == false) {
    //   if (_postProvider.postListProvider[widget.index!].video != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) => _getImageHeight());
    //   }
    // }
  }

  void _initAudio() async {
    _durationStateController = StreamController<DurationState>.broadcast();
    _durationStateSubscription =
        Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      audioPlayer.positionStream,
      audioPlayer.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    ).asBroadcastStream().listen((state) {
      _durationStateController.add(state);
    });

    if (widget.posts != null &&
        widget.posts!.sharedPost != null &&
        widget.posts!.audio == null) {
      await _loadAudio(
        widget.posts!.sharedPost!.audio!.mediaPath!,
        audioPlayer,
      );
    } else if (widget.posts != null &&
        widget.posts!.sharedPost == null &&
        widget.posts!.audio != null) {
      await _loadAudio(widget.posts!.audio!.mediaPath!, audioPlayer);
    }
  }

  Future<void> _loadAudio(String mediaPath, AudioPlayer player) async {
    final source = AudioSource.uri(Uri.parse(mediaPath));
    await player.setAudioSource(source);
    setState(() {});
  }

  double _selectedSpeed = 1.0; // Default speed
  bool _isRepeatEnabled = false; // Default repeat mode

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate(context, 'select_playback_speed')!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('0.5x'),
                onTap: () {
                  _updateSpeed(0.5);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('1.0x (Normal)'),
                onTap: () {
                  _updateSpeed(1.0);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('1.5x'),
                onTap: () {
                  _updateSpeed(1.5);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('2.0x'),
                onTap: () {
                  _updateSpeed(2.0);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateSpeed(double speed) {
    setState(() {
      _selectedSpeed = speed;

      audioPlayer.setSpeed(speed);
    });
  }

  void _getImageHeight() {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _profilePostProvider =
        Provider.of<ProfilePostsProvider>(context, listen: false);
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        imageHeight = renderBox.size.height;
        if (widget.isProfilePost == null || widget.isProfilePost == false) {
          _postProvider.postListProvider[widget.index!].videoHeight =
              imageHeight!;
        } else {
          _profilePostProvider.getProfilePostProviderList[widget.index!]
              .videoHeight = imageHeight!;
        }
      });
    }
  }

  void _getSharedImageHeight() {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _profilePostProvider =
        Provider.of<ProfilePostsProvider>(context, listen: false);
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        imageHeight = renderBox.size.height;
        if (widget.isProfilePost == null || widget.isProfilePost == false) {
          _postProvider.postListProvider[widget.index!].sharedPost!
              .videoHeight = imageHeight!;
        } else {
          _profilePostProvider.getProfilePostProviderList[widget.index!]
              .sharedPost!.videoHeight = imageHeight!;
        }
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _durationStateSubscription?.cancel();
    _durationStateController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _profilePostProvider =
        Provider.of<ProfilePostsProvider>(context, listen: false);
    return widget.posts?.imageOrVideo == '0'
        // only shared post text display
        ? widget.posts?.sharedPost != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.shareInfo!,
                      widget.posts!.sharedPost!.postText != null
                          ? PostContent(
                              data: widget.posts!.sharedPost!.postText,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              )
            : const SizedBox()
        : widget.posts?.imageOrVideo != '2'
            ? widget.posts?.imageOrVideo == '3'
                ? widget.posts?.sharedPost != null
                    // audio display
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.shareInfo!,
                              widget.posts!.sharedPost!.postText != null
                                  ? PostContent(
                                      data: widget.posts!.sharedPost!.postText,
                                    )
                                  : const SizedBox(),
                              VisibilityDetector(
                                key: ObjectKey(audioPlayer),
                                onVisibilityChanged:
                                    (VisibilityInfo visibility) {
                                  if (visibility.visibleFraction == 0 &&
                                      mounted) {
                                    audioPlayer.stop();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                        child: _progressBar(),
                                      ),
                                      _playButton(),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : VisibilityDetector(
                        key: ObjectKey(audioPlayer),
                        onVisibilityChanged: (VisibilityInfo visibility) {
                          if (visibility.visibleFraction == 0 && mounted) {
                            audioPlayer.stop();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.transparent),
                                child: _progressBar(),
                              ),
                              _playButton(),
                            ],
                          ),
                        ),
                      )
                // image display
                : widget.posts?.sharedPost != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.shareInfo!,
                              widget.posts!.sharedPost!.postText != null
                                  ? PostContent(
                                      data: widget.posts!.sharedPost!.postText,
                                    )
                                  : const SizedBox(),
                              if (widget.posts!.sharedPost!.images!.length >=
                                  2) ...[
                                GestureDetector(
                                  onTap: widget.postDetailRoute,
                                  child: PostGripView(
                                    photmulti: widget.posts!.sharedPost!.images,
                                  ),
                                )
                              ] else ...[
                                GestureDetector(
                                  onTap: widget.postDetailRoute,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.5, // Maximum height is 60% of screen
                                    ),
                                    child: CustomCachedNetworkImage(
                                      cover: BoxFit.cover,
                                      imageUrl: widget.posts?.sharedPost!
                                          .images![0].mediaPath,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: widget.postDetailRoute,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.5, // Maximum height is 60% of screen
                          ),
                          child: CustomCachedNetworkImage(
                            cover: BoxFit.cover,
                            imageUrl: widget.posts?.images![0].mediaPath,
                          ),
                        ),
                      )

            // video display
            : widget.posts?.sharedPost != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.shareInfo!,
                          widget.posts!.sharedPost!.postText != null
                              ? PostContent(
                                  data: widget.posts!.sharedPost!.postText,
                                )
                              : const SizedBox(),
                          Consumer<InitializePostVideoProvider>(
                            builder: (context, value, child) {
                              return value.initializePostVideoDataList
                                          .asMap()
                                          .containsKey(widget.index) ==
                                      false
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : value.initializePostVideoDataList.isEmpty
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : value.initializePostVideoDataList[
                                                  widget.index!]["data"] ==
                                              null
                                          ? Center(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minHeight: 200,
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.7,
                                                ),
                                                child: value.loading == true
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      )
                                                    : Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          ColoredBox(
                                                            color: Colors.black,
                                                            child:
                                                                CustomCachedNetworkImage(
                                                              imageUrl: widget
                                                                  .posts!
                                                                  .sharedPost
                                                                  ?.videoThumbnail,
                                                              cover: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            right: 0,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _getSharedImageHeight();
                                                                if (value.initializePostVideoDataList[
                                                                            widget.index!]
                                                                        [
                                                                        "flag"] ==
                                                                    1) {
                                                                  value.initPostVideo(
                                                                      index: widget
                                                                          .index,
                                                                      url: widget
                                                                          .posts!
                                                                          .sharedPost
                                                                          ?.video!
                                                                          .mediaPath
                                                                          .toString());
                                                                } else {
                                                                  value.initializeAgain(
                                                                      index: widget
                                                                          .index,
                                                                      url: widget
                                                                          .posts!
                                                                          .sharedPost
                                                                          ?.video!
                                                                          .mediaPath);
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 55,
                                                                width: 55,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white60,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  size: 29,
                                                                  shadows: [
                                                                    Shadow(
                                                                        offset: Offset(
                                                                            0.5,
                                                                            0.8))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            )
                                          : Center(
                                              child: SizedBox(
                                                height: widget.isProfilePost ==
                                                            null ||
                                                        widget.isProfilePost ==
                                                            false
                                                    ? _postProvider
                                                        .postListProvider[
                                                            widget.index!]
                                                        .sharedPost!
                                                        .videoHeight
                                                    : _profilePostProvider
                                                        .getProfilePostProviderList[
                                                            widget.index!]
                                                        .sharedPost!
                                                        .videoHeight,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: VisibilityDetector(
                                                        key: ObjectKey(
                                                            value.initializePostVideoDataList[
                                                                    widget
                                                                        .index!]
                                                                ["data"]),
                                                        onVisibilityChanged:
                                                            (visibility) {
                                                          if (visibility
                                                                      .visibleFraction ==
                                                                  0 &&
                                                              mounted) {
                                                            value
                                                                .initializePostVideoDataList[
                                                                    widget
                                                                        .index!]
                                                                    ["data"]
                                                                .flickControlManager
                                                                ?.pause();
                                                          }
                                                        },
                                                        child: ClipRRect(
                                                          child: AspectRatio(
                                                            aspectRatio: 16 / 9,
                                                            child:
                                                                FlickVideoPlayer(
                                                                    flickVideoWithControlsFullscreen:
                                                                        const FlickVideoWithControls(
                                                                      controls:
                                                                          FlickLandscapeControls(),
                                                                    ),
                                                                    flickVideoWithControls:
                                                                        FlickVideoWithControls(
                                                                      videoFit:
                                                                          BoxFit
                                                                              .cover,
                                                                      controls:
                                                                          FlickPortraitControls(
                                                                        progressBarSettings:
                                                                            FlickProgressBarSettings(playedColor: AppColors.primaryColor),
                                                                      ),
                                                                    ),
                                                                    flickManager:
                                                                        value.initializePostVideoDataList[widget.index!]
                                                                            [
                                                                            "data"]),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Consumer<InitializePostVideoProvider>(
                    builder: (context, value, child) {
                      return value.initializePostVideoDataList
                                  .asMap()
                                  .containsKey(widget.index) ==
                              false
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : value.initializePostVideoDataList.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : value.initializePostVideoDataList[widget.index!]
                                          ["data"] ==
                                      null
                                  ? Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: 200,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                        ),
                                        child: value.loading == true
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.primaryColor,
                                                ),
                                              )
                                            : Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ColoredBox(
                                                    color: Colors.black,
                                                    child: Container(
                                                      key: _imageKey,
                                                      child:
                                                          CustomCachedNetworkImage(
                                                        imageUrl: widget.posts
                                                            ?.videoThumbnail,
                                                        cover: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        _getImageHeight();

                                                        if (value.initializePostVideoDataList[
                                                                    widget
                                                                        .index!]
                                                                ["flag"] ==
                                                            1) {
                                                          value.initPostVideo(
                                                              index:
                                                                  widget.index,
                                                              url: widget
                                                                  .posts
                                                                  ?.video!
                                                                  .mediaPath);
                                                        } else {
                                                          value.initializeAgain(
                                                              index:
                                                                  widget.index,
                                                              url: widget
                                                                  .posts
                                                                  ?.video!
                                                                  .mediaPath);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        width: 55,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white60,
                                                        ),
                                                        child: const Icon(
                                                          Icons.play_arrow,
                                                          size: 29,
                                                          shadows: [
                                                            Shadow(
                                                              offset: Offset(
                                                                0.5,
                                                                0.8,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    )
                                  : Center(
                                      child: SizedBox(
                                        height: widget.isProfilePost == null ||
                                                widget.isProfilePost == false
                                            ? _postProvider
                                                .postListProvider[widget.index!]
                                                .videoHeight
                                            : _profilePostProvider
                                                .getProfilePostProviderList[
                                                    widget.index!]
                                                .videoHeight,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: VisibilityDetector(
                                                key: ObjectKey(value
                                                        .initializePostVideoDataList[
                                                    widget.index!]["data"]),
                                                onVisibilityChanged:
                                                    (visibility) {
                                                  if (visibility
                                                              .visibleFraction ==
                                                          0 &&
                                                      mounted) {
                                                    value
                                                        .initializePostVideoDataList[
                                                            widget.index!]
                                                            ["data"]
                                                        .flickControlManager
                                                        ?.pause();
                                                  }
                                                },
                                                child: ClipRRect(
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: FlickVideoPlayer(
                                                        flickVideoWithControlsFullscreen:
                                                            const FlickVideoWithControls(
                                                          controls:
                                                              FlickLandscapeControls(),
                                                        ),
                                                        flickVideoWithControls:
                                                            FlickVideoWithControls(
                                                          videoFit:
                                                              BoxFit.cover,
                                                          controls:
                                                              FlickPortraitControls(
                                                            progressBarSettings:
                                                                FlickProgressBarSettings(
                                                              playedColor: AppColors
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        flickManager:
                                                            value.initializePostVideoDataList[
                                                                    widget
                                                                        .index!]
                                                                ["data"]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                    },
                  );
  }

  StreamBuilder<DurationState> _progressBar() {
    final controller = _durationStateController;
    return StreamBuilder<DurationState>(
      stream: controller.stream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: (duration) {
            audioPlayer.seek(duration);
          },
          onDragUpdate: (details) {
            debugPrint(
                'Debug priny dta ${details.timeStamp}, ${details.localPosition}');
          },
          baseBarColor: Colors.grey,
          progressBarColor: AppColors.primaryColor,
          bufferedBarColor: AppColors.lightgreen,
          thumbColor: AppColors.primaryColor,
          thumbGlowColor: AppColors.lightgreen,
          timeLabelTextStyle: _labelStyle,
        );
      },
    );
  }

  StreamBuilder<PlayerState> _playButton() {
    final player = audioPlayer;
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        print("Player Statess ${snapshot.data?.playing}");
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_isRepeatEnabled ? Icons.repeat_one : Icons.repeat),
                iconSize: 32.0,
                onPressed: () {
                  setState(() {
                    _isRepeatEnabled = !_isRepeatEnabled;

                    audioPlayer.setLoopMode(
                        _isRepeatEnabled ? LoopMode.one : LoopMode.off);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds - 5));
                },
              ),
              IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 32.0,
                  onPressed: audioPlayer.play),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds + 5));
                },
              ),
              TextButton(
                  onPressed: () {
                    _showSpeedDialog();
                  },
                  child: Text(
                    "${_selectedSpeed}X",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        } else if (processingState != ProcessingState.completed) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_isRepeatEnabled ? Icons.repeat_one : Icons.repeat),
                iconSize: 32.0,
                onPressed: () {
                  setState(() {
                    _isRepeatEnabled = !_isRepeatEnabled;

                    audioPlayer.setLoopMode(
                        _isRepeatEnabled ? LoopMode.one : LoopMode.off);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds - 5));
                },
              ),
              IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 32.0,
                  onPressed: audioPlayer.pause),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds + 5));
                },
              ),
              TextButton(
                  onPressed: () {
                    _showSpeedDialog();
                  },
                  child: Text(
                    "${_selectedSpeed}X",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_isRepeatEnabled ? Icons.repeat_one : Icons.repeat),
                iconSize: 32.0,
                onPressed: () {
                  setState(() {
                    _isRepeatEnabled = !_isRepeatEnabled;

                    audioPlayer.setLoopMode(
                        _isRepeatEnabled ? LoopMode.one : LoopMode.off);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds - 5));
                },
              ),
              IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 32.0,
                  onPressed: () => audioPlayer.seek(Duration.zero)),
              IconButton(
                icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                iconSize: 32.0,
                onPressed: () {
                  audioPlayer.seek(
                      Duration(seconds: audioPlayer.position.inSeconds + 5));
                },
              ),
              TextButton(
                  onPressed: () {
                    _showSpeedDialog();
                  },
                  child: Text(
                    "${_selectedSpeed}X",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        }
      },
    );
  }
}
