// ignore_for_file: library_private_types_in_public_api

import 'package:link_on/components/switcher_tile.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/screens/settings/widgets/settings_section.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:flutter/material.dart';

class PushNotificationsSubpage extends StatefulWidget {
  const PushNotificationsSubpage({super.key});

  @override
  _PushNotificationsSubpageState createState() =>
      _PushNotificationsSubpageState();
}

class _PushNotificationsSubpageState extends State<PushNotificationsSubpage> {
  Usr? getUsr;
  bool isdata = false;
  Future<void> getUser() async {
    dynamic res = await apiClient.get_user_data(userId: getUserData.value.id);
    if (res["code"] == '200') {
      isdata = true;
      getUsr = Usr.fromJson(res["data"]);
      funtion();
      setState(() {});
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  bool likes = false;
  bool comments = false;
  bool shared = false;
  bool friend = false;
  bool pages = false;
  bool groups = false;
  bool remember = false;

  funtion() {
    likes = getUsr?.notifyLike == "1" ? true : false;
    comments = getUsr?.notifyComment == "1" ? true : false;
    shared = getUsr?.notifySharePost == "1" ? true : false;
    friend = getUsr?.notifyAcceptRequest == "1" ? true : false;
    pages = getUsr?.notifyLikedPage == "1" ? true : false;
    groups = getUsr?.notifyJoinedGroup == "1" ? true : false;
    remember = getUsr?.memory == "1" ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isdata == true
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              children: [
                SettingsSection(
                  title:
                      translate(context, AppString.notify_me_when).toString(),
                  children: <Widget>[
                    SwitcherTile(
                      title: translate(context, AppString.someone_likes_my_post)
                          .toString(),
                      value: likes,
                      onChanged: (bool value) {
                        setState(() {
                          likes = !likes;
                        });
                      },
                    ),
                    SwitcherTile(
                      title: translate(
                              context, AppString.someone_commented_on_my_post)
                          .toString(),
                      value: comments,
                      onChanged: (bool value) {
                        setState(() {
                          comments = !comments;
                        });
                      },
                    ),
                    SwitcherTile(
                      title:
                          translate(context, AppString.someone_shared_my_post)
                              .toString(),
                      value: shared,
                      onChanged: (bool value) {
                        setState(() {
                          shared = !shared;
                        });
                      },
                    ),
                    SwitcherTile(
                      title: translate(context,
                              AppString.someone_sent_me_a_friend_request)
                          .toString(),
                      value: friend,
                      onChanged: (bool value) {
                        setState(() {
                          friend = !friend;
                        });
                      },
                    ),
                    SwitcherTile(
                      title:
                          translate(context, AppString.someone_joined_my_group)
                              .toString(),
                      value: groups,
                      onChanged: (bool value) {
                        setState(() {
                          groups = !groups;
                        });
                      },
                    ),
                    SwitcherTile(
                      title: translate(context, AppString.someone_liked_my_page)
                          .toString(),
                      value: pages,
                      onChanged: (bool value) {
                        setState(() {
                          pages = !pages;
                        });
                      },
                    ),
                    SwitcherTile(
                      title: translate(
                              context, AppString.i_have_a_memory_to_celebrate)
                          .toString(),
                      value: remember,
                      onChanged: (bool value) {
                        setState(() {
                          remember = !remember;
                        });
                      },
                    ),
                  ],
                ),
                20.sh,
                CustomButton(
                    text: translate(context, AppString.save).toString(),
                    onPressed: () {
                      updateUserData(
                        likes: likes,
                        comments: comments,
                        shared: shared,
                        friend: friend,
                        pages: pages,
                        groups: groups,
                        remember: remember,
                      );
                    })
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
  }

  Future<void> updateUserData({
    likes,
    comments,
    shared,
    friend,
    pages,
    groups,
    timeline,
    remember,
  }) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> dataArray = {};

    if ((likes != null && likes != "")) {
      dataArray['notify_like'] = likes == true ? 1 : 0;
    }
    if ((comments != null && comments != "")) {
      dataArray['notify_comment'] = comments == true ? 1 : 0;
    }
    if ((shared != null && shared != "")) {
      dataArray['notify_share_post'] = shared == true ? 1 : 0;
    }
    if ((friend != null && friend != "")) {
      dataArray['notify_accept_request'] = friend == true ? 1 : 0;
    }
    if ((pages != null && pages != "")) {
      dataArray['notify_liked_page'] = pages == true ? 1 : 0;
    }
    if ((groups != null && groups != "")) {
      dataArray['notify_joined_group'] = groups == true ? 1 : 0;
    }
    if ((remember != null && remember != "")) {
      dataArray['memory'] = remember == true ? 1 : 0;
    }
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: dataArray);
    log(res.toString());
    if (res["code"] == "200") {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);

        toast("Notification Settings Updated Successfully");
      }
      getUser();
      setState(() {});
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
