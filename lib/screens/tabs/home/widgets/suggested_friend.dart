import 'package:flutter/material.dart';
import 'package:link_on/controllers/Follower/friend_suggestions_Provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class SuggesFriends extends StatefulWidget {
  final String? userId;
  const SuggesFriends({super.key, this.userId});

  @override
  State<SuggesFriends> createState() => _SuggesFriendsState();
}

class _SuggesFriendsState extends State<SuggesFriends> {
  @override
  void initState() {
    super.initState();
    Provider.of<FriendSuggestProvider>(context, listen: false)
        .suggestUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FriendSuggestProvider>(builder: (context, value, child) {
      return value.check == false
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loader(),
                Text(translate(context, 'loading')!), // Translated 'Loading'
              ],
            )
          : (value.check == true && value.suggestionfriend.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(
                      translate(context, 'no_followers_found')!,
                    ), // Translated 'No followers found'
                  ],
                )
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.separated(
                        itemCount: value.suggestionfriend.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileTab(
                                              userId: value
                                                  .suggestionfriend[index].id,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(value
                                              .suggestionfriend[index].avatar
                                              .toString()),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            value.suggestionfriend[index]
                                                .username
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          4.sw,
                                          value.suggestionfriend[index]
                                                      .isVerified ==
                                                  "1"
                                              ? verified()
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      value.suggestionfriend[index].details!
                                                  .mutualFriendCount !=
                                              false
                                          ? Text(
                                              "${value.suggestionfriend[index].details!.mutualFriendCount} ${translate(context, 'mutual_friend')}", // Translated 'mutual friend'
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ],
                  ),
                );
    });
  }
}
