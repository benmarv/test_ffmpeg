import 'dart:io';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/createstory/create_story.dart';
import 'package:path_provider/path_provider.dart';

class ButtonsRow extends StatefulWidget {
  const ButtonsRow(
      {super.key, required this.deepArController, required this.isPost});
  final DeepArController deepArController;
  final bool isPost;

  @override
  State<ButtonsRow> createState() => _ButtonsRowState();
}

class _ButtonsRowState extends State<ButtonsRow> {
  bool isRecording = false;
  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void getVideoThumbnail({required String videoPath}) async {
    print('video path : $videoPath');
    String f = await _findLocalPath();

    FFmpegKit.execute(
            '-i $videoPath -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"')
        .then(
      (returnCode) async {
        await returnCode.cancel();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoEditorScreen(
              isFromStory: false,
              postVideo: videoPath,
              thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: widget.deepArController.flipCamera,
          icon: const Icon(
            Icons.flip_camera_ios_outlined,
            size: 34,
            color: Colors.white,
          ),
        ),
        // GestureDetector(
        //   onLongPressStart: (_) async {
        //     try {
        //       await widget.deepArController.startVideoRecording();
        //       setState(() {
        //         isRecording = true;
        //       });
        //       print('Video recording started!');
        //     } catch (e) {
        //       print('Error starting video recording: $e');
        //     }
        //   },
        //   onLongPressEnd: (_) async {
        //     if (isRecording) {
        //       try {
        //         File recordedVideo =
        //             await widget.deepArController.stopVideoRecording();
        //         print('Video recording : ${recordedVideo.path}');

        //         setState(() {
        //           isRecording = false;
        //         });
        //         // getVideoThumbnail(videoPath: recordedVideo.path);
        //         print('Video recording stopped!');
        //       } catch (e) {
        //         print('Error stopping video recording: $e');
        //       }
        //     }
        //   },
        //   child: Icon(
        //     Icons.videocam,
        //     color: isRecording ? Colors.red : Colors.white,
        //   ),
        // ),
        FilledButton(
          onPressed: () async {
            try {
              // Take the screenshot
              File pickedImage = await widget.deepArController.takeScreenshot();
              if (widget.isPost) {
                // navigate to create post
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreatePostPage(filterPhoto: pickedImage),
                    ));
              } else {
                // navigate to create post
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateStory(filterPhoto: pickedImage),
                    ));
              }

              // print('Image saved to gallery!');
            } catch (e) {
              print('Error saving image: $e');
            }
          },
          child: Icon(
            Icons.camera,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: widget.deepArController.toggleFlash,
          icon: const Icon(
            Icons.flash_on,
            size: 34,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
