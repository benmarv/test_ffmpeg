import 'dart:async';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:flutter/services.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer' as dev;

class AddTextVideo extends StatefulWidget {
  AddTextVideo(
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
  _AddTextVideoState createState() => _AddTextVideoState();
}

class _AddTextVideoState extends State<AddTextVideo> {
  TextEditingController? _textController;
  final _focusNode = FocusNode();
  GlobalKey videoPlayerKey = GlobalKey();
  VideoPlayerController? _videoPlayerController;
  FFmpegSession? session;
  double _textPositionX = 0.0;
  double _textPositionY = 0.0;
  bool textwrite = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    textwrite = true;
    _videoPlayerController =
        VideoPlayerController.file(File(widget.postVideo!));
    _videoPlayerController!.initialize();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController?.clear();
    _textController!.dispose();
    _videoPlayerController!.dispose();
    _focusNode.dispose();
    session?.cancel();
    super.dispose();
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

  Future<String> loadFontFile() async {
    // Load the font from the assets
    final ByteData data =
        await rootBundle.load('assets/font/Poppins-Medium.ttf');

    // Get the temporary directory
    final Directory tempDir = await getTemporaryDirectory();

    // Create a temporary file path for the font
    final File fontFile = File('${tempDir.path}/myfont.ttf');

    // Write the font file to the temp directory
    await fontFile.writeAsBytes(data.buffer.asUint8List());

    return fontFile.path; // Return the font file path
  }

  Future<void> applyTextOnVideo() async {
    try {
      _showProgressDialog(context);
      final RenderBox? videoPlayerBox =
          videoPlayerKey.currentContext?.findRenderObject() as RenderBox?;
      final videoPlayerSize = videoPlayerBox!.size;

      // Calculate the relative X and Y positions as percentages
      final double relativeX = (_textPositionX / videoPlayerSize.width) * 100;
      final double relativeY = (_textPositionY / videoPlayerSize.height) * 100;

      String fontFilePath = await loadFontFile(); // Load the font from assets
      String f = await _findLocalPath();
      var videoPath =
          "$f${Platform.pathSeparator}output${DateTime.now().millisecondsSinceEpoch}.mp4";

      // Update FFmpeg command to use relative positions in percentages
      String ffmpegCommand =
          '-y -i "${widget.postVideo}" -vf "drawtext=text=\'${_textController!.text}\':'
          'fontfile=$fontFilePath:fontsize=26:fontcolor=white:x=(w*${relativeX / 100}):y=(h*${relativeY / 100})" '
          '-c:v libx264 -crf 18 -preset veryfast -c:a copy "$videoPath"';

      // execute command
      session = await FFmpegKit.execute(ffmpegCommand).then((value) async {
        final returnCode = await value.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          Navigator.pop(context);
          print('Text applied to video successfully!');
        } else {
          Navigator.pop(context);

          print('FFmpeg command failed: ${await value.getOutput()}');
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
            postVideo: "$videoPath",
            isFromStory: widget.isFromStory,
            thumbNail: widget.thumbNail,
            sound: widget.sound,
            soundId: widget.soundId,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      print('Error: $e');
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        textwrite = false;
        setState(() {});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          title: Text(
            'Add Text',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed:
                    _textController!.text.isNotEmpty ? applyTextOnVideo : () {},
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ],
        ),
        body: widget.postVideo == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.85,
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(
                        _videoPlayerController!,
                        key: videoPlayerKey,
                      ),
                    ),
                  ),
                  Positioned(
                    left: _textPositionX,
                    top: _textPositionY,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _textPositionX += details.delta.dx;
                          _textPositionY += details.delta.dy;
                        });
                      },
                      child: Text(
                        _textController!.text,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.viewInsetsOf(context).bottom == 0
                        ? 10
                        : MediaQuery.sizeOf(context).height * 0.32,
                    left: 10,
                    right: 10,
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      controller: _textController,
                      focusNode: _focusNode,
                      onSubmitted: (value) {
                        setState(() {
                          textwrite = false;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Add your text here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
