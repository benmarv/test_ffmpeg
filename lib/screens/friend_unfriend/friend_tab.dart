import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/screens/friend_unfriend/TABS/friends.dart';
import 'package:link_on/screens/friend_unfriend/TABS/friend_request.dart';
import 'package:link_on/screens/friend_unfriend/TABS/friend_suggestions.dart';

class FriendTabs extends StatefulWidget {
  const FriendTabs({
    super.key,
  });
  @override
  State<FriendTabs> createState() => _FriendTabsState();
}

class _FriendTabsState extends State<FriendTabs> {
  List tabs = ["suggestions", "requests", "friends"];
  // @override
  // void initState() {
  //   super.initState();
  // FriendFriendSuggestProvider friendSuggestProvider =
  //     Provider.of<FriendFriendSuggestProvider>(context, listen: false);
  // friendSuggestProvider.makeFriendSuggestedEmtyList();
  // FriendFollowRequestProvider followRequestProvider =
  //     Provider.of<FriendFollowRequestProvider>(context, listen: false);
  // followRequestProvider.makeFriendRequestEmpty();
  // FriendFollowerFollowingProvider followerFollowingProvider =
  //     Provider.of<FriendFollowerFollowingProvider>(context, listen: false);
  // followerFollowingProvider.makeFriendFollowingEmpty();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                )),
            title: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    getStringAsync("appLogo"),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              dividerHeight: 0,
              labelColor: AppColors.primaryColor,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
              tabs: tabs.map((tab) {
                var index = tabs.indexOf(tab);
                return Tab(
                  text: translate(context, tabs[index]),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            children: [
              const FriendSuggestions(),
              const FriendRequest(),
              Friends(
                userid: getStringAsync("user_id"),
                isProfileRoute: false,
              ),
            ],
          )),
    );
  }
}
