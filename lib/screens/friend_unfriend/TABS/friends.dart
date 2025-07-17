import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/friend_unfriend/widgets/friend_user_friend_tile.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class Friends extends StatefulWidget {
  final String? userid;
  final bool? isProfileRoute;
  const Friends({super.key, this.userid, this.isProfileRoute});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
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
                      Text(translate(context, 'no_friends_found')!),
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              child: FriendUserFriendTile(
                                myProfile:
                                    widget.userid == getStringAsync("user_id"),
                                user: value.follower[index],
                                isProfileRoute: widget.isProfileRoute,
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
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
