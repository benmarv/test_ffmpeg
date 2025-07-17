import 'package:flutter/material.dart';
import 'package:link_on/controllers/MessagesProvider/get_messages_api.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/ChatsScreens/calls/calls.dart';
import 'package:link_on/screens/message_details.dart/message_tile.dart';
import 'package:provider/provider.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> tabs = [];

  @override
  void initState() {
    super.initState();

    tabs = ["chats", "calls_history"];
    tabController = TabController(
      vsync: this,
      length: tabs.length,
    );

    tabController.addListener(() {
      setState(() {}); // Update the UI when the tab changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<GetMessagesApiprovider>(context, listen: false);

    final tabBar = TabBar(
      labelColor: AppColors.primaryColor,
      dividerHeight: 0,
      indicatorColor: AppColors.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      tabs: tabs.map((tab) {
        var index = tabs.indexOf(tab);
        return Tab(
          text: translate(context, tabs[index]),
        );
      }).toList(),
      controller: tabController,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: SizedBox(
          height: 20,
          width: 100,
          child: Image.network(getStringAsync("appLogo")),
        ),
        actions: [
          TextButton(
            onPressed: tabController.index == 0
                ? () {}
                : () {
                    provider.deleteCallHistory();
                  },
            child: tabController.index == 0
                ? Text('')
                : Text(
                    translate(context, 'delete_call_history').toString(),
                  ),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Column(
        children: [
          tabBar,
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: const [
              MessagTile(),
              Calls(),
            ],
          )),
        ],
      ),
    );
  }
}
