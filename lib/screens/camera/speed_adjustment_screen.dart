import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SpeedAdjustmentScreen extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final double initialSpeed;
  final bool? isFromStory;

  SpeedAdjustmentScreen(
      {Key? key,
      this.postVideo,
      this.thumbNail,
      this.sound,
      this.soundId,
      this.initialSpeed = 1.0,
      this.isFromStory = false})
      : super(key: key);

  @override
  State<SpeedAdjustmentScreen> createState() => _SpeedAdjustmentScreenState();
}

class _SpeedAdjustmentScreenState extends State<SpeedAdjustmentScreen> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  late VideoPlayerController _controller;
  double _currentSpeed = 1.0;
  FFmpegSession? session;

  Future<void> _pickVideo() async {
    if (widget.postVideo != null) {
      _controller = VideoPlayerController.file(File(widget.postVideo!));
      await _controller.initialize();
      setState(() {});
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.initialSpeed;
    _pickVideo();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
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

  String _formatSpeed(double speed) {
    if (speed == 1.0) return '1x';
    return '${speed.toStringAsFixed(2)}x';
  }

  String _getAtAtempo(double speed) {
    if (speed < 0.5) {
      return 'atempo=0.5,atempo=${speed / 0.5}';
    } else if (speed > 2.0) {
      return 'atempo=2.0,atempo=${speed / 2.0}';
    } else {
      return 'atempo=$speed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => Visibility(
                      visible: true,
                      child: GestureDetector(
                        onTap: () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller.value.isPlaying
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
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            'Speed: ${_formatSpeed(_currentSpeed)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Theme(
                              data: ThemeData(
                                sliderTheme: SliderThemeData(
                                  trackHeight: 2,
                                  showValueIndicator: ShowValueIndicator.always,
                                ),
                              ),
                              child: Slider(
                                activeColor: AppColors.primaryColor,
                                inactiveColor: Colors.grey,
                                value: _currentSpeed,
                                min: 0.5,
                                max: 2.0,
                                divisions: 6, // 64 steps from 0.125 to 8.0
                                label: _formatSpeed(_currentSpeed),
                                onChanged: (value) {
                                  setState(() {
                                    _currentSpeed = value;
                                    _controller.setPlaybackSpeed(value);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Speed Adjustment',
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: () async {
                              _controller.pause();
                              if (_currentSpeed != 1.0) {
                                _showProgressDialog(context);

                                try {
                                  String f = await _findLocalPath();
                                  String videoPath =
                                      '$f/${Platform.pathSeparator}${DateTime.now().microsecondsSinceEpoch}.mp4';
                                  String _atempo = _getAtAtempo(_currentSpeed);

                                  String ffmpegCommand =
                                      '-y -i ${widget.postVideo} '
                                      '-filter:v "setpts=${1 / _currentSpeed}*PTS" ' // Video speed adjustment
                                      '-filter:a "$_atempo" ' // Audio speed adjustment
                                      '-c:v libx264 -crf 18 -preset veryfast ' // Video encoding options
                                      '-c:a aac ' // Audio codec
                                      '$videoPath'; // Output file

                                  session =
                                      await FFmpegKit.execute(ffmpegCommand);

                                  final returnCode =
                                      await session!.getReturnCode();

                                  // Handle success and failure cases
                                  if (ReturnCode.isSuccess(returnCode)) {
                                    log("FFmpeg command executed successfully.");
                                  } else if (ReturnCode.isCancel(returnCode)) {
                                    log("FFmpeg command was cancelled.");
                                  } else {
                                    // Handle error
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
