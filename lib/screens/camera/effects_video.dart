import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:flutter/services.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'video_editor_screen.dart';

class VideoFilterScreen extends StatefulWidget {
  VideoFilterScreen(
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
  _VideoFilterScreenState createState() => _VideoFilterScreenState();
}

class _VideoFilterScreenState extends State<VideoFilterScreen> {
  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  FFmpegSession? session;
  List<String> lutAssets = [
    'assets/luts/Fiction.cube',
    'assets/luts/Forest.cube',
    'assets/luts/Gotham.cube',
    'assets/luts/Horror.cube',
    'assets/luts/Landscape.cube',
    'assets/luts/Leonardo.cube',
    'assets/luts/Medieval.cube',
    'assets/luts/Milky.cube',
    'assets/luts/Nostalgic.cube',
    'assets/luts/War.cube',
    'assets/luts/Wedding.cube',
    'assets/luts/Western.cube',
    'assets/luts/Winter.cube',
    'assets/luts/Xpro.cube',
    'assets/luts/Adventure.cube',
    'assets/luts/African.cube',
    'assets/luts/Angelic.cube',
    'assets/luts/Autumn.cube',
    'assets/luts/BlueSky.cube',
    'assets/luts/Bride.cube',
    'assets/luts/Epic.cube'
  ];
  List<String> lutsPreview = [
    'assets/lutspreview/Fiction.png',
    'assets/lutspreview/Forest.png',
    'assets/lutspreview/Gotham.png',
    'assets/lutspreview/Horror.png',
    'assets/lutspreview/Landscape.png',
    'assets/lutspreview/Leonardo.png',
    'assets/lutspreview/Medieval.png',
    'assets/lutspreview/Milky.png',
    'assets/lutspreview/Nostalgic.png',
    'assets/lutspreview/War.png',
    'assets/lutspreview/Wedding.png',
    'assets/lutspreview/Western.png',
    'assets/lutspreview/Winter.png',
    'assets/lutspreview/Xpro.png',
    'assets/lutspreview/Adventure.png',
    'assets/lutspreview/African.png',
    'assets/lutspreview/Angelic.png',
    'assets/lutspreview/Autumn.png',
    'assets/lutspreview/BlueSky.png',
    'assets/lutspreview/Bride.png',
    'assets/lutspreview/Epic.png'
  ];

  VideoPlayerController? _videoPlayerController;
  String? lutFilePath;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    session?.cancel();
    super.dispose();
  }

  // Initialize video player
  void _initializeVideoPlayer({String? videoPath}) {
    _videoPlayerController?.dispose();
    _videoPlayerController =
        VideoPlayerController.file(File(videoPath ?? widget.postVideo!));
    _videoPlayerController!.initialize().then((_) {
      _videoPlayerController!.play();
      _videoPlayerController!.setLooping(true);
      setState(() {});
    });
  }

  // Load the LUT file from assets and write it to a uniquely named temporary file
  Future<void> _loadLutFile({
    required String lutName,
    required int index,
  }) async {
    final directory = await getTemporaryDirectory();
    // Use a unique file name for each LUT
    final lutFile = File('${directory.path}/lut_$index.cube');

    // Load LUT file from assets
    final data = await rootBundle.load(lutName);
    await lutFile.writeAsBytes(data.buffer.asUint8List());

    setState(() {
      lutFilePath = lutFile.path; // Store the path to use in FFmpeg
    });
  }

  // show loading screen
  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  String videoOutputPath = '';
  // Apply LUT and preview the result
  void applyLUTAndPreview({required String lutName, required int index}) async {
    _showProgressDialog(context);
    await _loadLutFile(lutName: lutName, index: index);

    if (lutFilePath == null) {
      print("LUT file not yet loaded.");
      return;
    }

    videoOutputPath =
        '${(await getTemporaryDirectory()).path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';

    // Apply LUT using FFmpeg
    String command =
        "-y -i ${widget.postVideo} -vf \"lut3d=$lutFilePath,scale=ceil(iw/2)*2:ceil(ih/2)*2,format=yuv420p\" -c:v libx264 -crf 18 -preset veryfast -c:a copy $videoOutputPath";

    session = await FFmpegKit.execute(command).then(
      (value) async {
        Navigator.of(context).pop();
        final returnCode = await value.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          print("LUT applied successfully!");
          // Reinitialize video controller with the processed video
          _initializeVideoPlayer(videoPath: videoOutputPath);
        } else {
          print("Error applying LUT: ${await value.getFailStackTrace()}");
        }
        await session?.cancel();
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                    AnimatedBuilder(
                      animation: _videoPlayerController!,
                      builder: (_, __) => Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            _videoPlayerController?.value.isPlaying == true
                                ? _videoPlayerController?.pause()
                                : _videoPlayerController?.play();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _videoPlayerController?.value.isPlaying == true
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: lutAssets.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    applyLUTAndPreview(lutName: lutAssets[index], index: index);
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 5, left: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 50,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image(
                            image: AssetImage(lutsPreview[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        SizedBox(
                          width: 60,
                          child: Text(
                            lutsPreview[index].split('/')[2].splitBefore('.'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                  Text("Effects"),
                  IconButton(
                      onPressed: () async {
                        if (videoOutputPath.isNotEmpty) {
                          String f = await _findLocalPath();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => VideoEditorScreen(
                                postVideo: videoOutputPath,
                                isFromStory: widget.isFromStory,
                                thumbNail: widget.thumbNail,
                                sound: "$f/audio.mp3",
                                soundId: widget.soundId,
                              ),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController.value.isInitialized) {
      return VideoPlayer(_videoController);
    } else {
      return Container();
    }
  }
}
