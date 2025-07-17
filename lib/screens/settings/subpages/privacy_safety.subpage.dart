// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/switcher_tile.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/create_post/widgets/icon_tile.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class PrivacySafetySubpage extends StatefulWidget {
  const PrivacySafetySubpage({super.key});

  @override
  _PrivacySafetySubpageState createState() => _PrivacySafetySubpageState();
}

class _PrivacySafetySubpageState extends State<PrivacySafetySubpage> {
  Usr getUsrData = Usr();

  @override
  void initState() {
    super.initState();
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));
    fun();
  }

  int? friendRequestIndex;
  int? messageindex;
  int? friendlistindex;
  int? birthdayindex;
  int? postprivicyindex;
  int? activestatusindex;
  int? hangoutprivacyindex;
  int? emailindex;
  int? phoneindex;
  int? privateaccountindex;
  int? shareLocationIndex;
  int? lastseenindex;
  late bool privateAccount;
  late bool isonlinestatus;
  late bool hangoutPrivacy;
  late bool shareLocationStatus;
  String? listprivicydata;
  String? messageprivicydata;
  String? followprivicydata;
  String? birthdayprivicydata;
  String? emailPrivacyData;
  String? phonePrivacyData;

  void fun() {
    listprivicydata = listdata[int.parse(getUsrData.privacyFriends!)];
    messageprivicydata = messagedata[int.parse(getUsrData.privacyMessage!)];
    emailPrivacyData = emailData[int.parse(getUsrData.privacyEmail!)];
    phonePrivacyData = phoneData[int.parse(getUsrData.privacyPhone!)];
    followprivicydata = followdata[int.parse(getUsrData.privacyFriends!)];
    birthdayprivicydata = birthdaydata[int.parse(getUsrData.privacyBirthday!)];
    listsetIcon = listicondata[int.parse(getUsrData.privacyFriends!)];
    listsetIcon = listicondata[int.parse(getUsrData.privacyFriends!)];
    listsetIcon = listicondata[int.parse(getUsrData.privacyFriends!)];
    birthdaysetIcon = birthdayicondata[int.parse(getUsrData.privacyBirthday!)];
    emailsetTcon = emailicondata[int.parse(getUsrData.privacyEmail!)];
    phonesetTcon = phoneicondata[int.parse(getUsrData.privacyPhone!)];
    messagesetIcon = messageicondata[int.parse(getUsrData.privacyMessage!)];
    followsetIcon = followicondata[int.parse(getUsrData.privacyFriends!)];
    privateAccount = privateAccountData[int.parse(getUsrData.privateAccount!)];
    isonlinestatus = activeStatusData[int.parse(getUsrData.activeStatus!)];
    hangoutPrivacy = activeStatusData[int.parse(getUsrData.activeStatus!)];
    shareLocationStatus =
        shareLocationData[int.parse(getUsrData.shareMyLocation!)];
    setState(() {});
  }

  IconData? messagesetIcon;
  IconData? listsetIcon;
  IconData? birthdaysetIcon;
  IconData? followsetIcon;
  IconData? emailsetTcon;
  IconData? phonesetTcon;

  List<IconData> emailicondata = [
    Icons.public,
    Icons.people,
    Icons.lock,
  ];

  List<IconData> phoneicondata = [
    Icons.public,
    Icons.people,
    Icons.lock,
  ];

  List<IconData> messageicondata = [
    Icons.public,
    Icons.people,
    Icons.lock,
  ];
  List<IconData> followicondata = [
    Icons.public,
    Icons.people,
    Icons.lock,
  ];
  List<IconData> birthdayicondata = [
    Icons.public,
    Icons.people,
    Icons.lock,
  ];
  List<IconData> listicondata = [
    Icons.public,
    Icons.people,
    Icons.people,
    Icons.lock,
  ];

  List privateAccountData = [false, true];
  List activeStatusData = [false, true];
  List shareLocationData = [false, true];
  List messagedata = ["everyone", "friends", "no_one"];
  List emailData = ["everyone", "friends", "no_one"];
  List phoneData = ["everyone", "friends", "no_one"];

  messagebottomSheet(context) {
    return showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: messagedata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        messageprivicydata = messagedata[index];
                        messagesetIcon = messageicondata[index];
                        messageindex = messagedata.indexOf(messageprivicydata);
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: messageicondata[index],
                      title: translate(context, messagedata[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  emailbottomsheet(context) {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: emailData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        emailPrivacyData = emailData[index];
                        emailsetTcon = emailicondata[index];
                        emailindex = emailData.indexOf(emailPrivacyData);
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: emailicondata[index],
                      title: translate(context, emailData[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  phonebottomsheet(context) {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Theme.of(context).colorScheme.secondary,

      context: context,
      builder: (context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: phoneData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        phonePrivacyData = phoneData[index];
                        phonesetTcon = phoneicondata[index];
                        phoneindex = phoneData.indexOf(phonePrivacyData);
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: phoneicondata[index],
                      title: translate(context, phoneData[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  List listdata = ["everyone", "friends", "no_one"];
  listbottomSheet() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Theme.of(context).colorScheme.secondary,

      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: listdata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        listprivicydata = listdata[index];
                        listsetIcon = listicondata[index];
                        friendlistindex = listdata.indexOf(listprivicydata);
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: listicondata[index],
                      title: translate(context, listdata[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  List<String> followdata = ["everyone", "mutual_friends", "no_one"];
  followbottomSheet() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Theme.of(context).colorScheme.secondary,

      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: followdata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      followprivicydata = followdata[index];
                      followsetIcon = followicondata[index];
                      friendRequestIndex =
                          followdata.indexOf(followprivicydata!);
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: followicondata[index],
                      title: translate(context, followdata[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  List birthdaydata = ["everyone", "friends", "no_one"];

  birthdaybottomSheet(context) {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      backgroundColor: Theme.of(context).colorScheme.secondary,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) =>
                  const Divider(color: AppColors.bgcolor, thickness: 0.5)),
              itemCount: birthdaydata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        birthdayprivicydata = birthdaydata[index];
                        birthdaysetIcon = birthdayicondata[index];
                        birthdayindex =
                            birthdaydata.indexOf(birthdayprivicydata);
                      });
                      Navigator.pop(context);
                    },
                    child: IconTile(
                      icon: birthdayicondata[index],
                      title: translate(context, birthdaydata[index])!,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Future<void> updateUserData({id}) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> dataArray = {};
    log('Account Status .... a ${activestatusindex.toString()}');
    log('Account Status .... p ${privateaccountindex.toString()}');

    if ((friendRequestIndex != null)) {
      dataArray['privacy_friends'] = friendRequestIndex;
    }

    if ((emailindex != null)) {
      dataArray['privacy_view_email'] = emailindex;
    }

    if ((phoneindex != null)) {
      dataArray['privacy_view_phone'] = phoneindex;
    }

    if ((messageindex != null)) {
      dataArray['privacy_message'] = messageindex;
    }
    if ((birthdayindex != null)) {
      dataArray['privacy_birthday'] = birthdayindex;
    }

    if (privateaccountindex != null) {
      dataArray['privacy_private_account'] = privateaccountindex;
    }

    if ((friendlistindex != null)) {
      dataArray['privacy_see_friend'] = friendlistindex;
    }
    if ((activestatusindex != null)) {
      dataArray['privacy_active_status'] = activestatusindex;
    }
    if ((hangoutprivacyindex != null)) {
      dataArray['hangout_privacy'] = hangoutprivacyindex;
    }

    if (shareLocationIndex != null) {
      dataArray['privacy_share_my_location'] = shareLocationIndex;
    }

    if (dataArray.isEmpty) {
      Navigator.pop(context);
      toast(
        "Please update some data",
      );
      return;
    }
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: dataArray);

    log('Hi this is the response$res');

    if (res["code"] == "200") {
      if (mounted) {
        Navigator.pop(context);
      }
      toast(
        "Profile Privacy Updated ",
      );
      getUserData(id);
      setState(() {});
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> getUserData(userid) async {
    dynamic res = await apiClient.get_user_data(userId: userid);
    if (res["code"] == '200') {
      await setValue("userData", res["data"]);
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.tabs, (Route<dynamic> route) => false);
    } else {
      // toast('Error: ${res['errors']['error_text']}');
    }
  }

  // List data = ["Everyone", "Mutual Friends", "Only me"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          onTap: () {
            followbottomSheet();
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_send_me_a_friend_request)
                .toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, followprivicydata!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                followsetIcon,
                size: 16,
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () {
            messagebottomSheet(context);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_message_me).toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, messageprivicydata!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                messagesetIcon,
                size: 16,
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            emailbottomsheet(context);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_view_my_email).toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, emailPrivacyData!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                emailsetTcon,
                size: 16,
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            phonebottomsheet(context);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_view_my_phone_number)
                .toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, phonePrivacyData!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                phonesetTcon,
                size: 16,
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            listbottomSheet();
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_see_my_friend_list).toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, listprivicydata!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                listsetIcon,
                size: 16,
              )
            ],
          ),
        ),
        ListTile(
          onTap: () {
            birthdaybottomSheet(context);
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
            translate(context, AppString.who_can_see_my_birthday).toString(),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                translate(context, birthdayprivicydata!)!,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                birthdaysetIcon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 16,
              )
            ],
          ),
        ),
        SwitcherTile(
          title: translate(context, AppString.private_account).toString(),
          // subtitle:
          //     "With a private account, No one can see or visit your profile.",
          value: privateAccount,
          onChanged: (bool value) {
            setState(() {
              privateAccount = !privateAccount;
              privateAccount == true
                  ? privateaccountindex = 1
                  : privateaccountindex = 0;

              privateAccount == true
                  ? showDialog<bool>(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(
                            translate(context, 'make_account_private')!,
                          ),
                          // actionsAlignment: MainAxisAlignment.end,
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate(context, 'yes')!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () {
                                Navigator.pop(context, false);
                                setState(() {
                                  privateAccount = false;
                                  privateaccountindex = 0;
                                });
                              },
                              child: Text(
                                translate(context, 'no')!,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : null;
            });
          },
        ),
        SwitcherTile(
          title: translate(context, AppString.active_status).toString(),
          value: isonlinestatus,
          onChanged: (bool value) {
            setState(() {
              isonlinestatus = !isonlinestatus;
              isonlinestatus == true
                  ? activestatusindex = 1
                  : activestatusindex = 0;
            });
          },
        ),
        SwitcherTile(
          title: translate(context, AppString.available_for_hangout).toString(),
          value: hangoutPrivacy,
          onChanged: (bool value) {
            setState(() {
              hangoutPrivacy = !hangoutPrivacy;
              hangoutPrivacy == true
                  ? hangoutprivacyindex = 1
                  : hangoutprivacyindex = 0;
            });
          },
        ),
        SwitcherTile(
          title: translate(context, AppString.share_location).toString(),
          value: shareLocationStatus,
          onChanged: (bool value) {
            setState(() {
              shareLocationStatus = !shareLocationStatus;
              shareLocationStatus == true
                  ? shareLocationIndex = 1
                  : shareLocationIndex = 0;
              log("Account Status Active Indexx$shareLocationIndex");
            });
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: CustomButton(
                text: translate(context, AppString.update_privacy).toString(),
                onPressed: () {
                  updateUserData(id: getUsrData.id);
                })),
        const SizedBox(height: 20),
      ]),
    );
  }
}
