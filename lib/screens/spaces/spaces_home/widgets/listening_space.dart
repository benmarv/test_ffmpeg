// // ignore_for_file: unrelated_type_equality_checks, avoid_print
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:link_on/localization/localization_constant.dart';
// import 'package:link_on/models/spaces_model/spaces_model.dart';
// import 'package:link_on/utils/Spaces/custom_bottom_sheet.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:link_on/screens/pages/explore_pages.dart';
// import 'package:link_on/screens/spaces/spaces_home/widgets/user_profile.dart';
// import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';

// class ListenSpace extends StatefulWidget {
//   final SpaceModel? spaceModel;
//   const ListenSpace({super.key, this.spaceModel});
//   @override
//   State<ListenSpace> createState() => _ListenSpaceState();
// }

// class _ListenSpaceState extends State<ListenSpace> {
//   late RtcEngine _engine;
//   // final bool _isMuted = false;
//   final _users = <int>[];
//   final _infoStrings = <String>[];

//   @override
//   void initState() {
//     super.initState();

//     context
//         .read<SpaceProvider>()
//         .getSpaceMembers(context: context, spaceId: widget.spaceModel?.id);

//     initialize();
//     print('agora info strings$_infoStrings');
//   }

//   final String agoraAppId = dotenv.env['AGORA_APP_ID']!;

//   Future<void> initialize() async {
//     log('Agora App Id $agoraAppId');
//     if (agoraAppId.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }

//     await _initAgoraRtcEngine();
//   }

//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await [Permission.microphone].request();
//     //create the engine
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: agoraAppId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onError: (err, msg) {
//           setState(() {
//             final info = 'onError: $msg';
//             log("erroe =>>>>>>>>>>>>>>>>>>>>>> $err");
//             toast(msg.toString());
//             _infoStrings.add(info);
//           });
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() {
//             // _localUserJoined = true;
//             final info =
//                 'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
//             _infoStrings.add(info);
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           setState(() {
//             // _remoteUid = remoteUid;
//           });
//         },
//         onLeaveChannel: (connection, stats) {
//           setState(() {
//             _infoStrings.add('onLeaveChannel');
//             _users.clear();
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           setState(() {
//             // _remoteUid = null;
//             toast("user offline $remoteUid");
//             final info = 'userOffline: $remoteUid';
//             _infoStrings.add(info);
//             _users.remove(remoteUid);
//           });
//         },
//         onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
//           widget.spaceModel?.agoraAccessToken = token;
//           toast(token);
//           setState(() {});
//         },
//       ),
//     );
//     VideoEncoderConfiguration configuration = const VideoEncoderConfiguration(
//       dimensions: VideoDimensions(width: 1920, height: 1080),
//     );

//     await _engine.setVideoEncoderConfiguration(configuration);
//     await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
//     await _engine.enableAudio();

//     ChannelMediaOptions options;

//     if (1 == 1) {
//       options = const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleAudience,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       );
//     } else {
//       options = const ChannelMediaOptions(
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       );
//       await _engine.startPreview();
//     }

//     await _engine.joinChannel(
//         token: '', channelId: 'link_on', options: options, uid: 0);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _dispose();
//   }

//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   // void _toggleMute() {
//   //   setState(() {
//   //     _isMuted = !_isMuted;
//   //   });
//   //   _engine.muteLocalAudioStream(_isMuted);
//   // }

//   void _endCall() async {
//     await _engine.leaveChannel();
//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.sizeOf(context).width * .69,
//                     child: Text(
//                       widget.spaceModel!.title ?? "",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w900,
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodyLarge!
//                             .color!
//                             .withOpacity(0.7),
//                       ),
//                     ),
//                   ),
//                   InkWell(
//                       onTap: () {
//                         _endCall();
//                         Provider.of<SpaceProvider>(context, listen: false)
//                             .leaveSpace(
//                                 context: context,
//                                 spaceId: widget.spaceModel!.id);
//                       },
//                       child: Text(
//                         translate(context, 'leave')!,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ))
//                 ],
//               ),
//               SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Consumer<SpaceProvider>(builder: (context, value, child) {
//                       return (value.loading == false &&
//                               value.spaceMembers.isEmpty)
//                           ? Loader()
//                           : (value.loading == true &&
//                                   value.spaceMembers.isEmpty)
//                               ? loading()
//                               : Wrap(
//                                   spacing:
//                                       MediaQuery.sizeOf(context).width * .05,
//                                   direction: Axis.horizontal,
//                                   alignment: WrapAlignment.center,
//                                   crossAxisAlignment: WrapCrossAlignment.center,
//                                   children: [
//                                     for (int index = 0;
//                                         index < value.spaceMembers.length;
//                                         index++)
//                                       InkWell(
//                                         onTap: () {
//                                           Navigator.pop(context);

//                                           showModelBottomSheet(
//                                             isScroll: true,
//                                             colors: Colors.white,
//                                             context: context,
//                                             widget: UserProfile(
//                                               id: value
//                                                   .spaceMembers[index].userId,
//                                             ),
//                                           );
//                                         },
//                                         child: Padding(
//                                           padding: EdgeInsets.all(
//                                               MediaQuery.sizeOf(context).width *
//                                                   .01),
//                                           child: SizedBox(
//                                             height: 130,
//                                             width: MediaQuery.sizeOf(context)
//                                                     .width *
//                                                 .7,
//                                             child: Column(
//                                               children: [
//                                                 Container(
//                                                   height: 75,
//                                                   width:
//                                                       MediaQuery.sizeOf(context)
//                                                               .width *
//                                                           .15,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.blueGrey,
//                                                     shape: BoxShape.circle,
//                                                     image: DecorationImage(
//                                                       image: NetworkImage(value
//                                                           .spaceMembers[index]
//                                                           .avatar
//                                                           .toString()),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(3.0),
//                                                   child: Text(
//                                                     '${value.spaceMembers[index].firstName} ${value.spaceMembers[index].lastName}',
//                                                     maxLines: 1,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     textAlign: TextAlign.center,
//                                                     style: const TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 16,
//                                                         fontWeight:
//                                                             FontWeight.w500),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             3.0),
//                                                     child: Text(
//                                                       value.spaceMembers[index]
//                                                                   .isHost ==
//                                                               "1"
//                                                           ? translate(
//                                                               context, 'host')!
//                                                           : value
//                                                                       .spaceMembers[
//                                                                           index]
//                                                                       .isCohost ==
//                                                                   "1"
//                                                               ? translate(
//                                                                   context,
//                                                                   'co_host')!
//                                                               : translate(
//                                                                   context,
//                                                                   'listener')!,
//                                                       maxLines: 1,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: const TextStyle(
//                                                         color: Colors.blueGrey,
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 );
//                     }),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       Icon(
//                         Icons.mic,
//                         size: 60,
//                         color: Colors.black,
//                       ),
//                       Text(
//                         translate(context, 'request')!,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
