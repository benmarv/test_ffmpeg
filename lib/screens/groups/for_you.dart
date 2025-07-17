import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';

import 'widgets/group_card.dart';

class ForYouGroup extends StatefulWidget {
  const ForYouGroup({super.key});

  @override
  State<ForYouGroup> createState() => _ForYouGroupState();
}

class _ForYouGroupState extends State<ForYouGroup> {
  @override
  void initState() {
    super.initState();

    GroupsProvider groupsProvider =
        Provider.of<GroupsProvider>(context, listen: false);
    groupsProvider.currentScreen = "mygroups";
    groupsProvider.makeGroupListEmpty('mygroups');

    groupsProvider.getmygroups(context: context).then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GroupsProvider>().getmygroups(context: context);
      },
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              translate(context, 'groups_you_managed').toString(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Consumer<GroupsProvider>(builder: (context, value, child) {
            return value.myGroups.isEmpty
                ? AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_data_found').toString()),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: value.myGroups.length,
                        itemBuilder: (context, index) {
                          return GroupCard(
                            joinGroupModel: value.myGroups[index],
                            index: index,
                          );
                        },
                      ),
                      if (value.loader == true &&
                          value.myGroups.isNotEmpty) ...[
                        Center(
                          child: Text(
                            translate(context, 'no_groups_created').toString(),
                          ),
                        ),
                      ]
                    ],
                  );
          }),
        ],
      ),
    );
  }
}
