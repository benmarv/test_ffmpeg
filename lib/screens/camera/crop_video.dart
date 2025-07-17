import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:link_on/components/dialog/loader_dialog.dart';
import 'package:link_on/screens/camera/export_service.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:video_editor/video_editor.dart';

class CropScreen extends StatefulWidget {
  const CropScreen(
      {required this.controller,
      this.thumbNail,
      this.sound,
      this.soundId,
      this.isFromStory = false});

  final VideoEditorController controller;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final bool? isFromStory;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      widget.controller.rotate90Degrees(RotateDirection.left),
                  icon: const Icon(
                    Icons.rotate_left,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () =>
                      widget.controller.rotate90Degrees(RotateDirection.right),
                  icon: const Icon(
                    Icons.rotate_right,
                    color: Colors.white,
                  ),
                ),
              )
            ]),
            const SizedBox(height: 15),
            Expanded(
              child: CropGridViewer.edit(
                controller: widget.controller,
                rotateCropArea: false,
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            const SizedBox(height: 15),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (_, __) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () =>
                                widget.controller.preferredCropAspectRatio =
                                    widget.controller.preferredCropAspectRatio
                                        ?.toFraction()
                                        .inverse()
                                        .toDouble(),
                            icon: widget.controller.preferredCropAspectRatio !=
                                        null &&
                                    widget.controller
                                            .preferredCropAspectRatio! <
                                        1
                                ? const Icon(
                                    Icons.panorama_vertical_select_rounded,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.panorama_vertical_rounded,
                                    color: Colors.white,
                                  ),
                          ),
                          IconButton(
                            onPressed: () =>
                                widget.controller.preferredCropAspectRatio =
                                    widget.controller.preferredCropAspectRatio
                                        ?.toFraction()
                                        .inverse()
                                        .toDouble(),
                            icon: widget.controller.preferredCropAspectRatio !=
                                        null &&
                                    widget.controller
                                            .preferredCropAspectRatio! >
                                        1
                                ? const Icon(
                                    Icons.panorama_horizontal_select_rounded,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.panorama_horizontal_rounded,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildCropButton(context, null),
                          _buildCropButton(context, 1.toFraction()),
                          _buildCropButton(
                              context, Fraction.fromString("9/16")),
                          _buildCropButton(context, Fraction.fromString("3/4")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () async {
                    // WAY 1: validate crop parameters set in the crop view
                    widget.controller.applyCacheCrop();
                    widget.controller.video.pause();
                    showDialog(
                      context: context,
                      builder: (context) => LoaderDialog(),
                    );
                    final config = VideoFFmpegVideoEditorConfig(
                      widget.controller,
                    );

                    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_full_gpl` package (with `ffmpeg_kit` only it won't work)
                    await ExportService.runFFmpegCommand(
                      await config.getExecuteConfig(),
                      // onProgress: (stats) => _exportingProgress.value = stats.getTime(),
                      onError: (e, s) => print("Error on export video :("),
                      onCompleted: (file) {
                        Navigator.pop(context);
                        log("path is ${file.path}");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoEditorScreen(
                              isFromStory: widget.isFromStory,
                              postVideo: file.path,
                              thumbNail: widget.thumbNail,
                              sound: widget.sound,
                              soundId: widget.soundId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: const CropGridStyle().selectedBoundariesColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildCropButton(BuildContext context, Fraction? f) {
    if (widget.controller.preferredCropAspectRatio != null &&
        widget.controller.preferredCropAspectRatio! > 1) f = f?.inverse();

    return Flexible(
      child: TextButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              widget.controller.preferredCropAspectRatio == f?.toDouble()
                  ? Colors.grey.shade800
                  : null,
          foregroundColor:
              widget.controller.preferredCropAspectRatio == f?.toDouble()
                  ? Colors.white
                  : null,
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
        onPressed: () =>
            widget.controller.preferredCropAspectRatio = f?.toDouble(),
        child: Text(
          f == null ? 'free' : '${f.numerator}:${f.denominator}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
