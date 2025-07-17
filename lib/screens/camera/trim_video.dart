import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/camera/export_service.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:video_editor/video_editor.dart';

class TrimVideo extends StatefulWidget {
  TrimVideo(
      {Key? key,
      this.postVideo,
      this.thumbNail,
      this.sound,
      this.soundId,
      this.isFromStory = false})
      : super(key: key);

  final VideoEditorController? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final bool? isFromStory;

  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: SizedBox.shrink(),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CropGridViewer.preview(controller: widget.postVideo!),
                    AnimatedBuilder(
                      animation: widget.postVideo!.video,
                      builder: (_, __) => Visibility(
                        visible: !widget.postVideo!.isPlaying,
                        child: GestureDetector(
                          onTap: widget.postVideo!.video.play,
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
                    ),
                  ],
                ),
              ),
              Column(
                children: _trimSlider(),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          _exportVideo();
                        },
                        icon: Icon(
                          Icons.check,
                          color: AppColors.primaryColor,
                        )),
                  ],
                ),
              ),
              // ValueListenableBuilder(
              //   valueListenable: _isExporting,
              //   builder: (_, bool export, __) => Visibility(
              //     visible: export,
              //     child: AlertDialog(
              //       title: ValueListenableBuilder(
              //         valueListenable: _exportingProgress,
              //         builder: (_, double value, __) => Text(
              //           "video in progress: ${(value * 100).ceil()}%",
              //           style:
              //               const TextStyle(fontSize: 12, color: Colors.black),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);

  void _exportVideo() async {
    widget.postVideo!.video.pause();

    final config = VideoFFmpegVideoEditorConfig(
      widget.postVideo!,
    );
    _exportingProgress.value = 0;
    _isExporting.value = true;
    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        // _exportingProgress.value = stats.getTime();
      },
      onCompleted: (file) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return VideoEditorScreen(
              postVideo: file.path,
              thumbNail: widget.thumbNail,
              sound: widget.sound,
              soundId: widget.soundId,
            );
          },
        ));
        _isExporting.value = false;
      },
    );
  }

  final double height = 60;
  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");
  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          widget.postVideo!,
          widget.postVideo?.video,
        ]),
        builder: (_, __) {
          final duration = widget.postVideo?.videoDuration.inSeconds;
          final pos = widget.postVideo!.trimPosition * duration!;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(
                formatter(Duration(seconds: pos.toInt())),
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Visibility(
                visible: widget.postVideo!.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    formatter(widget.postVideo!.startTrim),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formatter(widget.postVideo!.endTrim),
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: widget.postVideo!,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: widget.postVideo!,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }
}
