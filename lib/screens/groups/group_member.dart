import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class GroupMember extends StatefulWidget {
  final dynamic groupId;
  final int? gropIndex;
  const GroupMember({super.key, this.groupId, this.gropIndex});

  @override
  State<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    log("groupid for member list ${widget.groupId}");
    _scrollController = ScrollController();
    GroupsProvider groupsProvider =
        Provider.of<GroupsProvider>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        groupsProvider.groupmemberslist(
            groupid: widget.groupId,
            context: context,
            afterPostId: groupsProvider.getMemberDataList.length.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text(
            translate(context, 'members')!,
            style: const TextStyle(
                color: Colors.black, fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            controller: _scrollController,
            children: [
              Text(
                translate(context, 'admins')!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              Consumer<GroupsProvider>(builder: (context, value, child) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getOnlyAdmin.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              value.getOnlyAdmin[index].avatar.toString()),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value.getOnlyAdmin[index].username.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                            4.sw,
                            value.getOnlyAdmin[index].isVerified == "1"
                                ? verified()
                                : const SizedBox.shrink()
                          ],
                        ),
                        subtitle: Text(
                          translate(context, 'admin')!,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    });
              }),
              Text(
                translate(context, 'members')!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              Consumer<GroupsProvider>(builder: (context, value, child) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getOnlyMembers.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              value.getOnlyMembers[index].avatar.toString()),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value.getOnlyMembers[index].username.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                            4.sw,
                            value.getOnlyMembers[index].isVerified == "1"
                                ? verified()
                                : const SizedBox.shrink()
                          ],
                        ),
                        subtitle: Text(
                          translate(context, 'member')!,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        trailing: value.isAdmin == true
                            ? PopupMenuButton(
                                position: PopupMenuPosition.under,
                                padding: const EdgeInsets.only(left: 20),
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      value.deleteMemberProvder(context,
                                          groupId: widget.groupId,
                                          userId:
                                              value.getOnlyMembers[index].id,
                                          index: index);
                                    },
                                    child: Text(
                                      translate(context, 'remove_member')!,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      value.makeGroupAdminProvider(
                                          groupId: widget.groupId,
                                          userId:
                                              value.getOnlyMembers[index].id,
                                          context: context,
                                          index: index);
                                    },
                                    child: Text(
                                      translate(context, 'make_admin')!,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      );
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
