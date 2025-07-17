// cc@rufusopdev
import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:link_on/screens/camera/Sticker.dart';
import 'package:link_on/screens/camera/adjustments_screen.dart';
import 'package:link_on/screens/camera/audio_adjustments_screen.dart';
import 'package:link_on/screens/camera/effects_video.dart';
import 'package:link_on/screens/camera/speed_adjustment_screen.dart';
import 'package:link_on/screens/camera/text_video.dart';
import 'package:link_on/screens/camera/trim_video.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/createstory/create_story.dart';
import 'package:link_on/screens/music/main_music_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'crop_video.dart';

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen(
      {Key? key,
      this.postVideo,
      this.thumbNail,
      this.sound,
      this.soundId,
      this.isFromStory = false})
      : super(key: key);
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final bool? isFromStory;
  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
  FFmpegSession? session;
  VideoEditorController? _controller;

  Future<void> _pickVideo() async {
    if (mounted && widget.postVideo != null) {
      _controller = VideoEditorController.file(
        File(widget.postVideo!),
        minDuration: const Duration(seconds: 1),
        maxDuration: const Duration(seconds: 30),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    log("video thumbnail : ${widget.thumbNail} video is from story : ${widget.isFromStory}");
    log("video path : ${widget.postVideo}");
    _pickVideo().then((value) => _controller
            ?.initialize()
            .then((_) => setState(() {}))
            .catchError((error) {
          Navigator.pop(context);
        }, test: (e) => e is VideoMinDurationError));
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller?.dispose();
    session!.cancel();
    super.dispose();
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 30),
                    Text(
                      'Processing video, please do not lock the screen or leave the app',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _hideProgressDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void reverseVideo() async {
    _controller!.video.pause();
    _showProgressDialog(context);
    try {
      String f = await _findLocalPath();
      String videoPath =
          '$f/${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.mp4';

      String ffmpegCommand =
          '-y -i ${widget.postVideo} -vf reverse -af areverse -c:v libx264 -crf 18 -preset veryfast -c:a aac -b:a 128k $videoPath';

      session = await FFmpegKit.execute(ffmpegCommand);

      final returnCode = await session!.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        log("FFmpeg command executed successfully.");
      } else if (ReturnCode.isCancel(returnCode)) {
        log("FFmpeg command was cancelled.");
      } else {
        log("FFmpeg command failed with error.");
      }

      _hideProgressDialog(context);

      await session!.getAllLogs().then((logs) {
        // log(logs.iterator);
        logs.clear();
      });

      await session!.getOutput().then((output) {
        log("ffmpeg output : $output");
      });

      await session!.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoEditorScreen(
            postVideo: videoPath,
            thumbNail: widget.thumbNail,
            isFromStory: widget.isFromStory,
            sound: widget.sound,
            soundId: widget.soundId,
          ),
        ),
      );
    } catch (e) {
      log("Error during video processing: $e");
      Navigator.of(context).pop();
    }
  }

  void getVideoThumbnail({required String videoPath}) async {
    await _controller?.dispose();
    String f = await _findLocalPath();

    FFmpegKit.execute(
            '-i $videoPath -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
        .then(
      (returnCode) async {
        await returnCode.cancel();
        if (widget.isFromStory!) {
          int videoDuration = _controller!.video.value.duration.inSeconds;
          print('video path : $videoPath duration : $videoDuration');

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateStory(
                        videopath: videoPath,
                        videoThumbnail:
                            "$f${Platform.pathSeparator}thumbNail.png",
                        videoDuration: double.parse(videoDuration.toString()),
                      )));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(
                videopath: videoPath,
                flag: true,
                videoThumbnail: "$f${Platform.pathSeparator}thumbNail.png",
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              if (widget.isFromStory!) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CreateStory()),
                );
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CreatePostPage()));
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            tooltip: 'Leave editor',
          ),
          actions: [
            IconButton(
              onPressed: () => getVideoThumbnail(videoPath: widget.postVideo!),
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              tooltip: 'Next',
            ),
          ],
        ),
        body: _controller?.initialized == true
            ? Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CropGridViewer.preview(controller: _controller!),
                        AnimatedBuilder(
                          animation: _controller!.video,
                          builder: (_, __) => Visibility(
                            visible: !_controller!.isPlaying,
                            child: GestureDetector(
                              onTap: _controller!.video.play,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isExporting,
                    builder: (_, bool export, __) => Container(
                      height: 90,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "effects.png",
                              title: "Effects",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoFilterScreen(
                                              postVideo: widget.postVideo,
                                              isFromStory: widget.isFromStory,
                                              sound: widget.sound,
                                              soundId: widget.soundId,
                                              thumbNail: widget.thumbNail,
                                            )));
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "music.png",
                              title: "Music",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainMusicScreen(
                                              postVideo: widget.postVideo,
                                              isFromStory: widget.isFromStory,
                                              soundId: widget.soundId,
                                              thumbNail: widget.thumbNail,
                                              (data, localMusic) async {},
                                            )));
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "trim.png",
                              title: "Trim",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TrimVideo(
                                              isFromStory: widget.isFromStory,
                                              postVideo: _controller,
                                              sound: widget.sound,
                                              soundId: widget.soundId,
                                              thumbNail: widget.thumbNail,
                                            )));
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "crop.png",
                              title: "Crop",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => CropScreen(
                                      isFromStory: widget.isFromStory,
                                      controller: _controller!,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "speed.png",
                              title: "Speed",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpeedAdjustmentScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      initialSpeed: 1.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "reverse.png",
                              title: "Reverse",
                              onTap: () {
                                reverseVideo();
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "text.png",
                              title: "Text",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddTextVideo(
                                              isFromStory: widget.isFromStory,
                                              postVideo: widget.postVideo!,
                                              sound: widget.sound,
                                              soundId: widget.soundId,
                                              thumbNail: widget.thumbNail,
                                            )));
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "sticker.png",
                              title: "Sticker",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddSticker(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "audio.png",
                              title: "Audio",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AudioAdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Audio",
                                      sliderMinValue: 0.0,
                                      sliderMaxValue: 200,
                                      sliderValue: 100,
                                      isVignetteAdjustment: false,
                                      initialMuteAudio: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "brightness.png",
                              title: "Brightness",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Brightness",
                                      sliderMinValue: -1.0,
                                      sliderMaxValue: 1.0,
                                      sliderValue: 0.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "saturation.png",
                              title: "Saturation",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Saturation",
                                      sliderMinValue: 0.0,
                                      sliderMaxValue: 3.0,
                                      sliderValue: 1.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "contrast.png",
                              title: "Contrast",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Contrast",
                                      sliderMinValue: 0.5,
                                      sliderMaxValue: 2.0,
                                      sliderValue: 1.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "hue.png",
                              title: "Hue",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Hue",
                                      sliderMinValue: -180,
                                      sliderMaxValue: 180,
                                      sliderValue: 1.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "vignette.png",
                              title: "Vignette",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Vignette",
                                      sliderMinValue: 3.0,
                                      sliderMaxValue: 8.0,
                                      sliderValue: 4.0,
                                      isVignetteAdjustment: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "vibrance.png",
                              title: "Vibrance",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Vibrance",
                                      sliderMinValue: 0.0,
                                      sliderMaxValue: 2.0,
                                      sliderValue: 1.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                            FeatureButton(
                              icon: "temperature.png",
                              title: "Temperature",
                              onTap: () {
                                _controller?.video.pause();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdjustmentsScreen(
                                      isFromStory: widget.isFromStory,
                                      postVideo: widget.postVideo,
                                      sound: widget.sound,
                                      soundId: widget.soundId,
                                      thumbNail: widget.thumbNail,
                                      adjustmentName: "Temperature",
                                      sliderMinValue: -1.0,
                                      sliderMaxValue: 1.0,
                                      sliderValue: 1.0,
                                      isVignetteAdjustment: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  const FeatureButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: Image(
            image: AssetImage("assets/icons/$icon"),
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        )
      ]),
    );
  }
}
