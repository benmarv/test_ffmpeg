// ignore_for_file: library_prefixes, use_build_context_synchronously
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/agora_token_generator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({
    Key? key,
    this.agoraToken,
    this.channelName,
    this.userName,
    this.userId,
    this.userAvatar,
  }) : super(key: key);
  final String? agoraToken;
  final String? channelName;
  final String? userId;
  final String? userName;
  final String? userAvatar;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isRemoteUserJoined = false;
  bool _isRemoteUserleft = false;
  Timer? _timer;
  int _seconds = 0;
  bool isSpeakerOn = false; // Default to speaker
  late Timer _callTimer;

  @override
  void initState() {
    initAgora();
    super.initState();
    _callTimer = Timer(const Duration(seconds: 17), () {
      if (!_isRemoteUserJoined) {
        Navigator.pop(context);
      }
    });
    Provider.of<LiveStreamProvider>(context, listen: false).goLiveApi(
        agoraAccessToken: widget.agoraToken,
        channelName: widget.channelName,
        type: 'audio_call',
        toUserId: widget.userId);
  }

  Future<void> initAgora() async {
    var statusMicrophone = await Permission.microphone.request();
    if (!statusMicrophone.isGranted) {
      toast(translate(context, 'please_grant_mic_permission'));
      Navigator.pop(context);
      return;
    }

    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.setDefaultAudioRouteToSpeakerphone(false);

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {});
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          _startTimer();
          setState(() {
            _isRemoteUserJoined = true;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _isRemoteUserleft = true;
          });
          Navigator.pop(context);
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();
    AgoraTokenGenerator.generateAgoraRTCToken(widget.channelName!)
        .then((value) async {
      await _engine.joinChannel(
          token: value,
          channelId: widget.channelName!,
          options: const ChannelMediaOptions(),
          uid: getStringAsync("user_id").toInt());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
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
  }

  void _toggleSpeaker() async {
    setState(() {
      isSpeakerOn = !isSpeakerOn;
    });
    if (isSpeakerOn) {
      await _engine.adjustPlaybackSignalVolume(400);
      _engine.setEnableSpeakerphone(true);
      _engine.setDefaultAudioRouteToSpeakerphone(true);
    } else {
      _engine.setEnableSpeakerphone(false);
      _engine.setDefaultAudioRouteToSpeakerphone(false);
    }
  }

  void _endCall() async {
    await _engine.leaveChannel();
    Navigator.pop(context);
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _seconds++;
        });
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      return n >= 10 ? "$n" : "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveStreamProvider>(
      builder: (context, value, child) {
        if (value.isCallDeclined == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
            value.isCallDeclinedFalseFunc();
          });
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
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
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              blurRadius: 7, // Blur radius
                              offset:
                                  const Offset(0, 3), // Offset of the shadow)
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
                Column(
                  children: [
                    Text(
                      widget.userName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _isRemoteUserleft
                        ? Text(
                            translate(context, 'user_left')!,
                            style: const TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w400,
                                fontSize: 24),
                          )
                        : _isRemoteUserJoined
                            ? Text(
                                _formatDuration(Duration(seconds: _seconds)),
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24),
                              )
                            : Text(
                                translate(context, 'dialing')!,
                                style: const TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24),
                              ),
                  ],
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
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _toggleSpeaker,
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
                              color: isSpeakerOn
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                            size: 25,
                            weight: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleMute,
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
                              color:
                                  _isMuted ? Colors.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            _isMuted ? Icons.mic_off : Icons.mic,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
