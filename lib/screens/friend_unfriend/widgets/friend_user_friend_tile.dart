import 'package:flutter/cupertino.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:flutter/material.dart';

class FriendUserFriendTile extends StatefulWidget {
  final UserModelFriendandFollow? user;
  final int? index;
  final bool? myProfile;
  final bool? isProfileRoute;

  FriendUserFriendTile(
      {Key? key, this.user, this.myProfile, this.index, this.isProfileRoute})
      : super(key: key);

  @override
  _FriendUserFriendTileState createState() => _FriendUserFriendTileState();
}

class _FriendUserFriendTileState extends State<FriendUserFriendTile> {
  List<bool> following = [true, false];
  bool currentFollowing = false;

  void follow(bool follow) {
    setState(() {
      currentFollowing = follow;
    });
  }

  Future changeFriendFamily({role, userId}) async {
    log('Role....${role.toString()}');
    customDialogueLoader(context: context);
    String url = 'change-friend-role';
    Map<String, dynamic> mapData = {
      'user_id': userId,
      'role': role,
    };
    final response =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log('Response is ${response.toString()}');
    if (response['code'] == '200') {
      setState(
        () {
          widget.user?.role = role;
        },
      );
      toast(response['message']);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future followUser({userId, name}) async {
    customDialogueLoader(context: context);
    String url = 'unfriend';
    Map<String, dynamic> mapData = {"user_id": userId};
    var provider = Provider.of<FriendFollower>(context, listen: false);

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      if (mounted) {
        Navigator.pop(context);
      }
      toast(
          "${translate(context, 'unfriend')} $name ${translate(context, 'successfully')}");
      provider.removeFriendFollower(index: widget.index, user: widget.user);
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast('Error: ${res['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileTab(
              userId: widget.user!.id,
            ),
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: CircularImage(image: widget.user!.avatar.toString()),
      title: Text(
          '${widget.user!.firstName!.toString()} ${widget.user!.lastName!}'),
      subtitle: widget.user!.details!.mutualfriendsCount != 0
          ? Text(
              "${widget.user!.details!.mutualfriendsCount} ${translate(context, 'mutual_friend')!}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          : Text("@${widget.user!.username.toString()}"),
      trailing: widget.myProfile!
          ? widget.isProfileRoute == false
              ? SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            widget.user?.role == '2'
                                ? translate(context, 'friend')!
                                : widget.user?.role == '3'
                                    ? translate(context, 'family')!
                                    : translate(context, 'business')!,
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => {
                          translate(context, 'unfriend_this_user'),
                          translate(context, 'add_to_family'),
                          translate(context, 'add_to_business'),
                          translate(context, 'add_to_friend')
                        }
                            .map(
                              (e) => PopupMenuItem(
                                value: e,
                                child: Text(e!),
                              ),
                            )
                            .toList(),
                        onSelected: ((value) {
                          switch (value) {
                            case 'Unfriend this user':
                              showDialog<bool>(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(translate(
                                        context, 'unfriend_confirmation')!),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          followUser(
                                                  name: widget.user?.username,
                                                  userId: widget.user?.id)
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          translate(context, 'yes')!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          translate(context, 'no')!,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              break;
                            case 'Add To Family':
                              changeFriendFamily(
                                  userId: widget.user!.id, role: '3');
                              break;
                            case 'Add To Business':
                              changeFriendFamily(
                                  userId: widget.user!.id, role: '4');
                              break;
                            default:
                              changeFriendFamily(
                                  userId: widget.user!.id, role: '2');
                          }
                        }),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()
          : const SizedBox.shrink(),
    );
  }
}
