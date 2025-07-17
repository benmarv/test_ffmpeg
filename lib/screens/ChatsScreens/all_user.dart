import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/controllers/FriendProvider/friend_followe_provider.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class AllUser extends StatefulWidget {
  const AllUser({super.key});

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  @override
  void initState() {
    super.initState();
    context.read<FriendsFollowingProvider>().makeFriendFollowingEmpty();

    context
        .read<FriendsFollowingProvider>()
        .friendGetFollowing(userId: getStringAsync("user_id"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1.0,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          title: SizedBox(
            height: 20,
            width: 100,
            child: Image.network(getStringAsync("appLogo")),
          )),
      body: Consumer<FriendsFollowingProvider>(
        builder: (context, value, child) {
          return value.isLoading == true && value.following.isEmpty
              ? const Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : value.isLoading == false && value.following.isEmpty
                  ? Column(
                      children: [loading(), const Text("No user found")],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: value.following.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            onTap: () {
                              print("ccccccccccccccccccccccccc");
                              print(value.following[index].id);
                              print(value.following[index].avatar);
                              print(value.following[index].firstName);
                              print(value.following[index].lastName);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgoraMessaging(
                                    userId: value.following[index].id,
                                    userAvatar: value.following[index].avatar,
                                    userFirstName:
                                        value.following[index].firstName,
                                    userLastName:
                                        value.following[index].lastName,
                                  ),
                                ),
                              );
                            },
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              image:
                                                  value.following[index].avatar,
                                            )));
                              },
                              child: CircularImage(
                                image: value.following[index].avatar.toString(),
                                size: 60.0,
                              ),
                            ),
                            title: Text("${value.following[index].username}"),
                            subtitle: Text(
                              "${translate(context, 'mutual_friends')}: ${value.following[index].details!.mutualfriendsCount}",
                            ));
                      },
                    );
        },
      ),
    );
  }
}
