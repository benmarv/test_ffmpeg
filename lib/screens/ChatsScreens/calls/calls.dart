import 'package:flutter/material.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/message_details.dart/audio_call.dart';
import 'package:link_on/screens/message_details.dart/video_call.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/MessagesProvider/get_messages_api.dart';

class Calls extends StatefulWidget {
  const Calls({super.key});

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  @override
  void initState() {
    final callHistoryController =
        Provider.of<GetMessagesApiprovider>(context, listen: false);
    callHistoryController.callHistoryData.clear();
    callHistoryController.getCallHistoryApi();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          callHistoryController.loading == false) {
        callHistoryController.getCallHistoryApi(
            offset: callHistoryController.callHistoryData.length,
            context: context);
      }
    });
    super.initState();
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

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Consumer<GetMessagesApiprovider>(
            builder: (context, value, child) => (value.loading == true &&
                    value.callHistoryData.isEmpty)
                ? Center(
                    child: Loader(),
                  )
                : value.loading == false && value.callHistoryData.isEmpty
                    ? Column(
                        children: [
                          loading(),
                          Text(
                            translate(context, 'no_history_found').toString(),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: value.callHistoryData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      value.callHistoryData[index].avatar!)),
                              title: Text(
                                "${value.callHistoryData[index].firstName!} ${value.callHistoryData[index].lastName!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    value.callHistoryData[index].incoming == '0'
                                        ? Icons.arrow_outward
                                        : Icons.subdirectory_arrow_left_sharp,
                                    color:
                                        value.callHistoryData[index].incoming ==
                                                '0'
                                            ? Colors.red
                                            : Colors.green,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    value.callHistoryData[index].time!,
                                  ),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  value.callHistoryData[index].callType ==
                                          'video_call'
                                      ? Provider.of<LiveStreamProvider>(context,
                                              listen: false)
                                          .goLiveApi(
                                              agoraAccessToken: value
                                                  .callHistoryData[index].id!,
                                              channelName: value
                                                      .callHistoryData[index]
                                                      .id! +
                                                  getStringAsync('user_id'),
                                              type: 'video_call',
                                              toUserId: value
                                                  .callHistoryData[index].id!)
                                          .then((liveApivalue) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoCallScreen(
                                                  userId: value
                                                      .callHistoryData[index]
                                                      .id!,
                                                  userAvatar: value
                                                      .callHistoryData[index]
                                                      .avatar!,
                                                  userName: value
                                                      .callHistoryData[index]
                                                      .username!,
                                                  channelName:
                                                      '${orderNumbers(value.callHistoryData[index].id!, getStringAsync('user_id'))}video',
                                                ),
                                              ));
                                        })
                                      : Provider.of<LiveStreamProvider>(context,
                                              listen: false)
                                          .goLiveApi(
                                              agoraAccessToken: value
                                                  .callHistoryData[index].id!,
                                              channelName: value
                                                      .callHistoryData[index]
                                                      .id! +
                                                  getStringAsync('user_id'),
                                              type: 'audio_call',
                                              toUserId: value
                                                  .callHistoryData[index].id!)
                                          .then((liveApivalue) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioCallScreen(
                                                  userId: value
                                                      .callHistoryData[index]
                                                      .id!,
                                                  userAvatar: value
                                                      .callHistoryData[index]
                                                      .avatar!,
                                                  userName: value
                                                      .callHistoryData[index]
                                                      .username!,
                                                  channelName:
                                                      '${orderNumbers(value.callHistoryData[index].id!, getStringAsync('user_id'))}audio',
                                                ),
                                              ));
                                        });
                                },
                                child: Icon(
                                    value.callHistoryData[index].callType ==
                                            'audio_call'
                                        ? Icons.call
                                        : Icons.videocam_rounded),
                              ),
                            );
                          },
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
