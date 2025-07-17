// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/agora_token_generator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
    this.agoraToken,
    this.channelName,
    this.userId,
    this.userName,
    this.userAvatar,
  });
  final String? agoraToken;
  final String? channelName;
  final String? userId;
  final String? userName;
  final String? userAvatar;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isVideoMuted = false;
  bool _isFrontCamera = true;
  bool _isRemoteUserJoined = false;
  late Timer _callTimer;

  @override
  void initState() {
    initAgora();

    Provider.of<LiveStreamProvider>(context, listen: false).goLiveApi(
        agoraAccessToken: widget.agoraToken,
        channelName: widget.channelName!,
        type: 'video_call',
        toUserId: widget.userId);
    _callTimer = Timer(const Duration(seconds: 17), () {
      // Check if the remote user has joined
      if (!_isRemoteUserJoined) {
        // If not, navigate back
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  Future<void> initAgora() async {
    // Request permissions
    var statusMicrophone = await Permission.microphone.request();
    var statusCamera = await Permission.camera.request();

    // Check if permissions are granted
    if (!statusMicrophone.isGranted || !statusCamera.isGranted) {
      toast(translate(context, 'grant_camera_and_mic_permissions'));

      // If permissions are not granted, pop from the screen
      Navigator.pop(context);
      return;
    }
    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;

    // Create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
            _isRemoteUserJoined = true;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            Navigator.pop(context);
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    AgoraTokenGenerator.generateAgoraRTCToken(widget.channelName!)
        .then((token) async {
      await _engine.joinChannel(
        token: token,
        channelId: widget.channelName!,
        uid: getStringAsync("user_id").toInt(),
        options: const ChannelMediaOptions(),
      );
    });
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: widget.channelName!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        blurRadius: 7, // Blur radius
                        offset: const Offset(0, 3), // Offset of the shadow)
                      )
                    ],
                  ),
                ),
                Text(
                  translate(context, 'end_to_end_encrypted')!,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox.shrink()
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        blurRadius: 7, // Blur radius
                        offset: const Offset(0, 3), // Offset of the shadow)
                      )
                    ],
                  ),
                ),
                Text(
                  translate(context, 'end_to_end_encrypted')!,
                  style: const TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox.shrink()
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.userName ?? '',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 180,
            width: 180,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.userAvatar ?? getStringAsync("appLogo"),
                  ),
                )),
          ),
          const Spacer()
        ],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _callTimer.cancel();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _toggleVideoMute() {
    setState(() {
      _isVideoMuted = !_isVideoMuted;
    });
    _engine.muteLocalVideoStream(_isVideoMuted);
  }

  void _endCall() async {
    Navigator.pop(context);
    await _engine.leaveChannel();
  }

  void _switchCamera() {
    _engine.switchCamera();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  final GlobalKey _containerKey = GlobalKey();
  Offset _position = const Offset(0.0, 0.0);

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<LiveStreamProvider>(builder: (context, value, child) {
          if (value.isCallDeclined == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              value.isCallDeclinedFalseFunc();
            });
          } else {}
          return Stack(
            children: [
              Center(
                child: _remoteVideo(),
              ),
              Positioned(
                left: math.max(
                    0,
                    math.min(
                        _position.dx, MediaQuery.sizeOf(context).width - 120)),
                top: math.max(
                    0,
                    math.min(
                        _position.dy, MediaQuery.sizeOf(context).height - 300)),
                child: Draggable(
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      _position = offset;
                    });
                  },
                  feedback: Container(
                    key: _containerKey,
                    width: 100,
                    height: 150,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: _localUserJoined
                        ? _isVideoMuted == false
                            ? AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: _engine,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  child: Container(
                    key: _containerKey,
                    width: 100,
                    height: 150,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: _localUserJoined
                        ? _isVideoMuted == false
                            ? AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: _engine,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                              )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _toggleMute,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ], borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            _isMuted ? Icons.mic_off : Icons.mic,
                            size: 25,
                            weight: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleVideoMute,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ], borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            _isVideoMuted
                                ? Icons.videocam_off_rounded
                                : Icons.videocam_rounded,
                            size: 25,
                            weight: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _switchCamera,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ], borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.cameraswitch_outlined,
                            size: 25,
                            weight: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.call_end,
                            size: 25,
                            weight: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
