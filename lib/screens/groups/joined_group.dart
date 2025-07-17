import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/groups/widgets/group_card.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';

class JoinedGroups extends StatefulWidget {
  const JoinedGroups({super.key});

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    final groupsProvider = Provider.of<GroupsProvider>(context, listen: false);
    groupsProvider.currentScreen = 'joingroups';
    groupsProvider.makeGroupListEmpty('joined');
    groupsProvider.getJoinGroups().then((_) {
      setState(() {});
    });
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          !groupsProvider.loader) {
        groupsProvider.getJoinGroups(
          afterPostId: groupsProvider.joinGroups.length.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(context, 'joined_group').toString()),
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<GroupsProvider>().getJoinGroups();
        },
        child: Consumer<GroupsProvider>(
          builder: (context, value, child) {
            if (value.loader && value.joinGroups.isEmpty) {
              return Center(
                child: Loader(),
              );
            } else if (!value.loader && value.joinGroups.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    const SizedBox(height: 10),
                    Text(translate(context, 'no_data_found').toString()),
                  ],
                ),
              );
            } else {
              return ListView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.joinGroups.length,
                    itemBuilder: (context, index) {
                      return GroupCard(
                        joinGroupModel: value.joinGroups[index],
                        index: index,
                      );
                    },
                  ),
                  if (value.loader && value.joinGroups.isEmpty) ...[
                    Center(
                      child: Text(
                          translate(context, 'no_groups_joined').toString()),
                    ),
                  ],
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
