import 'package:flutter/cupertino.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/outline_gradient_button.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/search/search_page_provider.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:flutter/material.dart';

class UserFriendTile extends StatefulWidget {
  final Usr? user;
  final String? query;
  final int? index;
  final UserModelFriendandFollow? data;
  const UserFriendTile({Key? key, this.user, this.index, this.data, this.query})
      : super(key: key);
  @override
  _UserFriendTileState createState() => _UserFriendTileState();
}

class _UserFriendTileState extends State<UserFriendTile> {
  List<bool> following = [true, false];
  bool currentFollowing = false;
  @override
  void initState() {
    super.initState();
  }

  Future requestAction({action, userId, index}) async {
    customDialogueLoader(context: context);
    String url = "friend-request-action";
    Map<String, dynamic> mapData = {
      "user_id": userId,
      "request_action": action
    };

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log('Value of Response .... ${res.toString()}');
    if (res["code"] == '200') {
      if (mounted) {
        Navigator.pop(context);
      }
      if (action == "accept") {
        toast(translate(context, 'accept_success'));

        setState(() {
          widget.user!.isFriend = '1';
        });
      } else {
        toast(translate(context, 'cancel_success'));
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast('${translate(context, 'error')}: ${res['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: ((context, value, child) {
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
          contentPadding: const EdgeInsets.only(right: 10, left: 10, top: 3),
          leading: CircularImage(
            image: widget.user!.avatar.toString(),
          ),
          title: Text(
              "${widget.user!.firstName!.toString()} ${widget.user!.lastName!.toString()}"),
          subtitle: Text(
            "${widget.user!.details!.mutualFriendCount} ${translate(context, 'mutual_friend')}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.24,
            height: 40,
            child: widget.user?.isRequestReceived == '1' &&
                    widget.user?.isFriend == '0' &&
                    widget.user?.isPending == '0'
                ? OutlineGradientButton(
                    padding: const EdgeInsets.all(5),
                    text: translate(context, 'accept_request').toString(),
                    onPressed: () {
                      requestAction(action: 'accept', userId: widget.user!.id);
                    },
                  )
                : (widget.user?.isFriend == '0' &&
                        widget.user?.isPending == '0')
                    ? SizedBox(
                        width: 100.0,
                        height: 35.0,
                        child: CustomButton(
                          color: AppColors.primaryColor,
                          wrap: true,
                          onPressed: () async {
                            await value
                                .makeRelation(
                              name: widget.user?.username,
                              userId: widget.user?.id,
                            )
                                .then(
                              (value) {
                                toast(
                                  value['message'],
                                );
                              },
                            );
                            setState(() async {
                              await value.search(
                                  query: widget.query, type: 'people');
                            });
                          },
                          text: translate(context, 'add_friend'),
                        ),
                      )
                    : (widget.user?.isPending == '1' &&
                            widget.user?.isFriend == "0")
                        ? OutlineGradientButton(
                            text: translate(context, 'requested').toString(),
                            onPressed: () {
                              showDialog<bool>(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      translate(context, 'remove_request')
                                          .toString(),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        isDestructiveAction: true,
                                        onPressed: () async {
                                          await value
                                              .makeRelation(
                                                  name: widget.user?.username,
                                                  userId: widget.user?.id)
                                              .then(
                                            (value) {
                                              toast(value['message']);
                                              Navigator.pop(context);
                                            },
                                          );
                                          setState(() async {
                                            await value.search(
                                              query: widget.query,
                                              type: 'people',
                                            );
                                          });
                                        },
                                        child: Text(
                                          translate(context, 'yes').toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          translate(context, 'no').toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          )
                        : widget.user?.isFriend == '1'
                            ? OutlineGradientButton(
                                text: translate(context, 'friend').toString(),
                                onPressed: () {
                                  showDialog<bool>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                          translate(context, 'unfriend')
                                              .toString(),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            isDestructiveAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              value
                                                  .unfriendUser(
                                                      name:
                                                          widget.user?.username,
                                                      userId: widget.user?.id)
                                                  .then(
                                                (value) {
                                                  final p = Provider.of<
                                                          FriendFollower>(
                                                      context,
                                                      listen: false);
                                                  p.removeFriendFollower(
                                                      index: widget.index,
                                                      user: widget.user);
                                                  Navigator.pop(context);
                                                  toast(value['message']);
                                                },
                                              );
                                              value.search(
                                                query: widget.query,
                                                type: 'people',
                                              );
                                            },
                                            child: Text(
                                              translate(context, 'yes')
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              translate(context, 'no')
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              )
                            : const SizedBox.shrink(),
          ),
        );
      }),
    );
  }
}
