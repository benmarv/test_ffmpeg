// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/utils/agora_token_generator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/MessagesProvider/get_messages_api.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/screens/message_details.dart/audio_call.dart';
import 'package:link_on/screens/message_details.dart/chat_bubble.dart';
import 'package:link_on/screens/message_details.dart/video_call.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/utils/utils.dart';
import 'package:video_compress/video_compress.dart';

class AgoraMessaging extends StatefulWidget {
  const AgoraMessaging({
    Key? key,
    this.userId,
    this.userAvatar,
    this.userFirstName,
    this.userLastName,
  }) : super(key: key);

  final String? userId;
  final String? userAvatar;
  final String? userFirstName;
  final String? userLastName;

  @override
  AgoraMessagingState createState() => AgoraMessagingState();
}

class AgoraMessagingState extends State<AgoraMessaging> {
  final _channelMessageController = TextEditingController();

  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    log('Selected Image File is ${image}');
    if (image != null) {
      File imageFile = File(image.path);
      try {
        RtmMessage? message =
            _client?.createRawMessage(Uint8List.fromList([]), 'sendImage');
        if (message != null) {
          await _channel?.sendMessage2(message);

          Provider.of<GetMessagesApiprovider>(context, listen: false)
              .sendMessage(
            userId: widget.userId,
            media_type: '1',
            media: imageFile,
            thumbnail: imageFile,
          );
        }
      } catch (errorCode) {
        print('Send channel message error: $errorCode');
      }
    }
  }

  void _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      File videoFile = File(video.path);
      try {
        RtmMessage? message =
            _client?.createRawMessage(Uint8List.fromList([]), 'sendVideo');
        if (message != null) {
          await _channel?.sendMessage2(message);

          VideoCompress.getFileThumbnail(video.path, quality: 60)
              .then((thumbnail) {
            log('Thumnail path is ${thumbnail.path}');

            Provider.of<GetMessagesApiprovider>(context, listen: false)
                .sendMessage(
              userId: widget.userId,
              media_type: '2',
              media: videoFile,
              thumbnail: thumbnail,
            );
          });
        }
      } catch (errorCode) {
        print('Send channel message error: $errorCode');
      }
    }
  }

  Future<AgoraRtmClient?> _createClient() async {
    final String agoraAppId = dotenv.env['AGORA_APP_ID']!;

    try {
      _client = await AgoraRtmClient.createInstance(agoraAppId);
      log('Agora RTM client successfully created');
    } catch (e) {
      log('Error creating Agora RTM client: $e');
      return null;
    }

    await _client?.setParameters('{"rtm.log_filter": 15}');
    // await _client?.setLogFile('');
    await _client?.setLogFilter(RtmLogFilter.info);
    await _client?.setLogFileSize(10240);
    _client?.onError = (error) {
      print("Client error: $error");
    };
    _client?.onConnectionStateChanged2 =
        (RtmConnectionState state, RtmConnectionChangeReason reason) {
      print('Connection state changed: $state, reason: $reason');
    };
    _client?.onMessageReceived = (RtmMessage message, String peerId) {
      print("Peer msg: $peerId, msg: ${message.messageType} ${message.text}");
    };
    _client?.onTokenExpired = () {
      print("Token expired");
    };
    _client?.onTokenPrivilegeWillExpire = () {
      print("Token privilege will expire");
    };

    var callManager = _client?.getRtmCallManager();
    callManager?.onError = (error) {
      print('Call manager error: $error');
    };

    print('Agora RTM client initialized');
    return _client;
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
          _toggleJoinChannel();
          print('Login success: $userId');
        } catch (errorCode) {
          print('Login error: $errorCode');
        }
      } else {
        print("Token is null");
      }
    });
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client?.createChannel(name);
    if (channel != null) {
      channel.onError = (error) {
        print("Channel error: $error");
      };
      channel.onMemberCountUpdated = (int memberCount) {
        print("Member count updated: $memberCount");
      };
      channel.onAttributesUpdated = (List<RtmChannelAttribute> attributes) {
        print("Channel attributes updated: ${attributes.toString()}");
      };
      channel.onMessageReceived =
          (RtmMessage message, RtmChannelMember member) {
        log("message received : ${message.text}");
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Provider.of<GetMessagesApiprovider>(context, listen: false)
                .messages(recipientId: widget.userId, fromAgora: true);
          },
        );
      };
      channel.onMemberJoined = (RtmChannelMember member) {
        print('Member joined: ${member.userId}, channel: ${member.channelId}');
      };
      channel.onMemberLeft = (RtmChannelMember member) {
        print('Member left: ${member.userId}, channel: ${member.channelId}');
      };
    }
    return channel;
  }

  String orderNumbers(String num1Str, String num2Str) {
    int num1 = int.parse(num1Str);
    int num2 = int.parse(num2Str);
    if (num1 < num2) {
      return '$num1$num2';
    } else {
      return '$num2$num1';
    }
  }

  void _toggleJoinChannel() async {
    String channelId = orderNumbers(widget.userId!, getStringAsync('user_id'));

    if (channelId.isEmpty) {
      print('Please input channel id to join');
      return;
    }

    try {
      _channel = await _createChannel(channelId);
      await _channel?.join();
      print('Agora RTM: Joined channel successfully');
      setState(() {});
    } on AgoraRtmChannelException catch (errorCode) {
      print('Join channel error: ${errorCode.reason}');
    }
  }

  void _sendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.trim().isEmpty) {
      toast(translate(context, 'please_input_text_to_send'));
      return;
    }
    try {
      RtmMessage? message =
          _client?.createRawMessage(Uint8List.fromList([]), text);

      if (message != null) {
        await _channel?.sendMessage2(message);

        Provider.of<GetMessagesApiprovider>(context, listen: false).sendMessage(
            userId: widget.userId, text: _channelMessageController.text);
        _channelMessageController.clear();
      }
    } catch (errorCode) {
      print('Send channel message error: $errorCode');
    }
  }

  @override
  void initState() {
    final provider =
        Provider.of<GetMessagesApiprovider>(context, listen: false);
    provider.messageModelList.clear();
    provider.messages(recipientId: widget.userId!, fromAgora: true);
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          provider.loading == false) {
        provider.messages(
            recipientId: widget.userId,
            offset: provider.messageModelList.length,
            fromAgora: false);
      }
    });

    super.initState();
    initEveryThing();
  }

  initEveryThing() {
    _createClient().then((value) {
      _toggleLogin();
      _toggleJoinChannel();
    });
  }

  @override
  void dispose() {
    _client?.release();
    _channelMessageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  showCustomDialog({required BuildContext context, index, id}) {
    return showDialog(
        context: context,
        builder: (contex) {
          final pro =
              Provider.of<GetMessagesApiprovider>(context, listen: false);
          return CupertinoAlertDialog(
            content: Text(
              translate(context, 'delete_message_confirmation')!,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    pro.deleteMessageData(index: index, messageId: id);
                    Navigator.pop(context);
                  },
                  child: Text(
                    translate(context, 'delete')!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  )),
              CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    translate(context, 'go_back')!,
                    style: const TextStyle(),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final image = CircularImage(
      size: 30.0,
      image: widget.userAvatar!,
    );

    final bottom = Container(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 5,
        bottom: Platform.isIOS ? 15 : 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _channelMessageController,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: translate(context, 'type_your_message'),
                hintStyle: TextStyle(
                  color: Colors.grey.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.image,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: _pickVideo,
                      icon: const Icon(
                        Icons.video_library,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: _sendChannelMessage,
                      icon: const Icon(
                        LineIcons.paper_plane_1,
                        color: AppColors.primaryColor,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
              )),
          elevation: 2.0,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileTab(
                    userId: widget.userId,
                  ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                image,
                Utils.horizontalSpacer(space: 10),
                Expanded(
                  child: Text(
                    '${widget.userFirstName} ${widget.userLastName}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                LineIcons.video_1,
              ),
              onPressed: () {
                Provider.of<LiveStreamProvider>(context, listen: false)
                    .generateAgoraToken(
                  channelName:
                      "${orderNumbers(widget.userId!, getStringAsync('user_id'))}video",
                )
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          agoraToken: value.token,
                          userId: widget.userId!,
                          userName:
                              "${widget.userFirstName} ${widget.userLastName}",
                          userAvatar: widget.userAvatar,
                          channelName:
                              "${orderNumbers(widget.userId!, getStringAsync('user_id'))}video",
                        ),
                      ));
                });
              },
            ),
            IconButton(
                icon: const Icon(
                  LineIcons.phone,
                ),
                onPressed: () {
                  Provider.of<LiveStreamProvider>(context, listen: false)
                      .generateAgoraToken(
                    channelName:
                        "${orderNumbers(widget.userId!, getStringAsync('user_id'))}audio",
                  )
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioCallScreen(
                            agoraToken: value.token,
                            userId: widget.userId!,
                            userName:
                                "${widget.userFirstName} ${widget.userLastName}",
                            userAvatar: widget.userAvatar,
                            channelName:
                                "${orderNumbers(widget.userId!, getStringAsync('user_id'))}audio",
                          ),
                        ));
                  });
                }),
          ],
        ),
        body: Consumer<GetMessagesApiprovider>(
          builder: (context, value, child) => Column(
            children: [
              Expanded(
                child: value.loading == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Loader(),
                          Text(translate(context, 'loading')!),
                        ],
                      )
                    : value.loading == false && value.messageModelList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading(),
                              Text(translate(context, 'no_data_found')!),
                            ],
                          )
                        : value.loading
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  loading(),
                                  Text(translate(context, 'loading')!),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      reverse: true,
                                      itemCount: value.messageModelList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onLongPress: () async {
                                            await showCustomDialog(
                                              context: context,
                                              index: index,
                                              id: value
                                                  .messageModelList[index].id,
                                            );
                                            if (value.getGoBackValue == false) {
                                              setState(() {});
                                            }
                                          },
                                          child: ChatBubble(
                                            messages: value.messageModelList,
                                            index: index,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
              ),
              bottom
            ],
          ),
        ));
  }
}
