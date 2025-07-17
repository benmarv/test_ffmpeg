import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/groups/joined_group.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/screens/groups/widgets/group_card.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});
  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    GroupsProvider groupsProvider =
        Provider.of<GroupsProvider>(context, listen: false);
    groupsProvider.currentScreen = "discover";
    groupsProvider.makeGroupListEmpty('discover');
    groupsProvider.getdiscovergroup().then((value) {
      setState(() {});
    });
    _controller.addListener(() {
      if ((_controller.position.pixels ==
              _controller.position.maxScrollExtent) &&
          groupsProvider.loader == false) {
        groupsProvider.getdiscovergroup(
          afterPostId: groupsProvider.discoverGroups.length.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GroupsProvider>().getdiscovergroup();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10, left: 10, top: 10),
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).colorScheme.surface,
        child: Consumer<GroupsProvider>(builder: (context, value, child) {
          return ListView(
            controller: _controller,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Text(
                    translate(context, 'all_groups').toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "(${value.discoverGroups.length})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400]),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JoinedGroups(),
                        )),
                    child: Text(
                      translate(context, 'recently_joined').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              value.loader == true && value.discoverGroups.isEmpty
                  ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Center(
                        child: Loader(),
                      ),
                    )
                  : value.loader == false && value.discoverGroups.isEmpty
                      ? AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading(),
                              Text(translate(context, 'no_data_found')
                                  .toString()),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: value.discoverGroups.length,
                              itemBuilder: (context, index) {
                                return GroupCard(
                                  joinGroupModel: value.discoverGroups[index],
                                  index: index,
                                  flag: true,
                                );
                              },
                            ),
                            if (value.loader == true &&
                                value.discoverGroups.isNotEmpty) ...[
                              const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ]
                          ],
                        )
            ],
          );
        }),
      ),
    );
  }
}
