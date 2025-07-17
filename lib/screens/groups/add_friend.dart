import 'package:flutter/material.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/controllers/GroupsProvider/add_member_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';

class AddFriendGroups extends StatefulWidget {
  final String? groupid;
  const AddFriendGroups({super.key, this.groupid});

  @override
  State<AddFriendGroups> createState() => _AddFriendGroupsState();
}

class _AddFriendGroupsState extends State<AddFriendGroups> {
  @override
  void initState() {
    super.initState();
    FriendFollower followerFollowingProvider =
        Provider.of<FriendFollower>(context, listen: false);
    followerFollowingProvider.makeFriendFollowerEmpty();
    followerFollowingProvider.friendGetFollower();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        title: Text(
          translate(context, 'friends')!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Consumer<FriendFollower>(builder: (context, value, child) {
          return value.follower.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: Text(
                        translate(context, 'add_friends_to_group')!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.follower.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              value.follower[index].avatar!))),
                                ),
                                title: Text(value.follower[index].username!),
                                trailing: IconButton(
                                    onPressed: () {
                                      context.read<AddMemberGroup>().addMember(
                                            context: context,
                                            userid: value.follower[index].id,
                                            groupid: widget.groupid,
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.person_add,
                                    )),
                              ),
                            );
                          }),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
