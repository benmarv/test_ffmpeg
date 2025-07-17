import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/openai/openai_controller.dart';
import 'package:link_on/screens/tabs/profile/report_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  final dynamic image;
  final File? withoutNetworkImage;
  final bool? isFromAiScreen;
  const DetailScreen(
      {super.key, this.image, this.withoutNetworkImage, this.isFromAiScreen});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      addFull();
    }
  }

  String? modifiedUrl;

  addFull() {
    String originalUrl = widget.image;
    int avatarIndex = originalUrl.indexOf("_avatar");

    int coverIndex = originalUrl.indexOf("_cover");

    if (avatarIndex != -1) {
      modifiedUrl =
          "${originalUrl.substring(0, avatarIndex + 7)}_full${originalUrl.substring(avatarIndex + 7)}";
    } else if (coverIndex != -1) {
      modifiedUrl =
          "${originalUrl.substring(0, coverIndex + 6)}_full${originalUrl.substring(coverIndex + 6)}";
    } else {
      modifiedUrl = widget.image;
      log("'_avatar' or '_cover' not found in the URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        extendBodyBehindAppBar: true,
        floatingActionButton: (widget.isFromAiScreen != null)
            ? FloatingActionButton(
                tooltip: 'Create Post',
                onPressed: () {
                  Provider.of<ImageController>(context, listen: false)
                      .downloadImage(
                    isCreatePost: true,
                    context: context,
                  );
                },
                child: Icon(Icons.check),
              )
            : SizedBox.shrink(),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))],
            ),
          ),
          actions: [
            if (widget.isFromAiScreen != null) ...[
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportUser(
                      postid: "1",
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.report_gmailerrorred_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    Provider.of<ImageController>(context, listen: false)
                        .downloadImage(
                  isCreatePost: false,
                  context: context,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.save_alt_rounded,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    Provider.of<ImageController>(context, listen: false)
                        .shareImage(context: context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.share,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              )
            ]
          ],
        ),
        body: (modifiedUrl != null || widget.withoutNetworkImage != null)
            ? InteractiveViewer(
                child: Center(
                  child: Hero(
                    tag: 'imageHero',
                    child: widget.withoutNetworkImage != null
                        ? Image.file(
                            widget.withoutNetworkImage!,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: modifiedUrl!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ));
  }
}
