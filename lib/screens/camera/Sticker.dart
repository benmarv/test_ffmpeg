import 'dart:io';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/emoji_sticker_provider.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as dev;

class AddSticker extends StatefulWidget {
  AddSticker(
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
  _AddStickerState createState() => _AddStickerState();
}

class _AddStickerState extends State<AddSticker> {
  late double _textPositionX;
  late double _textPositionY;
  FFmpegSession? session;
  GlobalKey videoPlayerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _textPositionX = 0.0;
    _textPositionY = 0.0;
    context.read<EmojiStickerProvider>().makePathEmpty();
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    session?.cancel();
    super.dispose();
  }

  final List<String> sticker = [
    'assets/Basic/17_Cuppy_tired.png',
    'assets/Basic/08_Cuppy_lovewithmug.png',
    'assets/Basic/15_Cuppy_bluescreen.png',
    'assets/Basic/23_Cuppy_greentea.png',
    'assets/Basic/24_Cuppy_phone.png',
    'assets/Basic/01_Cuppy_smile.png',
    'assets/Basic/02_Cuppy_lol.png',
    'assets/Basic/03_Cuppy_rofl.png',
    'assets/Basic/04_Cuppy_sad.png',
    'assets/Basic/06_Cuppy_love.png',
    'assets/Basic/07_Cuppy_hate.png',
    'assets/Basic/22_Cuppy_bye.png',
    'assets/Basic/09_Cuppy_lovewithcookie.png',
    'assets/Basic/16_Cuppy_angry.png',
  ];

  VideoPlayerController? _videoPlayerController;
  void _initializeVideoPlayer() {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.postVideo!));
    _videoPlayerController!.initialize().then((_) {
      _showFilterBottomSheet();
      setState(() {});
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<EmojiStickerProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Wrap(spacing: 5.0, runSpacing: 8.0, children: [
                for (int i = 0; i < sticker.length; i++) ...[
                  InkWell(
                    onTap: () {
                      value.setSelectedImagePath(sticker[i]);
                      dev.log(value.selectedImagePath);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 80.0,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(sticker[i])),
                      ),
                    ),
                  )
                ]
              ]),
            ),
          );
        });
      },
    );
  }

// get image path from asset image
  Future<String> getCacheImagePath(String assetPath) async {
    final fileExtension = assetPath.split('.').last;
    final directory = await getTemporaryDirectory();
    final cachePath = '${directory.path}/image.$fileExtension';

    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    await File(cachePath).writeAsBytes(bytes);

    return cachePath;
  }

  Future _addimageToVideo(assetpath, context, videopath) async {
    _showProgressDialog(context);
    try {
      final RenderBox? videoPlayerBox =
          videoPlayerKey.currentContext?.findRenderObject() as RenderBox?;
      final videoPlayerSize = videoPlayerBox!.size;

      // Calculate the relative X and Y positions as percentages
      final double relativeX = (_textPositionX / videoPlayerSize.width) * 100;
      final double relativeY = (_textPositionY / videoPlayerSize.height) * 100;
      final imagePath = await getCacheImagePath(assetpath);
      String f = await _findLocalPath();
      var videoPath =
          "$f${Platform.pathSeparator}output${DateTime.now().millisecond}.mp4";

      session = await FFmpegKit.execute('-y -i $videopath -i $imagePath '
              '-filter_complex "[1:v]scale=$imageWidth:$imageHeight,format=rgba [ovrl];'
              '[0:v][ovrl]overlay=main_w-overlay_w-${relativeX}:main_h-overlay_h-${relativeY},format=yuv420p" '
              '-c:v libx264 -crf 18 -preset veryfast -c:a copy $videoPath')
          .then((value) async {
        final returncode = await value.getReturnCode();
        if (ReturnCode.isSuccess(returncode)) {
        } else {
          Navigator.of(context).pop();
          print("failed");
        }
        await session?.cancel();
      }).catchError((e) {
        Navigator.of(context).pop();
        dev.log(e);
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoEditorScreen(
              postVideo: videoPath,
              isFromStory: widget.isFromStory,
              thumbNail: widget.thumbNail,
              sound: widget.sound,
              soundId: widget.soundId),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      print('Error: $e');
    }
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

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  double imageWidth = 80.0;
  double imageHeight = 80.0;
  double imagScale = 80.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Stickers",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Consumer<EmojiStickerProvider>(
              builder: (context, value, child) => IconButton(
                  onPressed: () => _addimageToVideo(
                      value.selectedImagePath, context, widget.postVideo),
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
        body: Consumer<EmojiStickerProvider>(builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Stack(
                  children: [
                    if (widget.postVideo != null) ...[
                      AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(
                          _videoPlayerController!,
                          key: videoPlayerKey,
                        ),
                      ),
                      value.selectedImagePath != ""
                          ? Positioned(
                              left: _textPositionX,
                              top: _textPositionY,
                              child: GestureDetector(
                                // key: videoPlayerKey,
                                onTap: () {
                                  _showFilterBottomSheet();
                                },
                                onPanUpdate: (details) {
                                  setState(() {
                                    _textPositionX += details.delta.dx;
                                    _textPositionY += details.delta.dy;
                                  });
                                },
                                child: Image.asset(
                                  value.selectedImagePath,
                                  height: imageHeight,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ],
                ),
              ),
              Slider(
                value: imagScale,
                activeColor: AppColors.primaryColor,
                inactiveColor: Colors.grey,
                max: 150,
                min: 50,
                onChanged: (value) {
                  setState(() {
                    imagScale = value;
                    dev.log("value=>>${value.round()}");
                    imageHeight = value.round().toDouble();
                    imageWidth = value.round().toDouble();
                  });
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
