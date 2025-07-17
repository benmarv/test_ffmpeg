import 'package:flutter/material.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class TagPeopleScreen extends StatefulWidget {
  final String? userid;

  const TagPeopleScreen({super.key, this.userid});

  @override
  State<TagPeopleScreen> createState() => _TagPeopleScreenState();
}

class _TagPeopleScreenState extends State<TagPeopleScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    FriendFollower followerFollowingProvider =
        Provider.of<FriendFollower>(context, listen: false);
    followerFollowingProvider.makeFriendFollowerEmpty();
    followerFollowingProvider.friendGetFollower(userId: widget.userid);
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          followerFollowingProvider.check2 == true) {
        followerFollowingProvider.friendGetFollower(
          userId: widget.userid,
          offset: followerFollowingProvider.follower.length,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customScroll =
        Consumer<FriendFollower>(builder: (context, value, child) {
      return (value.check2 == false && value.follower.isEmpty)
          ? Expanded(child: Center(child: Loader()))
          : (value.check2 == true && value.follower.isEmpty)
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Text(translate(
                          context, 'no_friends_found')!), // Translated text
                    ],
                  ),
                )
              : Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (
                            BuildContext context,
                            int index,
                          ) {
                            final pro = Provider.of<PostProvider>(context,
                                listen: false);
                            var isChecked = pro.taggedUserIds
                                .contains(value.follower[index].id);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    // Toggle the checkbox state
                                    isChecked = !isChecked;
                                    // Update the tagged user list
                                    pro.updateTaggedUser(
                                      id: value.follower[index].id!,
                                      checkvalue: isChecked,
                                      firstName:
                                          value.follower[index].firstName!,
                                      lastName: value.follower[index].lastName!,
                                    );
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: CircularImage(
                                  image:
                                      value.follower[index].avatar.toString(),
                                  size: 35,
                                ),
                                title: SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  child: Text(
                                    '${value.follower[index].firstName!.toString()} ${value.follower[index].lastName!}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 30,
                                  child: CheckboxListTile(
                                    splashRadius: 0,
                                    checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    value: isChecked,
                                    onChanged: (bool? checkValue) {
                                      setState(() {
                                        isChecked = checkValue!;
                                        pro.updateTaggedUser(
                                          id: value.follower[index].id!,
                                          checkvalue: isChecked,
                                          firstName:
                                              value.follower[index].firstName!,
                                          lastName:
                                              value.follower[index].lastName!,
                                        );
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: value.follower.length,
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        value.hitfollowerApi == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primaryColor),
                              )
                            : const SizedBox.shrink()
                      ]))
                    ],
                  ),
                );
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(
          translate(context, 'tag_friends')!, // Translated title
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translate(context, 'done')!, // Translated 'Done'
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customScroll,
            ],
          ),
        ),
      ),
    );
  }
}
