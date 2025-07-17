// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/screens/message_details.dart/audio_call.dart';
import 'package:link_on/screens/message_details.dart/video_call.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  final String userImageUrl;
  final String userName;
  final String userId;
  final String callType;

  const CallScreen(
      {super.key,
      required this.userImageUrl,
      required this.userName,
      required this.userId,
      required this.callType});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate back after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String orderNumbers(String num1Str, String num2Str) {
      int num1 = int.parse(num1Str);
      int num2 = int.parse(num2Str);
      if (num1 < num2) {
        return '$num1$num2';
      } else {
        return '$num2$num1';
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background color
            Container(color: Colors.black),
            // User picture
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(widget.userImageUrl),
              ),
            ),
            // User name
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Text(
                widget.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 1,
              right: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Accept button
                  GestureDetector(
                    onTap: () async {
                      var accessToken = getStringAsync("access_token");
                      FormData form =
                          FormData.fromMap({'user_id': widget.userId});
                      Response response = await dioService.dio.post(
                        'decline-call',
                        data: form,
                        options: Options(
                            headers: {"Authorization": 'Bearer $accessToken'}),
                      );

                      log('User declined the call ${response.data}');

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TabsPage(),
                          ));
                    },
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
                  // Decline button
                  GestureDetector(
                    onTap: () {
                      if (widget.callType == 'video_call') {
                        Provider.of<LiveStreamProvider>(
                                navigatorKey.currentContext!,
                                listen: false)
                            .generateAgoraToken(
                          channelName:
                              "${orderNumbers(widget.userId, getStringAsync('user_id'))}video",
                        )
                            .then((value) {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => VideoCallScreen(
                              agoraToken: value.token,
                              userAvatar: widget.userImageUrl,
                              userName: widget.userName,
                              channelName:
                                  "${orderNumbers(widget.userId, getStringAsync('user_id'))}video",
                            ),
                          ));
                        });
                      } else if (widget.callType == 'audio_call') {
                        Provider.of<LiveStreamProvider>(
                                navigatorKey.currentContext!,
                                listen: false)
                            .generateAgoraToken(
                          channelName:
                              "${orderNumbers(widget.userId, getStringAsync('user_id'))}audio",
                        )
                            .then((value) {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => AudioCallScreen(
                              agoraToken: value.token,
                              userAvatar: widget.userImageUrl,
                              userName: widget.userName,
                              channelName:
                                  "${orderNumbers(widget.userId, getStringAsync('user_id'))}audio",
                            ),
                          ));
                        });
                      }
                    },
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
                          color: Colors.green,
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
  }
}
