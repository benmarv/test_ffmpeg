// ignore_for_file: unused_import, use_build_context_synchronously, avoid_print, library_private_types_in_public_api, must_be_immutable
import 'dart:async';
import 'dart:math';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:developer' as dev;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/controllers/mention_provider/mention_provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/location_model.dart';
import 'package:link_on/models/posts.dart' as post;
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:link_on/screens/deep_ar/filters_screen.dart';
import 'package:link_on/screens/create_post/add_poll.dart';
import 'package:link_on/screens/create_post/create_donation_post.dart';
import 'package:link_on/screens/create_post/tag_people.dart';
import 'package:link_on/screens/deepar_filters/ui/camera_screen.dart';
import 'package:link_on/screens/openai/chatbot/chat_controller.dart';
import 'package:link_on/screens/openai/text_to_image.dart';
import 'package:link_on/screens/pages/location_screen.dart';
import 'package:link_on/screens/real_estate/theme/color.dart';
import 'package:link_on/screens/search_location/search_location.dart';
import 'package:link_on/screens/settings/widgets/icon_tile.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/screens/create_post/live_stream_screen.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/tabs/home/home.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http_parser/http_parser.dart';
import 'overlay.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as markers;

class CreatePostPage extends StatefulWidget {
  final String? groupId;
  final String? pageId;
  final dynamic val;
  String? videopath;
  String? shoutOutAudio;
  String? videoThumbnail;
  File? filterPhoto;
  Location? location;

  final bool? flag;
  CreatePostPage(
      {super.key,
      this.videopath,
      this.groupId,
      this.pageId,
      this.val,
      this.shoutOutAudio,
      this.videoThumbnail,
      this.filterPhoto,
      this.location,
      this.flag});
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  Stream<DurationState>? _durationState;

  Usr getUsrData = Usr();

  TextEditingController postcontent = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  bool isTextEmpty = false;
  var privacydata = "Public";
  var setIcon = const Icon(
    Icons.public,
    color: AppColors.primaryColor,
    size: 16,
  );
  List<Icon> icondata = [
    const Icon(Icons.public, color: AppColors.primaryColor, size: 16),
    const Icon(Icons.people, color: AppColors.primaryColor, size: 16),
    const Icon(color: AppColors.primaryColor, Icons.lock, size: 16),
    const Icon(Icons.family_restroom, color: AppColors.primaryColor, size: 16),
    const Icon(Icons.work, color: AppColors.primaryColor, size: 16),
  ];

  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool isShowAvailableColors = false;
  bool isShowColorLens = true;
  Decoration? selectedContainerDecoration;
  String? selectedClassName;
  final FocusNode _focusNode = FocusNode();

  List<String> data = [
    "public",
    "friends",
    "only_me",
    "family",
    "business",
  ];

  Future<void> _init() async {
    try {
      dev.log("init audio player set file path : ${audioFile!.path}");
      await audioPlayer.setFilePath(audioFile!.path);

      setState(() {});
    } catch (e) {
      debugPrint('An error occured init audio $e');
    }
  }

  bottomSheet() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 320,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) => Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.5,
                  )),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        privacydata = data[index];
                        setIcon = icondata[index];
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: icondata[index],
                      title: translate(context, data[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  dynamic _upload;
  File? selectedImage;
  dynamic imageDimenstion;

  List<File>? multipleSelectedImages = [];
  Uint8List? imageData;

  String? thumbNailName;
  String? thumbNailType;

  //pick image
  Future choseImage(type) async {
    XFile? image;
    List multiImages = [];
    if (type == "camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else if (type == "Gallery") {
      multiImages = await ImagePicker().pickMultiImage();
    }

    if (image != null) {
      audioPlayer.dispose();

      _durationstateInit();
      audioFile = null;
      _videoPlayerController?.dispose();
      widget.videopath = null;

      var croppedImage = await ImageCropper.platform.cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (croppedImage != null) {
        selectedImage = File(croppedImage.path);
        setState(() {});
      }
      imageDimenstion =
          await decodeImageFromList(selectedImage!.readAsBytesSync());
    }

    if (multiImages.isNotEmpty) {
      audioPlayer.dispose();

      _durationstateInit();
      audioFile = null;
      _videoPlayerController?.dispose();
      widget.videopath = null;

      if (multiImages.length == 1) {
        var croppedImage = await ImageCropper.platform.cropImage(
          sourcePath: multiImages[0].path,
          maxWidth: 1080,
          maxHeight: 1080,
        );
        if (croppedImage != null) {
          audioPlayer.dispose();

          _durationstateInit();
          audioFile = null;
          _videoPlayerController?.dispose();
          widget.videopath = null;

          selectedImage = File(croppedImage.path);
          selectedContainerDecoration = null;
          selectedClassName = null;
          isShowAvailableColors = false;
          setState(() {});
        }
        imageDimenstion =
            await decodeImageFromList(selectedImage!.readAsBytesSync());
      } else if (multiImages.length > 1) {
        for (int i = 0; i < multiImages.length; i++) {
          multipleSelectedImages!.add(File(multiImages[i].path));
        }
      }

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

  // pick video
  XFile? video;
  Future choseVideo(type) async {
    if (type == "camera") {
      video = await ImagePicker().pickVideo(source: ImageSource.camera);
      setState(() {
        selectedContainerDecoration = null;
        selectedClassName = null;
        isShowAvailableColors = false;
      });
    } else {
      video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      setState(() {
        selectedContainerDecoration = null;
        selectedClassName = null;
        isShowAvailableColors = false;
      });
    }
    if (video != null) {
      getVideoThumbnail(videoPath: video!.path);
      audioPlayer.dispose();
      _durationstateInit();
      audioFile = null;
      selectedImage = null;
      multipleSelectedImages = null;
    }
  }

  // pick audio
  File? audioFile;
  Future choseAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;
    _durationstateInit();

    setState(() {
      selectedContainerDecoration = null;
      selectedClassName = null;
      isShowAvailableColors = false;

      audioFile = File(result.files.single.path!);
      selectedImage = null;
      multipleSelectedImages = null;
      _videoPlayerController?.dispose();
      widget.videopath = null;
      _init();
    });
  }

  videoinitlizie() {
    widget.videopath != null
        ? _videoPlayerController =
            VideoPlayerController.file(File(widget.videopath.toString()))
        : toast("");
    widget.videopath != null
        ? _videoPlayerController?.initialize()
        : log("video initialization error");
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent > 0) {
      setState(() {
        selectedContainerDecoration = null;
        selectedClassName = null;
        isShowAvailableColors = false;
      });
    }
  }

  void _filterphoto() {
    if (widget.filterPhoto != null) {
      setState(() {
        selectedImage = widget.filterPhoto;
      });
    }
  }

  void _initShoutOutAudioPlayer() {
    if (widget.shoutOutAudio != null) {
      audioFile = File(widget.shoutOutAudio!);
      dev.log('shout out audio : $audioFile');
      _init();
      _durationstateInit();
    }
  }

  void _emptyLiveRequests() {
    final liveStreamProvider =
        Provider.of<LiveStreamProvider>(context, listen: false);
    if (liveStreamProvider.liveHostRequests.isNotEmpty) {
      liveStreamProvider.emptyLiveRequests();
    }
  }

  void _disposeVideoPlauer() {
    final videoPlayerProvider =
        Provider.of<VideoPlayerProvider>(context, listen: false);
    if (videoPlayerProvider.controller != null) {
      videoPlayerProvider.disposeController();
    }
  }

  TextEditingController _locationController = TextEditingController();
  String? locationText;
  // LatLng? _currentPosition;
  // GoogleMapController? _mapController;

  VideoPlayerController? _videoPlayerController;
  bool isPlayingVideo = false;
  bool _isBottomSheetOpened = false;
  @override
  void initState() {
    _initShoutOutAudioPlayer();
    _filterphoto();
    _emptyLiveRequests();
    _initAnimationController();
    final getFriendsProvider =
        Provider.of<FriendFollower>(context, listen: false);
    if (getFriendsProvider.follower.isNotEmpty) {
      getFriendsProvider.makeFriendFollowerEmpty();
    }
    getFriendsProvider.friendGetFollower();
    _disposeVideoPlauer();
    videoinitlizie();
    // afterBuildCreated(() {
    //   if (!_isBottomSheetOpened) {
    //     _modalBottomSheetMenu();
    //     _isBottomSheetOpened = true;
    //     log('is bottom opened : $_isBottomSheetOpened');
    //   }
    // });

    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));

    _scrollController.addListener(_scrollListener);
    // _getUserLocation();
    super.initState();
  }

  void _initAnimationController() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (isShowAvailableColors) {
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    final mentionProvider =
        Provider.of<MentionProvider>(context, listen: false);
    mentionProvider.initProvider();
    postcontent.addListener(
      () => mentionProvider.onTextChanged(context, postcontent),
    );
    super.didChangeDependencies();
  }

  void _durationstateInit() {
    audioPlayer = AudioPlayer();
    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      audioPlayer.positionStream,
      audioPlayer.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    );
  }

  // Future<void> _getUserLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return;
  //   }

  //   // Check location permission
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.deniedForever) {
  //       return;
  //     }
  //   }

  //   // Get current position
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     _currentPosition = LatLng(position.latitude, position.longitude);
  //     //   locationText = "${position.latitude}, ${position.longitude}";
  //     _locationController = TextEditingController(text: locationText);
  //   });

  //   // Move camera to user's location
  //   if (_mapController != null) {
  //     if (_currentPosition != null) {
  //       _mapController!.animateCamera(
  //         CameraUpdate.newLatLng(_currentPosition!),
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    Provider.of<LiveStreamProvider>(context, listen: false).emptyLiveRequests();
    if (audioPlayer.playing == true) {
      audioPlayer.pause();
    }
    audioPlayer.dispose();

    postcontent.dispose();
    _textController.dispose();
    _videoPlayerController?.dispose();
  }

  void _modalBottomSheetMenu() async {
    if (_isBottomSheetOpened) return;

    _isBottomSheetOpened = true;
    await showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      builder: (builder) {
        return WillPopScope(
          onWillPop: () async {
            _isBottomSheetOpened = false; // Reset flag when closed
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomSheetTopDivider(color: AppColors.primaryColor),
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      Navigator.pop(context);
                      choseImage("Gallery");
                    },
                    leading: const Icon(
                      Icons.collections,
                      color: Colors.green,
                      size: 25,
                    ),
                    title: Text(translate(context, 'photo').toString()),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      choseVideo("Gallery");
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.video_collection,
                      color: Colors.deepOrange,
                      size: 25,
                    ),
                    title: Text(translate(context, 'video').toString()),
                  ),
                ),
                // if (getStringAsync("chck_generative_ai") == "1") ...[
                //   Container(
                //     decoration: BoxDecoration(
                //       border: Border.symmetric(
                //         horizontal: BorderSide(
                //             color: Theme.of(context).colorScheme.secondary,
                //             width: 0.5),
                //       ),
                //     ),
                //     child: ListTile(
                //       contentPadding: EdgeInsets.zero,
                //       onTap: () {
                //         Navigator.pop(context);
                //         Navigator.of(context).push(createRoute(ImageFeature()));
                //       },
                //       leading: const Image(
                //         image: AssetImage("assets/images/magic-wand.png"),
                //         height: 20,
                //         width: 20,
                //       ),
                //       title: Text(
                //           translate(context, 'generative_ai_post').toString()),
                //     ),
                //   ),
                // ],
                if (widget.pageId == null && widget.groupId == null) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return showPostUpdateDialog(context);
                          },
                        );

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LocationScreen()));
                      },
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 25,
                      ),
                      title: Text(translate(context, 'location').toString()),
                    ),
                  ),
                ],
                if (widget.pageId == null && widget.groupId == null) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TagPeopleScreen(userid: getUsrData.id),
                          ),
                        );
                      },
                      leading: Icon(
                        LineIcons.user_plus,
                        color: Colors.blue[800],
                        size: 22,
                      ),
                      title: Text(translate(context, 'tag_people').toString()),
                    ),
                  ),
                ],
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Provider.of<LiveStreamProvider>(context, listen: false)
                          .generateAgoraToken(
                            channelName: getUsrData.username!,
                          )
                          .then(
                            (value) => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LiveStreamScreen(
                                    isHome: false,
                                    userId: getUsrData.id,
                                    loggedInUser: getStringAsync("user_id"),
                                    token: value.token,
                                    channelName: getUsrData.username,
                                    avatar: getUsrData.avatar,
                                    username: getUsrData.username,
                                    isVerified: getUsrData.isVerified,
                                  ),
                                ),
                              ),
                            },
                          );
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.circle_rounded,
                      color: Colors.red,
                      size: 25,
                    ),
                    title: Text(translate(context, 'live').toString()),
                  ),
                ),
                if (widget.pageId == null && widget.groupId == null) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePollScreen(),
                          ),
                        );
                      },
                      leading: const Icon(
                        Icons.leaderboard_rounded,
                        color: Colors.orange,
                        size: 25,
                      ),
                      title: Text(translate(context, 'poll').toString()),
                    ),
                  ),
                  if (Platform.isAndroid)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 0.5),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterScreen(isPost: true),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.face,
                          color: Colors.deepPurpleAccent,
                        ),
                        title: Text("Webview " +
                            translate(context, 'filters').toString()),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraScreen(isPost: true),
                          ),
                        );
                      },
                      leading: Icon(
                        Icons.face,
                        color: Colors.deepPurpleAccent,
                      ),
                      title: Text(translate(context, 'filters').toString()),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddDonation(),
                          ),
                        );
                      },
                      leading: const Image(
                        image: AssetImage('assets/images/donate.png'),
                        width: 28,
                        color: Colors.lightGreen,
                      ),
                      title:
                          Text(translate(context, 'raise_funding').toString()),
                    ),
                  ),
                ],
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.5),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      imagebottomSheet();
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blue,
                      size: 25,
                    ),
                    title: Text(translate(context, 'camera').toString()),
                  ),
                ),
                if (!Platform.isIOS) ...[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        choseAudio();
                        Navigator.pop(context);
                      },
                      leading: const Icon(
                        Icons.audiotrack,
                        color: Colors.orange,
                        size: 25,
                      ),
                      title: Text(translate(context, 'music').toString()),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
    _isBottomSheetOpened = false; // Reset flag when bottom sheet is dismissed
  }

  // AlertDialog showPostUpdateDialog(BuildContext context) {
  //   //_locationController = TextEditingController(text: locationText ?? '');
  //   return AlertDialog(
  //     backgroundColor: Theme.of(context).colorScheme.secondary,
  //     title: Text(
  //       "Select Your Location",
  //       style: const TextStyle(fontWeight: FontWeight.w500),
  //     ),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  //     titleTextStyle: TextStyle(
  //       fontSize: 17,
  //       color: Theme.of(context).colorScheme.onSurface,
  //     ),
  //     content: SingleChildScrollView(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Google Map
  //           SizedBox(
  //             width: double.infinity,
  //             height: 200,
  //             child: _currentPosition == null
  //                 ? Center(child: CircularProgressIndicator())
  //                 : GoogleMap(
  //                     initialCameraPosition: CameraPosition(
  //                       target: _currentPosition!,
  //                       zoom: 15,
  //                     ),
  //                     markers: {
  //                       markers.Marker(
  //                         markerId: MarkerId("currentLocation"),
  //                         position: _currentPosition!,
  //                         infoWindow: InfoWindow(title: "You are here"),
  //                       ),
  //                     },
  //                     onMapCreated: (GoogleMapController controller) {
  //                       _mapController = controller;
  //                     },
  //                   ),
  //           ),

  //           // const SizedBox(height: 10),

  //           //  Location Input Field
  //           TextField(
  //             controller: _locationController,
  //             decoration: InputDecoration(
  //               hintText: "Enter location manually",
  //             ),
  //             maxLines: null,
  //             keyboardType: TextInputType.text,
  //           ),
  //         ],
  //       ),
  //     ),
  //     actions: <Widget>[
  //       TextButton(
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //           setState(() {
  //             locationText = null;
  //           });
  //         },
  //         child: Text("Cancel"),
  //       ),
  //       MaterialButton(
  //         color: Colors.blue,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         onPressed: () async {
  //           if (_locationController!.text.isEmpty) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text("Location cannot be empty!")),
  //             );
  //           } else {
  //             setState(() {
  //               locationText = _locationController!.text;
  //               log("Locationn: $locationText");
  //             });
  //             Navigator.pop(context);
  //           }
  //         },
  //         child: Text(
  //           "Add",
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  //  TextEditingController? _locationController;
  // String? locationText;

  AlertDialog showPostUpdateDialog(BuildContext context) {
    _locationController = TextEditingController(text: locationText ?? '');
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(
        translate(context, 'enter_your_location')!,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      titleTextStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      content: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: translate(context, 'location_hint')!,
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              locationText = null;
            });
          },
          child: Text(translate(context, 'cancel')!),
        ),
        MaterialButton(
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () async {
            if (_locationController.text.isEmpty) {
              toast(translate(context, 'location_empty')!);
            } else {
              setState(() {
                locationText = _locationController.text;
              });
              Navigator.pop(context);
            }
          },
          child: Text(
            translate(context, 'ok')!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  bool isRTL(String text) {
    return intl.Bidi.detectRtlDirectionality(text);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Want to finish your post later?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Save it as a draft or you can continue editing it.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 5),
                ListTile(
                  leading: Icon(
                    Icons.bookmark_border,
                    size: 30,
                  ),
                  title: Text(
                    "Save as draft",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "You'll receive a notification with your draft.",
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    final provider =
                        Provider.of<GreetingsProvider>(context, listen: false);
                    provider.setCurrentTabIndex(index: 0);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TabsPage()));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Post saved as draft."),
                    ));

                    // Handle Save as Draft
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, size: 30),
                  title: Text(
                    "Discard post",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    final provider =
                        Provider.of<GreetingsProvider>(context, listen: false);
                    provider.setCurrentTabIndex(index: 0);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TabsPage()));
                  },
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Handle Continue Editing
                  },
                  child: Row(
                    children: [
                      Icon(Icons.check,
                          color: AppColors.primaryColor, size: 30),
                      Text(
                        "Continue editing",
                        style: TextStyle(
                            fontSize: 14, color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext conext) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                if (widget.videopath != null ||
                    widget.location != null ||
                    widget.filterPhoto != null ||
                    widget.shoutOutAudio != null) {
                  return _showBottomSheet(context);
                }
                if (widget.val == true) {
                  Navigator.pop(context);
                  _videoPlayerController?.dispose();
                } else {
                  _videoPlayerController?.dispose();

                  final provider =
                      Provider.of<GreetingsProvider>(context, listen: false);
                  provider.setCurrentTabIndex(index: 0);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TabsPage()));
                }
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          elevation: 1,
          title: Text(
            translate(context, 'create_post').toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: InkWell(
                  onTap: (isTextEmpty ||
                          selectedImage != null ||
                          widget.videopath != null ||
                          postcontent.text.trim().isNotEmpty ||
                          audioFile != null ||
                          multipleSelectedImages?.isNotEmpty == true ||
                          _locationController.text.isNotEmpty)
                      ? () {
                          if (progressValue.value != 0.0) {
                            toast(translate(context, 'upload_in_progress')
                                .toString());
                            return;
                          }
                          _fetchData(context);
                        }
                      : () {
                          toast(translate(context, 'select_something')
                              .toString());
                        },
                  child: Text(
                    translate(context, 'post').toString(),
                    style: (isTextEmpty ||
                            selectedImage != null ||
                            widget.videopath != null ||
                            postcontent.text.trim().isNotEmpty ||
                            audioFile != null ||
                            multipleSelectedImages?.isNotEmpty == true ||
                            //widget.location != null
                            _locationController.text.isNotEmpty)
                        ? const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)
                        : const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Scaffold(
          bottomNavigationBar: bottomContainer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ProfileTab(
                              //       userId: getUsrData.id,
                              //     ),
                              //   ),
                              // );
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey.shade500,
                              backgroundImage: NetworkImage(
                                getUsrData.avatar!,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Consumer<PostProvider>(
                                  builder: (context, postProviderValue, child) {
                                String displayNames() {
                                  if (postProviderValue.taggedUserNames.length >
                                      2) {
                                    return "${postProviderValue.taggedUserNames[0]} and ${postProviderValue.taggedUserNames.length - 1} other";
                                  } else {
                                    return postProviderValue.taggedUserNames
                                        .join(', ');
                                  }
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style, // Default text style
                                            children: [
                                              TextSpan(
                                                text: getUsrData.username
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: 3
                                                    .sw, // Empty box for non-verified users
                                              ),
                                              WidgetSpan(
                                                child: getUsrData.isVerified ==
                                                        "1"
                                                    ? verified() // This should return a widget, like an Icon
                                                    : const SizedBox(
                                                        width: 0,
                                                        height:
                                                            0), // Empty box for non-verified users
                                              ),
                                              if (postProviderValue
                                                  .taggedUserNames.isNotEmpty)
                                                TextSpan(
                                                  text:
                                                      translate(context, 'with')
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              if (postProviderValue
                                                  .taggedUserNames.isNotEmpty)
                                                TextSpan(
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TagPeopleScreen(
                                                                      userid:
                                                                          getUsrData
                                                                              .id),
                                                            ),
                                                          );
                                                        },
                                                  text: displayNames(),
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .bold), // Make displayNames bold
                                                ),
                                              if (locationText != null &&
                                                  postProviderValue
                                                      .taggedUserNames
                                                      .isNotEmpty)
                                                TextSpan(
                                                  text: translate(context, 'in')
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              if (locationText != null &&
                                                  postProviderValue
                                                      .taggedUserNames.isEmpty)
                                                TextSpan(
                                                  text: translate(
                                                              context, 'is_in')
                                                          .toString() +
                                                      " ",
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              if (locationText != null ||
                                                  (postProviderValue
                                                          .taggedUserNames
                                                          .isNotEmpty &&
                                                      locationText != null))
                                                TextSpan(
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return showPostUpdateDialog(
                                                                  context);
                                                            },
                                                          );
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder:
                                                          //             (context) =>
                                                          //                 LocationScreen()));
                                                        },
                                                  text:
                                                      "$locationText", // Assuming postLocation is a String
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ), // Make locationText bold
                                                ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textWidthBasis:
                                              TextWidthBasis.longestLine,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bottomSheet();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            setIcon,
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              translate(
                                                context,
                                                privacydata.toLowerCase(),
                                              )!,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                              color: AppColors.primaryColor,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (selectedImage == null &&
                          widget.videopath == null &&
                          audioFile == null &&
                          isShowColorLens)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isShowAvailableColors) {
                                      selectedClassName = null;
                                      selectedContainerDecoration = null;
                                    }
                                    isShowAvailableColors =
                                        !isShowAvailableColors;
                                    if (isShowAvailableColors) {
                                      _controller.forward();
                                    } else {
                                      _controller.reverse();
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.color_lens,
                                      color: AppColor.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (isShowAvailableColors)
                              Expanded(
                                child: SlideTransition(
                                  position: _offsetAnimation,
                                  child: SizedBox(
                                    height: 25,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final postProvider =
                                            Provider.of<PostProvider>(conext,
                                                listen: false);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedClassName = postProvider
                                                    .availableDarkModeColors[
                                                        index]
                                                    .className;
                                                selectedContainerDecoration =
                                                    postProvider
                                                        .availableDarkModeColors[
                                                            index]
                                                        .decoration;
                                              });
                                            },
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: postProvider
                                                  .availableDarkModeColors[
                                                      index]
                                                  .decoration,
                                              child: selectedClassName ==
                                                      postProvider
                                                          .availableDarkModeColors[
                                                              index]
                                                          .className
                                                  ? Icon(
                                                      Icons.check,
                                                      color:
                                                          selectedClassName ==
                                                                  '_23jo'
                                                              ? Colors.black
                                                              : Colors.white,
                                                    )
                                                  : const SizedBox(),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: Provider.of<PostProvider>(
                                              context,
                                              listen: false)
                                          .availableDarkModeColors
                                          .length,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height:
                            selectedContainerDecoration != null ? 400 : null,
                        decoration: selectedContainerDecoration ??
                            BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                        child: Column(
                          children: [
                            if (selectedContainerDecoration != null) ...[
                              Flexible(
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 400,
                                      maxWidth: 250,
                                    ),
                                    child: TextField(
                                      scrollController: _scrollController,
                                      focusNode: _focusNode,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.multiline,
                                      controller: postcontent,
                                      textDirection:
                                          isRTL(postcontent.text.toString())
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      onChanged: (value) {
                                        if (value.length > 300) {
                                          setState(() {
                                            selectedClassName = null;
                                            selectedContainerDecoration = null;
                                            isShowAvailableColors = false;
                                            isShowColorLens = false;
                                            _focusNode.requestFocus();
                                          });
                                        }
                                        setState(() {
                                          isTextEmpty = value.trim().isNotEmpty;
                                        });
                                      },
                                      maxLines: null,
                                      style: TextStyle(
                                        color: selectedClassName != null
                                            ? selectedClassName == '_23jo'
                                                ? Colors.black
                                                : Colors.white
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!
                                                .withOpacity(0.4),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        counterText: "",
                                        hintText: translate(
                                                context, 'whats_on_your_mind')
                                            .toString(),
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: selectedClassName != null
                                              ? selectedClassName == '_23jo'
                                                  ? Colors.black
                                                  : Colors.white
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color!
                                                  .withOpacity(0.4),
                                          fontSize: 18.0,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              TextField(
                                focusNode: _focusNode,
                                keyboardType: TextInputType.multiline,
                                controller: postcontent,
                                maxLength: 640,
                                textDirection:
                                    isRTL(postcontent.text.toString())
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                onChanged: (value) {
                                  if (value.length > 640) {
                                    toast(translate(
                                            context, 'posttext_limit_message')
                                        .toString());
                                  } else if (value.length > 300) {
                                    setState(() {
                                      isShowColorLens = false;
                                    });
                                  } else if (value.length < 300) {
                                    setState(() {
                                      isShowColorLens = true;
                                    });
                                  }
                                  setState(() {
                                    isTextEmpty = value.trim().isNotEmpty;
                                  });
                                  _focusNode.requestFocus();
                                },
                                maxLines: null,
                                minLines: 1,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            elevation: 0,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                constraints: BoxConstraints(
                                                    maxWidth: 400),
                                                child: Consumer<ChatController>(
                                                  builder:
                                                      (context, value, child) =>
                                                          Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(height: 10.0),
                                                      TextFormField(
                                                        maxLines: null,
                                                        controller:
                                                            _textController,
                                                        decoration:
                                                            InputDecoration(
                                                          suffixIcon:
                                                              value.isLoading ==
                                                                      true
                                                                  ? SizedBox(
                                                                      height:
                                                                          10,
                                                                      width: 10,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            CircularProgressIndicator(),
                                                                      ),
                                                                    )
                                                                  : InkWell(
                                                                      onTap:
                                                                          () {
                                                                        value
                                                                            .createAiTextPost(
                                                                                textC: _textController.text,
                                                                                context: context)
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            postcontent.text =
                                                                                value;
                                                                          });
                                                                        });
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .send,
                                                                        color: AppColors
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                          labelText: translate(
                                                                  context,
                                                                  'enter_your_prompt')
                                                              .toString(),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.0),
                                                      Text(
                                                        value.aiPostText,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(LineIcons.robot,
                                        color: AppColors.primaryColor),
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                  counterText: "",
                                  hintText:
                                      translate(context, 'whats_on_your_mind')
                                          .toString(),
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withOpacity(0.4),
                                    fontSize: 18.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                            // if (widget.location != null)
                            //   Stack(
                            //     alignment: AlignmentDirectional.topEnd,
                            //     children: [
                            //       Card(
                            //         child: Column(
                            //           children: [
                            //             Container(
                            //               width: double.infinity,
                            //               height: 200,
                            //               child: _currentPosition == null
                            //                   ? Center(
                            //                       child:
                            //                           CircularProgressIndicator())
                            //                   : GoogleMap(
                            //                       initialCameraPosition:
                            //                           CameraPosition(
                            //                         target: LatLng(
                            //                             widget
                            //                                 .location!.latitude,
                            //                             widget.location!
                            //                                 .longitude),
                            //                         zoom: 15,
                            //                       ),
                            //                       markers: {
                            //                         markers.Marker(
                            //                           markerId: MarkerId(
                            //                               "currentLocation"),
                            //                           position: LatLng(
                            //                               widget.location!
                            //                                   .latitude,
                            //                               widget.location!
                            //                                   .longitude),
                            //                           infoWindow: InfoWindow(
                            //                               title:
                            //                                   "You are here"),
                            //                         ),
                            //                       },
                            //                       onMapCreated:
                            //                           (GoogleMapController
                            //                               controller) {
                            //                         _mapController = controller;
                            //                       },
                            //                     ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Row(
                            //                 children: [
                            //                   SizedBox(
                            //                       width: MediaQuery.of(context)
                            //                               .size
                            //                               .width *
                            //                           0.8,
                            //                       child: Text(
                            //                         widget.location!.address,
                            //                         maxLines: 3,
                            //                         overflow:
                            //                             TextOverflow.visible,
                            //                       )),
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       IconButton(
                            //           onPressed: () {
                            //             setState(() {
                            //               widget.location = null;
                            //             });
                            //           },
                            //           icon: Container(
                            //               decoration: BoxDecoration(
                            //                 color: Colors.black,
                            //                 borderRadius:
                            //                     BorderRadius.circular(50),
                            //               ),
                            //               child: Padding(
                            //                 padding: const EdgeInsets.all(4.0),
                            //                 child: Icon(Icons.close,
                            //                     size: 18, color: Colors.white),
                            //               ))),
                            //     ],
                            //   ),

                            Consumer<MentionProvider>(
                              builder: (context, value, child) => value
                                      .isShowingSuggestions
                                  ? ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 300,
                                      ),
                                      child: Container(
                                        width: 280,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: value.filteredUsers.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    value.filteredUsers[index]
                                                        .avatar!),
                                                radius: 25,
                                              ),
                                              title: Text(
                                                '${value.filteredUsers[index].firstName!} ${value.filteredUsers[index].lastName!}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              subtitle: Text(
                                                  "@${value.filteredUsers[index].username!}"),
                                              onTap: () {
                                                value.onSelectMention(
                                                    index, postcontent);
                                                if (!value.matchingUserIds
                                                    .contains(value
                                                        .filteredUsers[index]
                                                        .id)) {
                                                  value.matchingUserIds.add(
                                                      value.filteredUsers[index]
                                                          .id!);
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      selectedImage != null
                          ? SizedBox(
                              height: MediaQuery.sizeOf(context).height * .5,
                              width: MediaQuery.sizeOf(context).width,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.sizeOf(context).height * .5,
                                    width: MediaQuery.sizeOf(context).width,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 5,
                                      child: IconButton(
                                          style: IconButton.styleFrom(
                                            elevation: 4,
                                          ),
                                          onPressed: () {
                                            selectedImage = null;
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.cancel_rounded,
                                            color: Colors.white,
                                            size: 30,
                                          )))
                                ],
                              ),
                            )
                          : widget.videopath != null
                              ? containerVideo()
                              : audioFile != null
                                  ? VisibilityDetector(
                                      key: ObjectKey(audioPlayer),
                                      onVisibilityChanged:
                                          (VisibilityInfo visibility) {
                                        if (visibility.visibleFraction == 0 &&
                                            mounted) {
                                          audioPlayer
                                              .stop(); //pausing  functionality
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    audioPlayer.stop();

                                                    audioPlayer.dispose();
                                                    _durationstateInit();
                                                    audioFile = null;
                                                    setState(() {});
                                                  },
                                                  child: const Icon(
                                                    Icons.cancel_outlined,
                                                  )),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.transparent),
                                              child: _progressBar(),
                                            ),
                                            _playButton(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : multipleSelectedImages?.isNotEmpty == true
                                      ? GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 2.0,
                                                  mainAxisSpacing: 2.0),
                                          itemCount:
                                              multipleSelectedImages?.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailScreen(
                                                      withoutNetworkImage:
                                                          multipleSelectedImages![
                                                              i],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        .27,
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                5.0),
                                                        topLeft:
                                                            Radius.circular(
                                                                5.0),
                                                      ),
                                                      image: DecorationImage(
                                                          image: FileImage(
                                                              multipleSelectedImages![
                                                                  i]),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          multipleSelectedImages!
                                                              .removeAt(i);
                                                        });
                                                      },
                                                      icon: Icon(Icons.cancel,
                                                          color: Colors.white))
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : SizedBox(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              .27,
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//video place holder
  Widget containerVideo() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .5,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _videoPlayerController != null
              ? VideoPlayer(_videoPlayerController!)
              : Container(),
          Positioned(
              top: 0,
              right: 5,
              child: IconButton(
                  onPressed: () async {
                    _videoPlayerController?.value.isPlaying == true
                        ? _videoPlayerController?.pause()
                        : null;
                    _videoPlayerController?.dispose();
                    widget.videopath = null;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.white,
                    size: 30,
                  ))),
          isPlayingVideo == false
              ? IconButton(
                  onPressed: () {
                    _videoPlayerController?.play();
                    isPlayingVideo = true;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ))
              : IconButton(
                  onPressed: () {
                    _videoPlayerController?.pause();
                    isPlayingVideo = false;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.pause,
                    color: Colors.white,
                  ))
        ],
      ),
    );
  }

// bottom bar for post
  bottomContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              choseImage("Gallery");
            },
            icon: const Icon(
              Icons.collections_sharp,
              color: Colors.green,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {
              choseVideo("Gallery");
            },
            icon: const Icon(
              Icons.video_collection_sharp,
              size: 25,
              color: Colors.deepOrange,
            ),
          ),
          IconButton(
            onPressed: () {
              imagebottomSheet();
            },
            icon: const Icon(
              Icons.camera_alt_sharp,
              color: Colors.blue,
              size: 25,
            ),
          ),
          if (widget.pageId == null && widget.groupId == null) ...[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showPostUpdateDialog(context);
                  },
                );
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LocationScreen()));
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TagPeopleScreen(userid: getUsrData.id),
                    ));
              },
              icon: Icon(
                LineIcons.user_plus,
                color: Colors.blue[800],
                size: 22,
              ),
            ),
          ],
          InkWell(
            onTap: () {
              _modalBottomSheetMenu();
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black87, shape: BoxShape.circle),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> createPost({
    postcontent,
    video,
    File? photo,
    List<String>? mentionedUserIds,
    context,
    postMusic,
    privicy,
    thumbnailpath,
    List<File>? multipleImages,
    Location? location,
  }) async {
    final postProviderPro = Provider.of<PostProvider>(context, listen: false);

    try {
      String mentionedUsers = mentionedUserIds!.join(",");
      log('Mentioned Users ${mentionedUsers.toString()}');
      var accessToken = getStringAsync("access_token");
      FormData? form;

      Map<String, dynamic> dataArray = {};

      if (selectedClassName != null) {
        dataArray['bg_color'] = selectedClassName;
      }
      if ((locationText != null && locationText != "")) {
        dataArray['post_location'] = locationText;
      }
      // if(location != null){
      //   dataArray['location'] = location.toMap();

      // }
      //  log('location : $location');

      if (mentionedUsers != '') {
        dataArray['mentioned_users'] = mentionedUsers;
      }

      if ((privicy != null && privicy != "" && privicy != 0)) {
        dataArray['privacy'] = privicy;
      }
      if (postProviderPro.taggedUserIds.isNotEmpty) {
        String formattedOptions = postProviderPro.taggedUserIds.join(", ");
        print('tagged users : $formattedOptions');
        dataArray['tagged_users'] = formattedOptions;
      }
      if ((privicy != null && privicy != "" && privicy != 0)) {
        dataArray['privacy'] = privicy;
      }

      if ((postcontent != null && postcontent != "")) {
        dataArray['post_text'] = postcontent;
      }

      // if ((location != null && location != "")) {
      //   log('locationnnn : ${location.toJson().toString()}');
      //   dataArray['post_text'] = location.toJson().toString();
      //   dataArray['post_location'] =
      //       location.address.trim().split(" ").first.toString();
      // }

      if (multipleImages != null) {
        List<MultipartFile> files = [];
        if (multipleImages.length == 1) {
          String? mimeType1 = mime(multipleImages[0].path);
          String mimee1 = mimeType1!.split('/')[0];
          String type1 = mimeType1.split('/')[1];
          try {
            dataArray['images[]'] = await MultipartFile.fromFile(
              multipleImages[0].path,
              contentType: MediaType(mimee1, type1),
            );
          } catch (e) {
            // Handle any exceptions that occur when creating the MultipartFile
            print('Error creating MultipartFile: $e');
          }
        } else {
          for (int i = 0; i < multipleImages.length; i++) {
            String? mimeType1 = mime(multipleImages[i].path);
            String mimee1 = mimeType1!.split('/')[0];
            String type1 = mimeType1.split('/')[1];
            try {
              files.add(await MultipartFile.fromFile(
                multipleImages[i].path,
                filename: multipleImages[i].path.split('/').last,
                contentType: MediaType(mimee1, type1),
              ));
            } catch (e) {
              // Handle any exceptions that occur when creating the MultipartFile
              print('Error creating MultipartFile: $e');
            }
          }
          dataArray['images[]'] = files;
        }
      }
      if (audioFile != null) {
        String? mimeType1 = mime(audioFile!.path);
        String mimee1 = mimeType1!.split('/')[0];
        String type1 = mimeType1.split('/')[1];
        log('Audio Data ${audioFile!.path} $mimee1 $type1');
        try {
          dataArray['audio'] = await MultipartFile.fromFile(
            audioFile!.path,
            filename: audioFile!.path.split('/').last,
            contentType: MediaType(mimee1, type1),
          );
        } catch (e) {
          // Handle any exceptions that occur when creating the MultipartFile
          print('Error creating MultipartFile: $e');
        }
      }
      if (photo != null) {
        String? mimeType1 = mime(photo.path);
        String mimee1 = mimeType1!.split('/')[0];
        String type1 = mimeType1.split('/')[1];
        dataArray['images[]'] = await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
          contentType: MediaType(mimee1, type1),
        );
      }

      if (widget.groupId != null) {
        dataArray["group_id"] = widget.groupId;
      }

      if (widget.pageId != null) {
        dataArray["page_id"] = widget.pageId;
      }

      if (cancelToken.isCancelled == true) {
        cancelToken = CancelToken();
      }

      if (video != null) {
        final mimeType = mime(video);
        if (mimeType != null) {
          final mimeParts = mimeType.split('/');
          if (mimeParts.length == 2) {
            final mimee = mimeParts[0];
            final type = mimeParts[1];

            dataArray['video'] = await MultipartFile.fromFile(
              video,
              filename: video.split('/').last,
              contentType: MediaType(mimee, type),
            );

            final imageData = mime(widget.videoThumbnail);

            if (imageData != null) {
              final imageParts = imageData.split('/');
              if (imageParts.length == 2) {
                final thumbNailName = imageParts[0];
                final thumbNailType = imageParts[1];

                dataArray['video_thumbnail'] = await MultipartFile.fromFile(
                  widget.videoThumbnail!,
                  filename: widget.videoThumbnail!.split('/').last,
                  contentType: MediaType(thumbNailName, thumbNailType),
                );
              }
            }
          }
        }
      }

      form = FormData.fromMap(dataArray);
      overlayDisplay(context);

      if (audioFile != null) {
        Provider.of<PostProvider>(context, listen: false).isAudioData = true;
      }

      try {
        Response response = await dioService.dio.post(
          "post/create",
          data: form,
          cancelToken: cancelToken,
          onSendProgress: (int sent, int total) async {
            _upload = (sent / total * 100);
            progressValue.value = _upload.ceilToDouble();
          },
          options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
        );

        return response.data;
      } on DioException catch (e) {
        return e.response?.data;
      }
    } catch (e) {
      toast(e.toString());
    }
  }

  void _fetchData(BuildContext context) async {
    final mentionProvider =
        Provider.of<MentionProvider>(context, listen: false);
    int updatePrivacy = data.indexOf(privacydata) + 1;
    dynamic res = await createPost(
      postcontent: postcontent.text.trim(),
      video: widget.videopath,
      context: context,
      multipleImages: multipleSelectedImages,
      photo: selectedImage,
      thumbnailpath: widget.videoThumbnail,
      mentionedUserIds: mentionProvider.matchingUserIds,
      privicy: updatePrivacy,
      location: widget.location,
    );
    if (res['code'] == '200') {
      var data = res;
      var productsData = data["data"];
      var postsData = post.Posts.fromJson(productsData);
      if (audioFile == null) {
        if (mounted) {
          Provider.of<PostProvider>(context, listen: false)
              .insertAtIndex(index: 0, data: postsData, context: context);
        }

        if (widget.flag == true) {
          context
              .read<PostProviderTemp>()
              .insertAtIndex(index: 0, data: postsData, context: context);
        }
      }

      audioPlayer.dispose();
      _videoPlayerController?.dispose();
      final greetingsProvider =
          Provider.of<GreetingsProvider>(context, listen: false);
      greetingsProvider.setCurrentTabIndex(index: 0);
      Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TabsPage()))
          .then((value) {});
    } else {
      toast('Error: create post ${res['message']}', length: Toast.LENGTH_LONG);
    }
  }

  // Camera
  imagebottomSheet() {
    return showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
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
              InkWell(
                onTap: () {
                  choseVideo("camera");
                  Navigator.pop(context);
                },
                child: IconTile(
                  icon: Icon(
                    Icons.video_call_rounded,
                    color: Colors.blue,
                  ),
                  title: translate(context, 'video')!,
                ),
              ),
              InkWell(
                onTap: () {
                  choseImage("camera");
                  Navigator.pop(context);
                },
                child: IconTile(
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.blue,
                  ),
                  title: translate(context, 'photo')!,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// audio player progress bar
  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
      stream: _durationState,
      builder: (context, snapshot) {
        log("Snaapd Dataf df=> ${snapshot.data?.progress}");
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: (duration) {
            audioPlayer.seek(duration);
          },
          onDragUpdate: (details) {
            debugPrint(
                'Debug priny dta ${details.timeStamp}, ${details.localPosition}');
          },
          baseBarColor: Colors.grey,
          progressBarColor: Colors.green[500],
          bufferedBarColor: Colors.green[200],
          thumbColor: Colors.green,
          thumbGlowColor: Colors.green[100],
        );
      },
    );
  }

  // audio player
  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 32.0,
            onPressed: audioPlayer.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 32.0,
            onPressed: audioPlayer.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 32.0,
            onPressed: () => audioPlayer.seek(Duration.zero),
          );
        }
      },
    );
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
