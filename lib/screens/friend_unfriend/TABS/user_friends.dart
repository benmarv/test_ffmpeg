import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/friend_unfriend/TABS/friends.dart';

class UserFriends extends StatelessWidget {
  final String? userid;
  final int friendCount;
  final String? userName;
  final bool? isProfileRoute;
  const UserFriends({
    super.key,
    this.userid,
    this.userName,
    this.isProfileRoute,
    required this.friendCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Row(
          children: [
            Text(
              translate(context, 'friends')!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 5,
            ),
            if (friendCount > 0)
              Text(
                '( ${friendCount.toString()} )',
                style: const TextStyle(fontWeight: FontWeight.w300),
              )
          ],
        ),
      ),
      body: Friends(userid: userid, isProfileRoute: isProfileRoute),
    );
  }
}
