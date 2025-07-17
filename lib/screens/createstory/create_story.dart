// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unnecessary_null_comparison, library_private_types_in_public_api, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/controllers/LoaderProgress/create_post_loader.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:link_on/screens/deep_ar/filters_screen.dart';
import 'package:link_on/screens/deepar_filters/ui/camera_screen.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class CreateStory extends StatefulWidget {
  CreateStory(
      {super.key,
      this.videopath,
      this.videoThumbnail,
      this.videoDuration,
      this.filterPhoto});
  String? videopath;
  String? videoThumbnail;
  double? videoDuration;
  File? filterPhoto;

  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  Usr getUsrData = Usr();

  TextEditingController postcontent = TextEditingController();

  // image file
  File? imageFile;
  Future<void> choseImage(String type) async {
    if (type == 'Gallery') {
      var file = await ImagePicker().pickImage(source: ImageSource.gallery);
      imageFile = File(file!.path);
      setState(() {});
    } else {
      var file = await ImagePicker().pickImage(source: ImageSource.camera);
      imageFile = File(file!.path);

      setState(() {});
    }
  }

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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoEditorScreen(
              isFromStory: true,
              postVideo: videoPath,
              thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
            ),
          ),
        );
        await returnCode.cancel();
      },
    );
  }

// for video
  XFile? video;
  Future<void> choseVideo(type) async {
    if (type == "camera") {
      video = await ImagePicker().pickVideo(source: ImageSource.camera);
    } else {
      video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    }
    if (video != null) {
      setState(() {
        imageFile = null;
      });
      getVideoThumbnail(videoPath: video!.path);
    }
  }

  videoinitlizie() {
    widget.videopath != null
        ? _videoPlayerController =
            VideoPlayerController.file(File(widget.videopath.toString()))
        : toast("");
    widget.videopath != null ? _videoPlayerController?.initialize() : toast("");
  }

  final storyController = StoryController();

  createStory({fileType, String? story_title, context, duration}) async {
    dynamic res = await creatStoryApi(
        file_type: fileType,
        contex: context,
        story_title: story_title,
        duration: duration);

    log("response is $res");

    if (res["code"] == '200') {
      if (fileType == 'video') {
        Navigator.pop(context);
      }
      Navigator.pop(context);
      Provider.of<GetUserStoryProvider>(context, listen: false)
          .getUsersStories(context: context);
    } else {
      toast('Error: create story ${res['message']}');
    }
  }

  Future<dynamic> creatStoryApi(
      {file_type, String? story_title = "", contex, duration}) async {
    try {
      String? creatStoryUrl = "story/create";

      Map<String, dynamic> mapData = {
        "type": file_type,
        "description": story_title,
        'duration': duration
      };

      if (imageFile != null) {
        String? mimeType = mime(imageFile!.path);
        if (mimeType != null) {
          String mimee1 = mimeType.split('/')[0];
          String type1 = mimeType.split('/')[1];
          try {
            mapData["media"] = await MultipartFile.fromFile(imageFile!.path,
                contentType: MediaType(mimee1, type1));
          } catch (e) {
            // Handle any exceptions that occur when creating the MultipartFile
            log('Error creating MultipartFile: $e');
          }
        }
      } else if (widget.videopath != null) {
        final thumbnailData = mime(widget.videoThumbnail);
        if (thumbnailData != null) {
          final imageParts = thumbnailData.split('/');
          if (imageParts.length == 2) {
            final thumbNailName = imageParts[0];
            final thumbNailType = imageParts[1];
            mapData['thumbnail'] = await MultipartFile.fromFile(
              widget.videoThumbnail!,
              filename: widget.videoThumbnail!.split('/').last,
              contentType: MediaType(thumbNailName, thumbNailType),
            );
          }
        }

        String? mimeType = mime(widget.videopath);
        String mimee = mimeType!.split('/')[0];
        String type = mimeType.split('/')[1];
        mapData["media"] = await MultipartFile.fromFile(widget.videopath!,
            contentType: MediaType(mimee, type));
      }

      var accessToken = getStringAsync("access_token");

      FormData form = FormData.fromMap(mapData);
      Response response = await dioService.dio.post(
        creatStoryUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
        onSendProgress: (int sent, int total) {
          _upload = (sent / total * 100);
          var progress = _upload / 100;

          Provider.of<CreatePostLoader>(context, listen: false)
              .setProgress(_upload?.floor(), context: context, ispop: true);
          Provider.of<CreatePostLoader>(context, listen: false)
              .setCircularProgress(
            progress,
          );
        },
      );
      log("response is edddddjfkjshdfkashfksfjasgdfkasdhf${response.data}");
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future showDialogeData() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Consumer<CreatePostLoader>(builder: (context, value, child) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: value.getCircularProgressValue ?? 0,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                      value.getCircularProgressValue != null
                          ? "${value.getProgressValue}%"
                          : "0%",
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  dynamic _upload;
  VideoPlayerController? _videoPlayerController;
  bool isPlayingVideo = false;
  @override
  void initState() {
    videoinitlizie();
    filterphoto();
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));
    super.initState();
  }

  void filterphoto() {
    if (widget.filterPhoto != null) {
      setState(() {
        imageFile = widget.filterPhoto;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.videopath != null) {
      _videoPlayerController!.dispose();
    }

    postcontent.dispose();
    storyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (widget.videopath != null) {
          _videoPlayerController!.dispose();
        }
        print('popscope create story');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const TabsPage()));
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const TabsPage()));
              },
            ),
            elevation: 1,
            title: Text(
              translate(context, 'create_story')!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: imageFile != null ||
                          widget.videopath != null ||
                          postcontent.text != ''
                      ? () async {
                          if (imageFile != null) {
                            createStory(
                                fileType: "image",
                                context: context,
                                story_title: postcontent.text,
                                duration: 10);
                            showDialogeData();
                          } else if (widget.videopath != null) {
                            createStory(
                                fileType: "video",
                                context: context,
                                story_title: postcontent.text,
                                duration: widget.videoDuration);
                            showDialogeData();
                          } else {
                            createStory(
                                fileType: "text",
                                context: context,
                                story_title: postcontent.text,
                                duration: 10);
                            showDialogeData();
                          }

                          _videoPlayerController!.pause();
                        }
                      : () {
                          toast(translate(context, 'select_media')!);
                        },
                  child: Text(
                    translate(context, 'create')!,
                    style: imageFile != null ||
                            widget.videopath != null ||
                            postcontent.text != ''
                        ? const TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)
                        : const TextStyle(color: Colors.grey, fontSize: 16),
                  ))
            ],
          ),
          body: Scaffold(
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: bottomContainer(),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  getUsrData.avatar.toString(),
                                ),
                              ),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(getUsrData.username.toString()),
                                  4.sw,
                                  getUsrData.isVerified == "1"
                                      ? verified()
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: postcontent,
                              autofocus: true,
                              maxLines: null,
                              minLines: null,
                              decoration: InputDecoration(
                                hintText:
                                    translate(context, 'what_talk_about')!,
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                                border: InputBorder.none,
                              ),
                              cursorColor: Colors.black,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            imageFile != null
                                ? Stack(
                                    children: [
                                      SizedBox(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Image.file(imageFile!),
                                        ),
                                      ),
                                      Positioned(
                                          top: 0,
                                          right: 5,
                                          child: IconButton(
                                              style: IconButton.styleFrom(
                                                elevation: 4,
                                              ),
                                              onPressed: () {
                                                imageFile = null;

                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.cancel_rounded,
                                                color: Colors.white,
                                                size: 30,
                                              )))
                                    ],
                                  )
                                : widget.videopath != null
                                    ? Stack(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                .5,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                VideoPlayer(
                                                    _videoPlayerController!),
                                                isPlayingVideo == false
                                                    ? IconButton(
                                                        onPressed: () {
                                                          _videoPlayerController
                                                              ?.play();
                                                          isPlayingVideo = true;
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                        ))
                                                    : IconButton(
                                                        onPressed: () {
                                                          _videoPlayerController
                                                              ?.pause();
                                                          isPlayingVideo =
                                                              false;
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons.pause,
                                                          color: Colors.white,
                                                        ))
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 5,
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                    elevation: 4,
                                                  ),
                                                  onPressed: () {
                                                    widget.videopath = null;
                                                    _videoPlayerController!
                                                        .dispose();
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_rounded,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )))
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // pick video
          InkWell(
            onTap: () {
              videobottomSheet();
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * .2,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.brown.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.videocam_sharp,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate(context, 'video')!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              imageBottomSheet();
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * .2,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.brown.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.library_add,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate(context, 'image')!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  videobottomSheet() {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.0,
                width: MediaQuery.sizeOf(context).width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                  onTap: () {
                    choseVideo("Gallery");
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.video_collection,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        translate(context, 'gallery')!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    choseVideo("camera");
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.video_call,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        translate(context, 'camera')!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }

  imageBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.0,
                width: MediaQuery.sizeOf(context).width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  choseImage('Gallery');
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.video_collection,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      translate(context, 'gallery')!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  choseImage('Camera');
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.video_call,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      translate(context, 'camera')!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(isPost: false),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.face,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Webview " + translate(context, 'filters')!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(isPost: false),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.face,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      translate(context, 'filters')!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }
}
