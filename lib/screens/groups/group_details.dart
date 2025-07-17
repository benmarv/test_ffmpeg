import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/groups/widgets/update_data.dart';
import 'add_friend.dart';
import 'group_member.dart';

class DetailsGroup extends StatefulWidget {
  final JoinGroupModel? joinGroupModel;
  const DetailsGroup({super.key, this.joinGroupModel, this.index});

  final int? index;
  @override
  State<DetailsGroup> createState() => _DetailsGroupState();
}

class _DetailsGroupState extends State<DetailsGroup> {
  final ScrollController _scrollController = ScrollController();

  List<Usr> memberlists = [];
  Map<String, dynamic> mapData = {};

  @override
  void initState() {
    mapData["group_id"] = widget.joinGroupModel!.id;
    super.initState();
    final pro = Provider.of<GroupsProvider>(context, listen: false);
    pro.groupmemberslist(groupid: widget.joinGroupModel!.id, context: context);
    Provider.of<PostProviderTemp>(context, listen: false).makePostListEmpty();
    Provider.of<PostProviderTemp>(context, listen: false)
        .getPostData(context: context, mapData: mapData);
    _scrollController.addListener(() {
      var provider = Provider.of<PostProviderTemp>(context, listen: false);
      var postId = provider.postListTemp[provider.postListTemp.length - 1].id;

      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        mapData["last_post_id"] = postId;
        provider.getPostData(
          mapData: mapData,
          context: context,
        );
      }
    });
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    passwordController.dispose();
    reportController.dispose();
    context.read<PostProviderTemp>().makePostListEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: widget.joinGroupModel!.isJoined == "0"
            ? const SizedBox.shrink()
            : FloatingActionButton(
                elevation: 4,
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createPost,
                      arguments: CreatePostPage(
                          groupId: widget.joinGroupModel!.id,
                          val: true,
                          flag: true));
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    image: widget.joinGroupModel!.cover,
                                  )));
                    },
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.35,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        image: DecorationImage(
                            image: NetworkImage(widget.joinGroupModel!.cover!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                            margin: const EdgeInsets.only(top: 50, left: 20),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white60),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.arrow_back,
                              size: 16,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Center(
                          child: Text(
                            widget.joinGroupModel!.groupTitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReadMoreText(
                          widget.joinGroupModel!.aboutGroup.toString(),
                          trimLines: 1,
                          trimLength: 180,
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500),
                          trimCollapsedText: '.......more',
                          trimExpandedText: ' show less',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            widget.joinGroupModel!.isGroupOwner == false
                                ? MaterialButton(
                                    minWidth:
                                        MediaQuery.sizeOf(context).width * 0.95,
                                    height: 40,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    color: AppColors.primaryColor,
                                    onPressed:
                                        widget.joinGroupModel!.isJoined == "0"
                                            ? () {
                                                Provider.of<GroupsProvider>(
                                                        context,
                                                        listen: false)
                                                    .joinGroup(
                                                  joinGroupModel:
                                                      widget.joinGroupModel!,
                                                  // index: widget.index ?? 0,
                                                  context: context,
                                                );
                                              }
                                            : () {
                                                removeAlert();
                                              },
                                    child: Center(
                                      child: Text(
                                        widget.joinGroupModel!.isJoined == "0"
                                            ? translate(context, 'join_group')
                                                .toString()
                                            : translate(context, 'joined')
                                                .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    child: MaterialButton(
                                      height: 30,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: AppColors.primaryColor,
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateGroupData(
                                                      joinGroupModel:
                                                          widget.joinGroupModel,
                                                      id: widget
                                                          .joinGroupModel!.id,
                                                    )));
                                      },
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person_pin_rounded,
                                              color: Colors.white,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .040,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              translate(context, 'edit_group')
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .030),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            widget.joinGroupModel!.isGroupOwner == true
                                ? MaterialButton(
                                    height: 30,
                                    minWidth:
                                        MediaQuery.sizeOf(context).width * .25,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    color: AppColors.buttongrey,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddFriendGroups(
                                            groupid: widget.joinGroupModel!.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_add,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .040,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            translate(context, 'add_member')
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .030),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            if (widget.joinGroupModel!.isGroupOwner == true)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .12,
                                child: MaterialButton(
                                  height: 30,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: AppColors.buttongrey,
                                  onPressed: () {
                                    deleteDialogue(
                                        groupId: widget.joinGroupModel!.id);
                                  },
                                  child: Icon(
                                    Icons.delete_rounded,
                                    size: MediaQuery.of(context).size.width *
                                        .040,
                                    color: Colors.red.withOpacity(0.7),
                                  ),
                                ),
                              )
                          ]),
                      const Divider(
                        color: Colors.black26,
                        thickness: 0.2,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupMember(
                                gropIndex: widget.index,
                                groupId: widget.joinGroupModel!.id,
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.people_alt_outlined,
                          color: Colors.grey[700],
                        ),
                        title: Text(
                          "${widget.joinGroupModel!.membersCount} ${translate(context, 'members')}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      if (widget.joinGroupModel!.category != " " &&
                          widget.joinGroupModel!.category != "")
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.joinGroupModel!.category.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.grey[300]!,
                        thickness: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        translate(context, 'group_posts').toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Consumer<PostProviderTemp>(
                          builder: (context, value, child) {
                        return value.loading == true &&
                                value.postListTemp.isEmpty
                            ? const PostSkeleton()
                            : value.loading == false &&
                                    value.postListTemp.isEmpty
                                ? AspectRatio(
                                    aspectRatio: 16 / 8,
                                    child: Center(
                                      child: Text(
                                        translate(context, 'no_data_found')
                                            .toString(),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(top: 20),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: value.postListTemp.length,
                                    itemBuilder: (context, index) {
                                      return PostTile(
                                          tempPost: true,
                                          posts: value.postListTemp[index],
                                          index: index,
                                          isgroup: true);
                                    },
                                  );
                      }),
                      if (context.watch<PostProviderTemp>().loading == true &&
                          context
                              .watch<PostProviderTemp>()
                              .postListTemp
                              .isNotEmpty)
                        const PostSkeleton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  deleteDialogue({groupId}) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(context, 'delete_group').toString(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                context.read<GroupsProvider>().groupDeletFuntion(
                    groupId: groupId,
                    password: passwordController.text,
                    context: context,
                    index: widget.index);
                passwordController.clear();
              },
              isDefaultAction: true,
              child: Text(
                translate(context, 'delete').toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                translate(context, 'go_back').toString(),
                style: const TextStyle(),
              ),
            )
          ],
        );
      },
    );
  }

  removeAlert() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(context, 'leave_group_title').toString(),
          ),
          content: Text(
            translate(context, 'leave_group_message').toString(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                context.read<GroupsProvider>().leaveGroup(
                    context: context,
                    joinGroupModel: widget.joinGroupModel,
                    index: widget.index);
              },
              isDefaultAction: true,
              child: Text(
                translate(context, 'leave_group').toString(),
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                translate(context, 'cancel').toString(),
                style: const TextStyle(fontSize: 13),
              ),
            )
          ],
        );
      },
    );
  }
}
