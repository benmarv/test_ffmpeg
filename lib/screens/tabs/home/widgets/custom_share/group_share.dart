import 'package:flutter/material.dart';
import 'package:link_on/controllers/GroupsProvider/user_joined_groups.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';

class GroupShare extends StatefulWidget {
  final Posts? posts;
  const GroupShare({super.key, required this.posts});

  @override
  State<GroupShare> createState() => _GroupShareState();
}

class _GroupShareState extends State<GroupShare> {
  @override
  void initState() {
    super.initState();
    context.read<UserJoinedGroups>().joinedGroupsProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Consumer<UserJoinedGroups>(builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bottomSheetTopDivider(color: AppColors.primaryColor),
              const SizedBox(
                height: 20,
              ),
              Text(
                translate(context,
                    'share_on_group')!, // Use translation key for 'Share on Group'
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value.getJoinGroupData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          loading(),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(translate(context,
                              'no_group_found')!), // Use translation key for 'No group found'
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          shrinkWrap: true,
                          itemCount: value.getJoinGroupData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, top: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(value
                                            .getJoinGroupData[index].cover!)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      value.getJoinGroupData[index].groupTitle
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () async {
                                          context
                                              .read<PostProvider>()
                                              .sharePostonTimeLine(
                                                  context: context,
                                                  post: widget.posts!,
                                                  groupId: value
                                                      .getJoinGroupData[index]
                                                      .id);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            translate(context,
                                                'share')!, // Use translation key for 'Share'
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
