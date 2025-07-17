// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/components/spaces_widgets/space_ticket.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/spaces_model/spaces_model.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/real_estate/theme/color.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/screens/spaces/spaces_home/live_spaces.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/show_confirmation_dialogue.dart';
import 'package:link_on/screens/spaces/spaces_home/widgets/space_material_button.dart';
import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';
import 'package:link_on/utils/agora_token_generator.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MainSpaceScreen extends StatefulWidget {
  final bool isAudience;
  final String? channel;
  final SpaceModel spaceData;
  final Member? hostData;
  const MainSpaceScreen({
    super.key,
    required this.isAudience,
    this.channel,
    this.hostData,
    required this.spaceData,
  });

  @override
  State<MainSpaceScreen> createState() => _MainSpaceScreenState();
}

class _MainSpaceScreenState extends State<MainSpaceScreen>
    with WidgetsBindingObserver {
  late RtcEngine _engine;
  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  bool isMicMuted = false;
  bool isRequested = false;
  bool isCoHost = false;
  String currentSpeakerId = '';
  int currentSpeakerVolume = 0;
  Color borderColor = Colors.blue;
  late Timer timer;
  List<String> approvedCoHost = [];

  @override
  void initState() {
    final spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    initializeAgoraRtcEngine();
    initEveryThing();

    spaceProvider.requestQueue.clear();
    spaceProvider.getSpaceMembers(
      context: context,
      spaceId: widget.spaceData.id,
    );
    super.initState();
  }

  void initEveryThing() {
    _createClient().then((value) {
      _toggleLogin();
    });
  }

  Future<void> enableAudioVolumeIndication(
      {required int interval,
      required int smooth,
      required bool reportVad}) async {
    try {
      await _engine.enableAudioVolumeIndication(
          interval: interval, smooth: smooth, reportVad: reportVad);
    } catch (e) {
      log("Failed to enable audio volume indication: $e");
    }
  }

  Future<void> initializeAgoraRtcEngine() async {
    var permissionOfMicrophone = await Permission.microphone.request();
    if (!permissionOfMicrophone.isGranted) {
      toast('Allow access to microphone');
      Navigator.pop(context);
      return;
    }

    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;
    _engine = createAgoraRtcEngine();

    await _engine.initialize(
      RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await enableAudioVolumeIndication(
        interval: 1000, // Receive volume updates every second
        smooth: 3, // Moderately smooth changes
        reportVad: true // Report voice activity detection for the local user
        );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onAudioVolumeIndication:
            (connection, speakers, speakerNumber, totalVolume) {
          for (var speaker in speakers) {
            if (speaker.uid == 0) {
              sendMessageToChannel('Speaking:${speaker.volume}');
              log("UID ${speaker.uid} is talking, Volume: ${speaker.volume}");
            }
          }
        },
        onLeaveChannel: (connection, stats) {
          log('Channel Leaved');
          Provider.of<SpaceProvider>(context, listen: false).leaveSpace(
            context: context,
            spaceId: widget.spaceData.id,
          );
        },
      ),
    );

    if (!widget.isAudience) {
      await _engine.enableAudio(); // Enable audio only for broadcasters
    }

    AgoraTokenGenerator.generateAgoraRTCToken(widget.channel!)
        .then((token) async {
      await _engine.joinChannel(
        token: token,
        channelId: widget.channel!,
        uid: getStringAsync("user_id").toInt(),
        options: ChannelMediaOptions(
          clientRoleType: widget.isAudience
              ? ClientRoleType.clientRoleAudience
              : ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
    });
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

    _client?.onMessageReceived = (RtmMessage message, String peerId) async {
      final provider = Provider.of<SpaceProvider>(context, listen: false);
      if (message.text.startsWith('ApprovedCoHost')) {
        String jsonApprovedCoHostListFromHost = message.text.split(':')[1];
        List<dynamic> approvedCoHostReceived =
            jsonDecode(jsonApprovedCoHostListFromHost);
        log('Received host List $approvedCoHostReceived');
        setState(() {
          approvedCoHost =
              approvedCoHostReceived.map((e) => e as String).toList();
        });
        log('Received host List Final List ${approvedCoHost.toString()}');
      } else if (message.text == 'Request to Speak') {
        toast('You have received a new request');
        provider.addToRequestQueue(peerId);
      } else if (message.text == 'Remove my Request') {
        provider.removeFromRequestQueue(peerId);
      } else if (message.text == 'Remove From Host') {
        await removeFromHost();
        setState(() {
          isCoHost = false;
          isMicMuted = false;
        });
        toast('You are removed as a host by admin');
      } else if (message.text == 'Accept Request') {
        await allowToSpeak();
        setState(() {
          isCoHost = true;
          isRequested = false;
        });
        toast('Your Request to Speak Accepted');
      } else if (message.text == 'Reject Request') {
        toast('Your Request to Speak Rejected');
        setState(() {
          isRequested = false;
        });
      }
    };

    log('agora rtm client initialized');
    return 'cc';
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onError = (error) {
        log("Channel error: $error");
      };
      channel.onMemberCountUpdated = (int memberCount) {
        getSpaceMembers();
      };

      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        if (message.text.startsWith('BecomeBroadcaster')) {
          String userId = message.text.split(':')[1];
          setState(() {
            if (!approvedCoHost.contains(userId)) {
              approvedCoHost.add(userId);
            }
          });
        } else if (message.text.startsWith('BecomeAudience')) {
          String userId = message.text.split(':')[1];
          setState(() {
            if (approvedCoHost.contains(userId)) {
              approvedCoHost.remove(userId);
            }
          });
        } else if (message.text == 'LeavingSpaceAsHost') {
          log('Leaving Space As Cohost ${member.userId}');
          setState(() {
            if (approvedCoHost.contains(member.userId)) {
              approvedCoHost.remove(member.userId);
              if (member.userId == getStringAsync("user_id")) {
                isCoHost = false;
              }
            }
          });
        } else if (message.text.startsWith('Speaking')) {
          String userId = member.userId;
          int volume = int.parse(message.text.split(':')[1]);
          updateUIWithCurrentSpeaker(userId, volume);
        } else if (message.text == 'MicMuted') {
          String userId = member.userId;
          int volume = 0;
          updateUIWithCurrentSpeaker(userId, volume);
        }
      };
      channel.onMemberJoined = (RtmChannelMember member) {
        String jsonApprovedCoHostList = jsonEncode(approvedCoHost);
        log('Member ${member.userId}  $jsonApprovedCoHostList');
        if (!widget.isAudience) {
          log('Member Joined ${member.userId}');
          sendMessageToClient(
              member.userId, 'ApprovedCoHost:$jsonApprovedCoHostList');
        }
      };
      channel.onMemberLeft = (RtmChannelMember member) {
        updateUIWithCurrentSpeaker(member.userId, 0);
        Provider.of<SpaceProvider>(context, listen: false)
            .removeRequestQueue(member.userId);
        if (widget.hostData!.userId == member.userId) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SpacesHome(),
            ),
          );
          toast('The Admin has closed the space');
        }
      };
    }
    return channel;
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
    try {
      _channel = await _createChannel(widget.channel!);
      await _channel?.join();
      if (mounted) {
        setState(() {});
      }
    } on AgoraRtmChannelException catch (errorCode) {
      log('Join channel error: ${errorCode.reason}');
    }
  }

  Future<void> allowToSpeak() async {
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  Future<void> removeFromHost() async {
    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
  }

  void _toggleMic() async {
    setState(() {
      isMicMuted = !isMicMuted;
    });
    if (isMicMuted && isCoHost) {
      sendMessageToChannel('MicMuted');
    }
    _engine.muteLocalAudioStream(isMicMuted);
  }

  void getSpaceMembers() {
    Provider.of<SpaceProvider>(context, listen: false).getSpaceMembers(
      context: context,
      spaceId: widget.spaceData.id,
    );
  }

  void sendMessageToChannel(String messageText) async {
    RtmMessage message = RtmMessage.fromText(messageText);
    await _channel?.sendMessage2(message);
  }

  void sendMessageToClient(String peerId, String messageText) async {
    RtmMessage message = RtmMessage.fromText(messageText);
    await _client?.sendMessageToPeer2(
      peerId,
      message,
    );
  }

  void updateUIWithCurrentSpeaker(String userId, int volume) {
    setState(() {
      currentSpeakerId = userId;
      currentSpeakerVolume = volume;
    });
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _engine.leaveChannel();
    _client?.release();
    _channel?.leave();

    if (!widget.isAudience) {
      await _channel?.release();
    }
    if (!widget.isAudience) {
      await _engine.release();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      Provider.of<SpaceProvider>(context, listen: false).leaveSpace(
        context: context,
        spaceId: widget.spaceData.id,
      );
    } else if (state == AppLifecycleState.inactive) {
      Provider.of<SpaceProvider>(context, listen: false).leaveSpace(
        context: context,
        spaceId: widget.spaceData.id,
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showConfirmationDialog(
              context: context,
              title: widget.isAudience
                  ? translate(context, 'are_you_sure_to_leave_space')!
                  : translate(context, 'are_you_sure_to_close_space')!,
              yesText: translate(context, 'yes')!,
              noText: translate(context, 'no')!,
              onYes: () {
                if (widget.isAudience && isCoHost) {
                  setState(
                    () {
                      approvedCoHost.remove(getStringAsync("user_id"));

                      isCoHost = false;
                    },
                  );

                  removeFromHost();
                  sendMessageToChannel('LeavingSpaceAsHost');
                }
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpacesHome(),
                  ),
                );
              },
              onNo: () {
                Navigator.pop(context);
              },
            );

            // Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const SpacesHome(),
            //   ),
            // );
          },
          icon: const Icon(
            CupertinoIcons.back,
            size: 30,
          ),
        ),
        actions: [
          if (widget.spaceData.amount != '0')
            SpaceTicket(ticketAmount: widget.spaceData.amount),
          const SizedBox(
            width: 5,
          ),
          if (widget.spaceData.description != "" ||
              widget.spaceData.description!.isNotEmpty)
            IconButton(
              onPressed: () {
                customRoomRulesSheet(context);
              },
              icon: const Icon(Icons.info_outline),
            ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: PopScope(
        onPopInvoked: (didPop) {
          Provider.of<SpaceProvider>(context, listen: false)
              .leaveSpace(context: context, spaceId: widget.spaceData.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.spaceData.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              if (widget.isAudience) ...[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  translate(context, 'host')!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ClipOval(
                    child: CachedNetworkImage(
                      height: 120,
                      width: 120,
                      imageUrl: widget.hostData!.avatar!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "${widget.hostData!.firstName!} ${widget.hostData!.lastName!}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
              Consumer<SpaceProvider>(builder: (context, value, child) {
                List<Member> nonCoHostMembers = value.spaceMembers
                    .where((member) => !approvedCoHost.contains(member.userId))
                    .toList();
                List<Member> coHostMembers = value.spaceMembers
                    .where((member) => approvedCoHost.contains(member.userId))
                    .toList();
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (coHostMembers.isNotEmpty) ...[
                        Text(
                          translate(context, 'co_host')!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 0,
                            mainAxisExtent: 105,
                            mainAxisSpacing: 10.0,
                          ),
                          itemBuilder: (context, index) {
                            final Member listener = coHostMembers[index];

                            return MemberListTile(
                              listener: listener,
                              isCoHost: true,
                              isAudience: widget.isAudience,
                              currentSpeakerId: currentSpeakerId,
                              currentSpeakerVolume: currentSpeakerVolume,
                              onTap: () {
                                return shortProfileSheet(
                                    context, index, listener);
                              },
                              onLongPress: () async {
                                sendMessageToClient(
                                    listener.userId!, 'Remove From Host');
                                sendMessageToChannel(
                                    'BecomeAudience:${listener.userId}');
                                setState(() {
                                  approvedCoHost.remove(listener.userId);
                                });
                              },
                            );
                          },
                          itemCount: coHostMembers.length,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      Text(
                        translate(context, 'space_listeners')!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: nonCoHostMembers.isEmpty
                            ? coHostMembers.isEmpty
                                ? MediaQuery.sizeOf(context).height * 0.25
                                : widget.isAudience
                                    ? 20
                                    : MediaQuery.sizeOf(context).height * 0.2
                            : 10,
                      ),
                      nonCoHostMembers.isEmpty && value.loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : nonCoHostMembers.isEmpty && !value.loading
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    loading(),
                                    Text(
                                      translate(context, 'no_listeners_yet')!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 0,
                                    mainAxisExtent: 120,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemBuilder: (context, index) {
                                    final Member listener =
                                        nonCoHostMembers[index];
                                    return MemberListTile(
                                      listener: listener,
                                      isCoHost: false,
                                      isAudience: widget.isAudience,
                                      currentSpeakerId: currentSpeakerId,
                                      currentSpeakerVolume:
                                          currentSpeakerVolume,
                                      onTap: () {
                                        return shortProfileSheet(
                                          context,
                                          index,
                                          listener,
                                        );
                                      },
                                      onLongPress: () {
                                        sendMessageToClient(
                                          listener.userId!,
                                          'Remove From Host',
                                        );
                                        sendMessageToChannel(
                                          'BecomeAudience:${listener.userId}',
                                        );
                                        setState(
                                          () {
                                            approvedCoHost
                                                .remove(listener.userId);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  itemCount: nonCoHostMembers.length,
                                ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Container _bottomNavigationBar(BuildContext context) {
    final spaceProvider = Provider.of<SpaceProvider>(context, listen: true);
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                showConfirmationDialog(
                  context: context,
                  title: widget.isAudience
                      ? translate(context, 'are_you_sure_to_leave_space')!
                      : translate(context, 'are_you_sure_to_close_space')!,
                  yesText: translate(context, 'yes')!,
                  noText: translate(context, 'no')!,
                  onYes: () {
                    if (widget.isAudience && isCoHost) {
                      setState(() {
                        approvedCoHost.remove(getStringAsync("user_id"));

                        isCoHost = false;
                      });

                      removeFromHost();
                      sendMessageToChannel('LeavingSpaceAsHost');
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpacesHome(),
                      ),
                    );
                  },
                  onNo: () {
                    Navigator.pop(context);
                  },
                );
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppColor.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clear,
                          color: Colors.red,
                          size: 13,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.isAudience
                              ? translate(context, 'leave_space')!
                              : translate(context, 'end_space')!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.isAudience && !isCoHost)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: isRequested
                    ? null
                    // () async {
                    //     await sendMessageToClient(
                    //         widget.hostData!.userId!, 'Remove my Request');
                    //     setState(() {
                    //       isRequested = false;
                    //     });
                    //   }
                    : () {
                        sendMessageToClient(
                            widget.hostData!.userId!, 'Request to Speak');
                        toast(translate(context, 'request_sent_successfully')!);
                        setState(() {
                          isRequested = true;
                        });
                      },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        isRequested
                            ? translate(context, 'requested')!
                            : translate(context, 'request_to_talk')!,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!widget.isAudience)
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    requestedSpeakersSheet(context, spaceProvider);
                  },
                  child: Lottie.asset(
                    'assets/anim/raise_hand.json',
                    animate: false,
                    height: 60,
                    width: 70,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 0,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        spaceProvider.requestQueue.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          if (!widget.isAudience || isCoHost == true)
            GestureDetector(
              onTap: _toggleMic,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  AppColor.primary,
                  BlendMode.srcATop,
                ),
                child: isMicMuted
                    ? const SizedBox(
                        height: 80,
                        width: 70,
                        child: Icon(
                          CupertinoIcons.mic_slash_fill,
                          size: 43,
                        ),
                      )
                    : Lottie.asset(
                        'assets/anim/mic_on.json',
                        height: 80,
                        width: 70,
                      ),
              ),
            )
        ],
      ),
    );
  }

  Future shortProfileSheet(BuildContext context, int index, Member listener) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      context: context,
      builder: (context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          listener.avatar!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${listener.firstName!} ${listener.lastName!}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "@${listener.firstName}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SpaceMaterialButton(
                onPress: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileTab(
                        userId: listener.userId,
                      ),
                    ),
                  );
                },
                child: Text(
                  translate(context, 'visit_full_profile')!,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future requestedSpeakersSheet(
      BuildContext context, SpaceProvider spaceProvider) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<SpaceProvider>(
        builder: (context, spaceProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              children: [
                Text(
                  translate(context, 'requests_who_want_to_speak')!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(
                  thickness: 0.1,
                ),
                spaceProvider.requestQueue.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            translate(context, 'no_requests_found')!,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Member requestedMember =
                              spaceProvider.requestQueue[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(requestedMember.avatar!),
                            ),
                            title: Text(
                              requestedMember.firstName!,
                            ),
                            trailing: buildActionButtons(
                                context, spaceProvider, requestedMember),
                          );
                        },
                        itemCount: spaceProvider.requestQueue.length,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    SpaceProvider spaceProvider,
    Member requestedMember,
  ) {
    return SizedBox(
      width: 110,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              spaceProvider.removeFromRequestQueue(requestedMember.userId!);
              sendMessageToClient(
                requestedMember.userId!,
                'Reject Request',
              );
            },
            child: Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  translate(context, 'reject')!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              spaceProvider.removeFromRequestQueue(requestedMember.userId!);
              sendMessageToClient(
                requestedMember.userId!,
                'Accept Request',
              );
              sendMessageToChannel(
                'BecomeBroadcaster:${requestedMember.userId}',
              );

              setState(() {
                approvedCoHost.add(requestedMember.userId!);
              });
            },
            child: Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  translate(context, 'accept')!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future customRoomRulesSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      context: context,
      showDragHandle: true,
      builder: (context) => Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.5,
        ),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'space_description')!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.spaceData.description!)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberListTile extends StatelessWidget {
  final Member listener;
  final bool isCoHost;
  final String currentSpeakerId;
  final int currentSpeakerVolume;
  final bool isAudience;
  final Function onTap;
  final VoidCallback onLongPress;

  const MemberListTile({
    super.key,
    required this.listener,
    required this.isCoHost,
    required this.isAudience,
    required this.onTap,
    required this.onLongPress,
    required this.currentSpeakerId,
    required this.currentSpeakerVolume,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: _getBorderWidth(context),
                      color: _getBorderColor(context)!,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: listener.avatar!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isCoHost && !isAudience)
                  Positioned(
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.red.withOpacity(1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: onLongPress,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              listener.firstName!,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getBorderColor(BuildContext context) {
    if (currentSpeakerId == listener.userId && currentSpeakerVolume > 100) {
      return Colors.red;
    } else if (isCoHost) {
      return Colors.red[500];
    } else {
      return Colors.transparent;
    }
  }

  double _getBorderWidth(BuildContext context) {
    if (currentSpeakerId == listener.userId && currentSpeakerVolume > 100) {
      return 3;
    } else if (isCoHost) {
      return 0.5;
    } else {
      return 0;
    }
  }
}
