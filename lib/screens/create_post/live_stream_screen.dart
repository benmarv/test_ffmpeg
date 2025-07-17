// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:link_on/utils/agora_token_generator.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen(
      {super.key,
      this.isHome,
      this.userId,
      this.token,
      this.channelName,
      this.avatar,
      this.isVerified,
      this.loggedInUser,
      this.username});
  final bool? isHome;
  final String? userId;
  final String? token;
  final String? channelName;
  final String? username;
  final String? avatar;
  final String? isVerified;
  final String? loggedInUser;

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen>
    with WidgetsBindingObserver {
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  final _channelMessageController = TextEditingController();
  int? _remoteUid;
  // bool _localUserJoined = false;
  bool _loginSuccess = false;
  bool _isMuted = false;
  bool _isFrontCamera = true;
  int liveFrameRate = 15;
  int liveWeight = 640;
  int liveHeight = 480;
  int? _localUserId;
  final List<int> _remoteUids = [];

  Future<void> initAgora() async {
    // Request permissionsl
    var statusMicrophone = await Permission.microphone.request();
    var statusCamera = await Permission.camera.request();
    if (Platform.isAndroid) {
      // Check if permissions are granted
      if (!statusMicrophone.isGranted || !statusCamera.isGranted) {
        toast('Please grant camera and mic permissions!');
        // If permissions are not granted, pop from the screen
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
    }

    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (mounted) {
            setState(() {
              // _localUserJoined = true;
              _localUserId = connection.localUid ?? 1;
              if (widget.isHome == false) {
                if (!_remoteUids.any((post) => post == connection.localUid)) {
                  _remoteUids.add(connection.localUid ?? 1);
                  log('local user id : $_localUserId');
                  Provider.of<LiveStreamProvider>(context, listen: false)
                      .addMemberUid(
                          userId: widget.loggedInUser,
                          agoraUid: connection.localUid,
                          action: 'add',
                          channelName: widget.channelName);
                }
              }
            });
          }
        },
        onLeaveChannel: (connection, stats) {
          if (mounted) {
            log('onLeaveChannel local user id : ${connection.localUid}');
            Provider.of<LiveStreamProvider>(context, listen: false)
                .endLiveStreamApi();
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (mounted) {
            log('remote user id $_remoteUid');
            setState(() {
              if (!_remoteUids.any((post) => post == remoteUid)) {
                _remoteUids.add(remoteUid);
              }
              _remoteUid = remoteUid;
            });
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          log('onUserOffline local user id :$remoteUid ${connection.localUid}');
          setState(() {
            _remoteUids.remove(remoteUid); // Remove the UID from the list
            _remoteUid = null;
            Provider.of<LiveStreamProvider>(context, listen: false)
                .addMemberUid(
                    userId: widget.loggedInUser,
                    agoraUid: remoteUid,
                    action: 'remove',
                    channelName: widget.channelName);
            if (widget.isHome == true) {
              Navigator.pop(context);
              Provider.of<LiveStreamProvider>(context, listen: false)
                  .removeLiveUser(userId: widget.userId!);
            } else {}
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {},
      ),
    );

    VideoEncoderConfiguration videoConfig = VideoEncoderConfiguration(
        frameRate: liveFrameRate,
        dimensions: VideoDimensions(width: liveWeight, height: liveHeight));

    // Apply the configuration
    await _engine.setVideoEncoderConfiguration(videoConfig);
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();

    // Set channel options
    ChannelMediaOptions options;

    if (widget.isHome == true) {
      // audience

      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    } else {
      // host

      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await _engine.startPreview();
    }

    AgoraTokenGenerator.generateAgoraRTCToken(widget.channelName!)
        .then((value) async {
      await _engine.joinChannel(
        token: value,
        channelId: widget.channelName!,
        uid: getStringAsync("user_id").toInt(),
        options: options,
      );
    });

    await _engine.setVideoEncoderConfiguration(videoConfig);
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onError = (error) {
        log("Channel error: $error");
      };
      channel.onMemberCountUpdated = (int memberCount) {
        Provider.of<LiveStreamProvider>(context, listen: false)
            .getLiveMemberCount(memberCount);

        log("channel.onMemberCountUpdated user id : $memberCount");
      };
      channel.onAttributesUpdated = (List<RtmChannelAttribute> attributes) {
        log("Channel attributes updated: ${attributes.toString()}");
      };
      channel.onMemberLeft = (member) {
        log("channel.onMemberLeft user id: ${member.userId}");
      };
      channel.onMemberJoined = (member) {
        log("channel.onMemberJoined user id: ${member.userId}");
      };
      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        final pro = Provider.of<LiveStreamProvider>(context, listen: false);
        // Split the message into its components
        List<String> parts = message.text.split("|");

        // Extract the data
        String content = parts[0];
        String avatar = parts[1];
        String name = parts[2];
        String verified = parts[3];
        String type = parts[4];

        if (type == 'message') {
          Message newMessage = Message(
              avatar: avatar,
              name: name,
              content: content,
              verified: verified,
              type: type);

          pro.addMessageInLiveChat(newMessage);
        } else if (type == 'gift') {
          Message gift = Message(
              content: content,
              avatar: avatar,
              name: name,
              verified: verified,
              type: type);
          pro.addGiftReceived(gift);
        } else if (type == 'request') {
          String userId = parts[5];
          String remoteUid = parts[6];

          if (widget.isHome == false) {
            LiveHostRequest newMessage = LiveHostRequest(
                userId: userId,
                remoteUserId: remoteUid,
                name: name,
                content: content,
                verified: verified,
                type: type);
            pro.hostLiveRequests(newMessage);
          }
        } else if (type == 'accepted') {
          String userId = parts[5];
          String remoteUid = parts[6];

          if (userId.trim() == widget.loggedInUser!.trim()) {
            log('request accepted inside if user id : $userId $remoteUid');

            setState(() {
              if (!_remoteUids.any((post) => post == int.parse(remoteUid))) {
                _remoteUids.add(int.parse(remoteUid));
                pro.addMemberUid(
                    userId: userId,
                    agoraUid: int.parse(remoteUid),
                    action: 'add',
                    channelName: widget.channelName);
              }

              _engine.setClientRole(
                  role: ClientRoleType.clientRoleBroadcaster,
                  options: const ClientRoleOptions());
              _engine.enableVideo();
              _engine.startPreview();
            });
          }
        }
      };
    }
    return channel;
  }

  void _accpetLiveVideoRequest({
    required String userId,
    required String remoteUserId,
  }) async {
    log('user id is : $userId $remoteUserId');
    try {
      RtmMessage? message = _client?.createRawMessage(Uint8List.fromList([]),
          'accepted your request|${getUsrData.avatar}|${getUsrData.username}|${getUsrData.isVerified}|accepted|$userId|$remoteUserId');
      if (message != null) {
        await _channel?.sendMessage2(message);
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Send channel message error: ${errorCode.reason}');
    }
  }

  void _sendRequestToComeLive() async {
    try {
      RtmMessage? message = _client?.createRawMessage(Uint8List.fromList([]),
          'is requesting to join Live|${getUsrData.avatar}|${getUsrData.username}|${getUsrData.isVerified}|request|${getStringAsync('user_id')}|$_localUserId');
      if (message != null) {
        log('user id send live request ${message.text}');
        await _channel?.sendMessage2(message);
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Send channel message error: ${errorCode.reason}');
    }
  }

  void _sendGiftToHost(int index) async {
    try {
      RtmMessage? message = _client?.createRawMessage(Uint8List.fromList([]),
          '$index|${getUsrData.avatar}|${getUsrData.username}|${getUsrData.isVerified}|gift');
      if (message != null) {
        log('user id send Gift To Host ${message.text}');
        await _channel?.sendMessage2(message);
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Send channel message error: ${errorCode.reason}');
    }
  }

  Future<String> _createClient() async {
    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;

    _client = await AgoraRtmClient.createInstance(agoraAppId);

    await _client?.setParameters('{"rtm.log_filter": 15}');
    await _client?.setLogFile('');
    await _client?.setLogFilter(RtmLogFilter.info);
    await _client?.setLogFileSize(10240);
    _client?.onError = (error) {
      log("Client error: $error");
    };
    _client?.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      log('Connection state changed: $state, reason: $reason');
    };

    _client?.onTokenExpired = () {
      log("Token expired");
    };
    _client?.onTokenPrivilegeWillExpire = () {
      log("Token privilege will expire");
    };

    var callManager = _client?.getRtmCallManager();
    callManager?.onError = (error) {
      log('Call manager error: $error');
    };

    log('agora rtm client initialized');
    return 'cc';
  }

  void _toggleLogin() async {
    String userId = getStringAsync('user_id');
    AgoraTokenGenerator.generateAgoraRTMToken().then((token) async {
      if (token != null) {
        try {
          await _client?.login(
            token,
            userId,
          );
          print('befor toggle join channel');
          _toggleJoinChannel();
          print('after toggle join channel');
          setState(() {});
          print('Login success: $userId');
        } catch (errorCode) {
          print('Login error: $errorCode');
        }
      } else {
        print("Token is null");
      }
    });
  }

  void _toggleJoinChannel() async {
    String channelId = widget.channelName!;
    log('agora rtm channel $channelId');
    if (channelId.isEmpty) {
      log('Please input channel id to join');
      return;
    }

    try {
      _channel = await _createChannel(channelId);
      await _channel?.join();
      log('agora rtm Join channel success');
      if (mounted) {
        setState(() {});
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Join channel error: ${errorCode.reason}');
    }
  }

  void _sendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.trim().isEmpty) {
      toast('Please input text to send');
      return;
    }
    try {
      RtmMessage? message = _client?.createRawMessage(Uint8List.fromList([]),
          '$text|${getUsrData.avatar!}|${getUsrData.username}|${getUsrData.isVerified}|message');
      if (message != null) {
        await _channel?.sendMessage2(message);

        // Split the message into its components
        List<String> parts = message.text.split("|");

        // Extract the data
        String content = parts[0];
        String avatar = parts[1];
        String name = parts[2];
        String verified = parts[3];
        String type = parts[3];

        Message newMessage = Message(
            avatar: avatar,
            name: name,
            content: content,
            verified: verified,
            type: type);
        Provider.of<LiveStreamProvider>(context, listen: false)
            .addMessageInLiveChat(newMessage);

        _channelMessageController.clear();
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Send channel message error: ${errorCode.reason}');
    }
  }

  Usr getUsrData = Usr();
  SiteSetting? site;
  @override
  void initState() {
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    _remoteUids.clear();
    WidgetsBinding.instance.addObserver(this);
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));
    initAgora();
    initEveryThing();
    if (widget.isHome == true) {
    } else {
      Provider.of<LiveStreamProvider>(context, listen: false).goLiveApi(
          agoraAccessToken: widget.token,
          channelName: widget.channelName,
          type: 'live_stream',
          toUserId: getStringAsync('user_id'));
    }
    super.initState();
  }

  void initEveryThing() {
    _createClient().then((value) {
      _toggleLogin();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _remoteUids.clear();

      Provider.of<LiveStreamProvider>(context, listen: false)
          .endLiveStreamApi();
    } else if (state == AppLifecycleState.inactive) {
      // if (_localUserJoined) {
      // Navigator.pop(context);
      // Provider.of<LiveStreamProvider>(context, listen: false)
      //     .endLiveStreamApi();
      // }
    }
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    _client?.release();
    if (widget.isHome == true) {
      _channelMessageController.dispose();
    }
    if (mounted) {
      await _engine.release().then((value) {
        Provider.of<LiveStreamProvider>(context, listen: false)
            .endLiveStreamApi();
        _remoteUids.clear();
      });
    }
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double kCount = count / 1000;
      return '${kCount.toStringAsFixed(1)}k';
    } else {
      return count.toString();
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _endCall() async {
    await _engine.leaveChannel();
    _client?.release();
    _channelMessageController.dispose();
    if (mounted) {
      Provider.of<LiveStreamProvider>(context, listen: false)
          .endLiveStreamApi();
    }
  }

  void _switchCamera() {
    _engine.switchCamera();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("remote user ids : $_remoteUids");
    Widget remoteVideo() {
      if (_remoteUids.isNotEmpty) {
        // Determine the layout based on the number of remote UIDs
        if (_remoteUids.length == 1) {
          // Single user, take the entire screen
          if (widget.isHome == true) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.8,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUids[0]),
                  connection: RtcConnection(channelId: widget.channelName!),
                ),
              ),
            );
          } else {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.8,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            );
          }
        } else if (_remoteUids.length == 2) {
          // Two users, one on top and one on bottom
          return Column(
            children: [
              if (widget.isHome == false) ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ],
              if (widget.isHome == true) ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    onAgoraVideoViewCreated: (viewId) {
                      log('0 : remote user id ${_remoteUids[0]}');
                    },
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUids[0]),
                      connection: RtcConnection(channelId: widget.channelName!),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    onAgoraVideoViewCreated: (viewId) {
                      log('1 : remote user id ${_remoteUids[1]}');
                    },
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUids[1]),
                      connection: RtcConnection(channelId: widget.channelName!),
                    ),
                  ),
                ),
              ],
              if (widget.isHome == true) ...[
                if (_remoteUid != _remoteUids[1]) ...[
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AgoraVideoView(
                      onAgoraVideoViewCreated: (viewId) {
                        log('1 : remote user id ${_remoteUids[1]}');
                      },
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(uid: _remoteUids[1]),
                        connection:
                            RtcConnection(channelId: widget.channelName!),
                      ),
                    ),
                  ),
                ]
              ]
            ],
          );
        } else if (_remoteUids.length == 3) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_remoteUids.any((element) => element == _localUserId)) ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    onAgoraVideoViewCreated: (viewId) {
                      log('1 : remote user id ${_remoteUids[1]}');
                    },
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUids[1]),
                      connection: RtcConnection(channelId: widget.channelName!),
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isHome == false &&
                      _localUserId == _remoteUids[0]) ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('2 : remote user id ${_remoteUids[2]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[2]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('0 : remote user id ${_remoteUids[0]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[0]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ],
                  if (_remoteUid != _remoteUids[1] &&
                      widget.isHome == true) ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('2 : remote user id ${_remoteUids[2]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[2]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('1 : remote user id ${_remoteUids[1]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[1]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_remoteUids.any((element) => element == _localUserId)) ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AgoraVideoView(
                    onAgoraVideoViewCreated: (viewId) {
                      log('1 : remote user id ${_remoteUids[1]}');
                    },
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUids[1]),
                      connection: RtcConnection(channelId: widget.channelName!),
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 2 (is host)
                  if (widget.isHome == false &&
                      _localUserId == _remoteUids[0]) ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('2 : remote user id ${_remoteUids[2]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[2]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ] else ...[
                    // 0 (is audience)
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('0 : remote user id ${_remoteUids[0]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[0]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ],
                  if (_remoteUid != _remoteUids[1] &&
                      widget.isHome == true) ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('2 : remote user id ${_remoteUids[2]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[2]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ] else ...[
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      width: MediaQuery.sizeOf(context).width * 0.44,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AgoraVideoView(
                        onAgoraVideoViewCreated: (viewId) {
                          log('1 : remote user id ${_remoteUids[1]}');
                        },
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[1]),
                          connection:
                              RtcConnection(channelId: widget.channelName!),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          );
        }
      } else {
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Connecting...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
      }
    }

    final bottom = Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 5,
        bottom: Platform.isIOS ? 15 : 5,
      ),
      child: TextField(
        controller: _channelMessageController,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            hintText: translate(context, 'type_your_message'),
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: IconButton(
              onPressed: _sendChannelMessage,
              icon: const Icon(
                LineIcons.address_card,
                color: AppColors.primaryColor,
                size: 26,
              ),
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            )),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr, // Force LTR direction for this screen
      child: PopScope(
        onPopInvoked: (didPop) {
          Provider.of<LiveStreamProvider>(context, listen: false)
              .endLiveStreamApi();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Consumer<LiveStreamProvider>(
              builder: (context, liveStreamProviderValue, child) => Stack(
                children: [
                  remoteVideo(),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                'Live',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    formatCount(liveStreamProviderValue
                                        .liveMemberCount),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.isHome == true) ...[
                          InkWell(
                            onTap: () {
                              liveStreamProviderValue.getHostsApi(
                                  channelName: widget.channelName);
                              showModalBottomSheet(
                                isDismissible: true,
                                isScrollControlled: true,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                builder: (context) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      child: Consumer<LiveStreamProvider>(
                                        builder: (context,
                                            liveStreamProviderValue, child) {
                                          return liveStreamProviderValue
                                                  .hostUserData.isEmpty
                                              ? const CircularProgressIndicator()
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                      bottomSheetTopDivider(
                                                          color: AppColors
                                                              .primaryColor),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Text(
                                                        "Select Host to donate",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            liveStreamProviderValue
                                                                .hostUserData
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return
                                                              // liveStreamProviderValue
                                                              //         .liveHostRequests
                                                              //         .isEmpty
                                                              //     ? const Center(
                                                              //         child: Text(
                                                              //           'No Requests Yet...',
                                                              //           style: TextStyle(
                                                              //               fontSize: 12),
                                                              //         ),
                                                              //       )
                                                              //     :
                                                              ListTile(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              showModalBottomSheet(
                                                                isDismissible:
                                                                    true,
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        topRight:
                                                                            Radius.circular(10))),
                                                                builder:
                                                                    (context) {
                                                                  return Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            10,
                                                                      ),
                                                                      child: Column(
                                                                          mainAxisSize: MainAxisSize
                                                                              .min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            bottomSheetTopDivider(color: AppColors.primaryColor),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            const Text(
                                                                              "Send Gifts",
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 100,
                                                                              child: ListView.builder(
                                                                                scrollDirection: Axis.horizontal,
                                                                                shrinkWrap: true,
                                                                                itemCount: site!.gifts!.length,
                                                                                itemBuilder: (context, giftIndex) {
                                                                                  return GestureDetector(
                                                                                    onTap: () {
                                                                                      liveStreamProviderValue.sendGift(context: context, giftId: site!.gifts![giftIndex].id!, hostUserId: liveStreamProviderValue.hostUserData[index].id!, giftUrl: site!.gifts![giftIndex].lottie_animation!).then((value) {
                                                                                        if (value!) {
                                                                                          _sendGiftToHost(giftIndex);
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right: 20),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Container(
                                                                                            height: 50,
                                                                                            width: 50,
                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey[300]),
                                                                                            child: Image(
                                                                                              image: NetworkImage(site!.gifts![giftIndex].image!),
                                                                                              fit: BoxFit.cover,
                                                                                              height: 30,
                                                                                              width: 30,
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          Text(
                                                                                            site!.gifts![giftIndex].name!,
                                                                                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 5,
                                                                                          ),
                                                                                          Text(
                                                                                            "\$${site!.gifts![giftIndex].price!}",
                                                                                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            )
                                                                          ]));
                                                                },
                                                              );
                                                            },
                                                            title: Text(
                                                              "${liveStreamProviderValue.hostUserData[index].firstName} ${liveStreamProviderValue.hostUserData[index].lastName}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            subtitle:
                                                                const Text(
                                                              'Host',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            trailing: const Icon(
                                                                LineIcons
                                                                    .dollar_sign),
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              backgroundImage: NetworkImage(
                                                                  liveStreamProviderValue
                                                                      .hostUserData[
                                                                          index]
                                                                      .avatar!),
                                                              radius: 20,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ]);
                                        },
                                      ));
                                },
                              );
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin:
                                    const EdgeInsets.only(right: 0, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  LineIcons.gift,
                                  color: Colors.white,
                                  size: 16,
                                )),
                          ),
                        ],
                        if (widget.isHome == false) ...[
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                isDismissible: true,
                                isScrollControlled: true,
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                builder: (context) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      child: Consumer<LiveStreamProvider>(
                                        builder: (context,
                                            liveStreamProviderValue, child) {
                                          return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                bottomSheetTopDivider(
                                                    color:
                                                        AppColors.primaryColor),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text(
                                                  "Requests",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      liveStreamProviderValue
                                                          .liveHostRequests
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return liveStreamProviderValue
                                                            .liveHostRequests
                                                            .isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                              'No Requests Yet...',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          )
                                                        : ListTile(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            title: Text(
                                                              liveStreamProviderValue
                                                                  .liveHostRequests[
                                                                      index]
                                                                  .name,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            subtitle: Text(
                                                              liveStreamProviderValue
                                                                  .liveHostRequests[
                                                                      index]
                                                                  .content,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            trailing: _remoteUids
                                                                        .length ==
                                                                    3
                                                                ? const SizedBox
                                                                    .shrink()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      // send notifiaction to user that requested for hosting that host accepted his request
                                                                      _accpetLiveVideoRequest(
                                                                          userId: liveStreamProviderValue
                                                                              .liveHostRequests[
                                                                                  index]
                                                                              .userId,
                                                                          remoteUserId: liveStreamProviderValue
                                                                              .liveHostRequests[index]
                                                                              .remoteUserId);
                                                                      Navigator.pop(
                                                                          context);
                                                                      liveStreamProviderValue.removeHostLiveRequests(liveStreamProviderValue
                                                                          .liveHostRequests[
                                                                              index]
                                                                          .userId);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          color:
                                                                              AppColors.primaryColor),
                                                                      child:
                                                                          const Text(
                                                                        'Accept',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    )),
                                                            leading:
                                                                const CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              // backgroundImage:NetworkImage(liveStreamProviderValue.liveHostRequests[index].avatar,),
                                                              radius: 20,
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ]);
                                        },
                                      ));
                                },
                              );
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin:
                                    const EdgeInsets.only(right: 0, top: 10),
                                decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                )),
                          ),
                        ]
                      ],
                    ),
                  ),
                  if (liveStreamProviderValue.giftsReceived.isNotEmpty) ...[
                    AnimatedPositioned(
                        right: liveStreamProviderValue.giftReceived ? 16 : -120,
                        top: MediaQuery.sizeOf(context).height * 0.15,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut, // Animation curve
                        child: Container(
                          height: 30,
                          width: 130,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black.withOpacity(0.5)),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          liveStreamProviderValue
                                              .giftsReceived[0].avatar),
                                      fit: BoxFit.cover),
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${liveStreamProviderValue.giftsReceived[0].name}   1x',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                              LottieBuilder.network(
                                height: 20,
                                width: 20,
                                liveStreamProviderValue.giftSelected.toString(),
                                alignment: Alignment.center,
                                onLoaded: (p0) {
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    liveStreamProviderValue.removeGiftMessage();
                                  });
                                },
                                repeat: true,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        )),
                  ],
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(children: [
                          InkWell(
                            onTap: () {
                              // _dispose();
                              Provider.of<LiveStreamProvider>(context,
                                      listen: false)
                                  .endLiveStreamApi();
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  blurRadius: 7, // Blur radius
                                  offset: const Offset(
                                      0, 3), // Offset of the shadow)
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(widget.avatar!),
                                  fit: BoxFit.cover),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.username!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              widget.isVerified == "1"
                                  ? verified()
                                  : const SizedBox.shrink(),
                            ],
                          )
                        ])),
                  ),
                  if (widget.isHome == true && _remoteUids.length < 3)
                    Positioned(
                      top: 50,
                      left: 100,
                      child: InkWell(
                        onTap: () {
                          _sendRequestToComeLive();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            'Request',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  widget.isHome == false
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: _toggleMute,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Icon(
                                      _isMuted ? Icons.mic_off : Icons.mic,
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
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Icon(
                                      _isFrontCamera
                                          ? Icons.camera_rear
                                          : Icons.camera_front,
                                      size: 25,
                                      weight: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _endCall();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            spreadRadius: 3,
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
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
                        )
                      : const SizedBox.shrink(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.sizeOf(context).height * 0.1),
                      height: MediaQuery.sizeOf(context).height * 0.35,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: liveStreamProviderValue.liveChat.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      liveStreamProviderValue
                                          .liveChat[index].avatar),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              liveStreamProviderValue
                                                  .liveChat[index].name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          liveStreamProviderValue
                                                      .liveChat[index]
                                                      .verified ==
                                                  "1"
                                              ? verified()
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.6,
                                        child: Text(
                                            liveStreamProviderValue
                                                .liveChat[index].content,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (liveStreamProviderValue.giftSended == true) ...[
                    Center(
                      child: LottieBuilder.asset(
                        liveStreamProviderValue.giftSelected!,
                        alignment: Alignment.center,
                        repeat: false,
                        fit: BoxFit.cover,
                        onLoaded: (p0) {
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              liveStreamProviderValue.stopLottieAnimation();
                            },
                          );
                        },
                      ),
                    )
                  ],
                  if (widget.isHome == true && _loginSuccess) ...[
                    Align(alignment: Alignment.bottomCenter, child: bottom),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Message {
  final String avatar;
  final String name;
  final String content;
  final String verified;
  final String type;

  Message({
    required this.avatar,
    required this.name,
    required this.content,
    required this.verified,
    required this.type,
  });
}

class LiveHostRequest {
  final String userId;
  final String remoteUserId;
  final String name;
  final String verified;
  final String content;
  final String type;

  LiveHostRequest({
    required this.userId,
    required this.remoteUserId,
    required this.name,
    required this.verified,
    required this.content,
    required this.type,
  });
}
