import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/dialog/loader_dialog.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/my_loading.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/screens/music/main_music_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';
// import '../../modals/sound/sound.dart';
// import '../../utility/colors.dart';
// import '../../utility/myloading/my_loading.dart';
// import '../../utility/utils.dart';
// import '../dialog/loader_dialog.dart';
import 'dart:developer' as dev;
// import 'package:hiphop/screens/music/main_music_screen.dart';
import 'video_editor_screen.dart';

class AddMusic extends StatefulWidget {
  const AddMusic(
      {Key? key, this.postVideo, this.thumbNail, this.sound, this.soundId})
      : super(key: key);
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  @override
  State<AddMusic> createState() => _AddMusicState();
}

class _AddMusicState extends State<AddMusic> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;
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
    super.initState();
    dev.log("data ==>> ${widget.postVideo}");
    _pickVideo().then((value) => _controller
            ?.initialize()
            .then((_) => setState(() {}))
            .catchError((error) {
          // handle minumum duration bigger than video duration error
          Navigator.pop(context);
        }, test: (e) => e is VideoMinDurationError));
  }

  File? audioPath;
  String? soundId = '';
  bool isMusicSelect = false;
  SoundList? selectedMusic;
  String? localMusic;
  Future downloadAudio() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      builder: (context) => MainMusicScreen(
        postVideo: widget.postVideo,
        soundId: widget.soundId,
        thumbNail: widget.thumbNail,
        (data, localMusic) async {
          isMusicSelect = true;
          selectedMusic = data;
          localMusic = localMusic;
          soundId = data?.soundId.toString();
          setState(() {});
        },
      ),
      isScrollControlled: true,
    ).then(
      (value) => Provider.of<MyLoading>(context, listen: false)
          .setLastSelectSoundId(''),
    );
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void showLoader() {
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showLoader();
          String f = await _findLocalPath();
          var videoPath =
              "$f${Platform.pathSeparator}output${DateTime.now().millisecond}.mp4";
          print("audio path is $f/audio.mp3");
          print("audio path is ${widget.sound}");
          await FFmpegKit.execute(
            '-y -i ${widget.postVideo} -i $f/audio.mp3 -c:v libx264 -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 -shortest $videoPath',
          ).then((value) async {
            final returnCode = await value.getReturnCode();
            // Handle success and failure cases
            if (ReturnCode.isSuccess(returnCode)) {
              dev.log("FFmpeg command executed successfully.");
            } else if (ReturnCode.isCancel(returnCode)) {
              dev.log("FFmpeg command was cancelled.");
            } else {
              // Handle error
              dev.log("FFmpeg command failed with error.");
            }
            dev.log("path is ${f}");
            await value.cancel();
          }).whenComplete(() {
            print("Exported");
            Navigator.of(context).pop();
          }).catchError((e) {
            dev.log("compressing error ${e}");
            Navigator.of(context).pop();
            throw Exception(e);
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => VideoEditorScreen(
                postVideo: videoPath,
                thumbNail: widget.thumbNail,
                sound: "$f/audio.mp3",
                soundId: soundId,
              ),
            ),
          );
        },
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: _controller?.value.isInitialized == true
          ? SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () async {
                                downloadAudio();
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Icon(Icons.audiotrack),
                                  Text(
                                    "Pick an audio",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");
}
