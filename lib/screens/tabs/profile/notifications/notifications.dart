// ignore_for_file: use_build_context_synchronously

import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';

import 'package:link_on/screens/tabs/profile/notifications/notification_provider.dart';

import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/tabs/profile/notifications/widgets/notification_tile.dart';
import 'package:flutter/material.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});
  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  late ScrollController _controller;
  String status = "0";
  @override
  void initState() {
    final notificationProvider =
        Provider.of<NotificationProvier>(context, listen: false);
    _controller = ScrollController();
    super.initState();
    notificationProvider.notificationList.clear();
    notificationProvider.notficationDetailApi();
    _controller.addListener(
      () {
        if (_controller.position.pixels ==
                _controller.position.maxScrollExtent &&
            notificationProvider.isLoading == true) {
          notificationProvider.notficationDetailApi(
              offset: notificationProvider.notificationList.length);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                getStringAsync("appLogo"),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<NotificationProvier>(
        builder: ((context, value, child) {
          return (value.isLoading == false && value.notificationList.isEmpty)
              ? Center(
                  child: Loader(),
                )
              : (value.isLoading == true && value.notificationList.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_data_found').toString()),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                translate(context, 'recent_notifications')
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await value.updateNotificationStatus(context);
                                  await value.notficationDetailApi(
                                      isMarkAsRead: true);
                                  if (mounted) {
                                    Provider.of<PostProvider>(context,
                                            listen: false)
                                        .markAllAsRead();
                                  }
                                },
                                child: Text(
                                  translate(context, 'mark_all_as_read')
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 10),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: ListView.builder(
                              controller: _controller,
                              itemCount: value.notificationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: NotificationTile(
                                    notification: value.notificationList[index],
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          )),
                        ],
                      ),
                    );
        }),
      ),
    );
  }
}
