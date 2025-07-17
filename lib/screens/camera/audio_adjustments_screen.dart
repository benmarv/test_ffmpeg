import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';

import 'dart:developer' as dev;
import 'video_editor_screen.dart';

// ignore: must_be_immutable
class AudioAdjustmentsScreen extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final String adjustmentName;
  final double sliderMinValue;
  final double sliderMaxValue;
  final bool isVignetteAdjustment;
  double sliderValue;
  final bool? isFromStory;
  final bool initialMuteAudio; // New parameter for initial audio state
  AudioAdjustmentsScreen({
    Key? key,
    this.postVideo,
    this.thumbNail,
    this.sound,
    this.soundId,
    this.isFromStory = false,
    this.initialMuteAudio = false,
    this.isVignetteAdjustment = false,
    required this.adjustmentName,
    required this.sliderMinValue,
    required this.sliderMaxValue,
    required this.sliderValue,
  }) : super(key: key);

  @override
  State<AudioAdjustmentsScreen> createState() => _AudioAdjustmentsScreenState();
}

class _AudioAdjustmentsScreenState extends State<AudioAdjustmentsScreen> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  bool _muteAudio = false; // Initial audio mute state
  FFmpegSession? session;

  VideoPlayerController? _controller;

  Future<void> _pickVideo() async {
    if (mounted && widget.postVideo != null) {
      _controller = VideoPlayerController.file(
        File(widget.postVideo!),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _muteAudio = widget.initialMuteAudio;
    _pickVideo().then((value) => _controller
            ?.initialize()
            .then((_) => setState(() {}))
            .catchError((error) {
          // handle minumum duration bigger than video duration error
          Navigator.pop(context);
        }, test: (e) => e is VideoMinDurationError));
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    session?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero, // Removes padding around the dialog
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width, // Full width
                height: MediaQuery.of(context).size.height, // Full height
                padding: const EdgeInsets.all(20), // Add padding if needed
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller?.value.isInitialized == true
          ? SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  AnimatedBuilder(
                    animation: _controller!,
                    builder: (_, __) => Visibility(
                      visible: true,
                      child: GestureDetector(
                        onTap: () {
                          _controller?.value.isPlaying == true
                              ? _controller?.pause()
                              : _controller?.play();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller?.value.isPlaying == true
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: Container(
                        // height: 90,
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.volume_off,
                                  color: _muteAudio
                                      ? AppColors.primaryColor
                                      : Colors.white),
                              onPressed: () {
                                setState(() {
                                  _muteAudio = !_muteAudio;
                                  log('audio mute : $_muteAudio');
                                });
                              },
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                    sliderTheme: SliderThemeData(
                                  trackHeight: 4,
                                  showValueIndicator: ShowValueIndicator.always,
                                )),
                                child: Slider(
                                  activeColor: AppColors.primaryColor,
                                  label: widget.sliderValue.toInt().toString(),
                                  inactiveColor: Colors.grey,
                                  value: widget.sliderValue,
                                  min: widget.sliderMinValue,
                                  max: widget.sliderMaxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.sliderValue = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                      bottom: 10,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                            Text(
                              widget.adjustmentName,
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                onPressed: () async {
                                  _controller?.pause();
                                  if (widget.sliderValue != 100) {
                                    // Show progress dialog
                                    _showProgressDialog(context);

                                    try {
                                      // Find the local path
                                      String f = await _findLocalPath();

                                      // Generate a unique filename using microseconds for better precision
                                      String videoPath =
                                          "$f${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.mp4";

                                      // Construct the FFmpeg command with the vignette filter
                                      String ffmpegCommand =
                                          '-y -i ${widget.postVideo}  -af "volume=${widget.sliderValue}" -c:v libx264 -crf 18 -preset veryfast -c:a aac ${_muteAudio ? '-an' : ''} $videoPath';
                                      // log the command
                                      log("ffmpeg command : $ffmpegCommand");
                                      // Execute the FFmpeg command
                                      session = await FFmpegKit.execute(
                                          ffmpegCommand);

                                      // get return code
                                      final returnCode =
                                          await session!.getReturnCode();

                                      // Handle success and failure cases
                                      if (ReturnCode.isSuccess(returnCode)) {
                                        dev.log(
                                            "FFmpeg command executed successfully.");
                                      } else if (ReturnCode.isCancel(
                                          returnCode)) {
                                        dev.log(
                                            "FFmpeg command was cancelled.");
                                      } else {
                                        // Handle error
                                        dev.log(
                                            "FFmpeg command failed with error.");
                                      }
                                      // Hide progress dialog
                                      _hideProgressDialog(context);

                                      // After completion, clean up logs
                                      await session!.getAllLogs().then((logs) {
                                        log(logs.iterator);
                                        logs.clear();
                                      });

                                      // log output generated
                                      await session!.getOutput().then((output) {
                                        log("ffmpeg output : $output");
                                      });

                                      // cancel session
                                      await session!.cancel();

                                      // Navigate to the VideoEditor screen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VideoEditorScreen(
                                            postVideo: videoPath,
                                            thumbNail: widget.thumbNail,
                                            sound: widget.sound,
                                            soundId: widget.soundId,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      // Handle errors during FFmpeg execution
                                      dev.log(
                                          "Error during video processing: $e");

                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      )),
                  // Positioned(
                  //   bottom: 10,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(Icons.volume_off,
                  //             color:
                  //                 _muteAudio ? AppColors.primary : Colors.grey),
                  //         onPressed: () {
                  //           setState(() {
                  //             _muteAudio = !_muteAudio;
                  //           });
                  //         },
                  //       ),
                  //       Text(_muteAudio ? 'Audio muted' : 'Audio on'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
