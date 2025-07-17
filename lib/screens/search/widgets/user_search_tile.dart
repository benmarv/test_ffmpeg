import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/outline_gradient_button.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:flutter/material.dart';

class UserSearchTile extends StatefulWidget {
  final Usr? user;

  const UserSearchTile({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _UserSearchTileState createState() => _UserSearchTileState();
}

class _UserSearchTileState extends State<UserSearchTile> {
  List<int> count = [4, 5, 6, 7, 8, 9];
  int? currentCount;

  List<bool> following = [true, false];
  late bool currentFollowing;

  void follow(bool follow) {
    setState(() {
      currentFollowing = follow;
    });
  }

  @override
  void initState() {
    count.shuffle();
    currentCount = count[0];

    following.shuffle();
    currentFollowing = following[0];
    super.initState();
  }

  TabsPageState tap = TabsPageState();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileTab(
                      userId: widget.user!.id,
                    )));
      },
      contentPadding: EdgeInsets.zero,
      leading: CircularImage(image: widget.user!.avatar.toString()),
      title: Text('${widget.user!.firstName} ${widget.user!.lastName}'),
      subtitle: widget.user!.details!.mutualFriendCount != false &&
              widget.user!.details!.mutualFriendCount != 0
          ? Text(
              "${widget.user?.details?.mutualFriendCount} ${translate(context, 'mutual_friends')}")
          : const SizedBox.shrink(),
      trailing: widget.user?.isFriend == "0"
          ? SizedBox(
              width: 100.0,
              height: 35.0,
              child: CustomButton(
                wrap: true,
                onPressed: () => follow(true),
                text: "Follow",
              ),
            )
          : OutlineGradientButton(
              text: "Following",
              onPressed: () => follow(false),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
    );
  }
}
