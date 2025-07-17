import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/friend_unfriend/TABS/user_friends.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/screens/settings/settings.page.dart';
import 'package:link_on/screens/settings/subpages/account.subpage.dart';
import 'package:link_on/screens/tabs/profile/block_profile.dart';
import 'package:link_on/screens/tabs/profile/profile_detail.dart';
import 'package:link_on/screens/tabs/profile/tabs/posts.tab.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:link_on/viewModel/api_client.dart';
import '../../PokeScreens/poke_screen.dart';
import 'report_user.dart';

class ProfileTab extends StatefulWidget {
  final String? userId;

  const ProfileTab({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  ProfileTabState createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab> {
  Usr usr = Usr();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<PostProvider>(context, listen: false);
    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }
    Provider.of<ProfilePostsProvider>(context, listen: false)
        .makeProfileListEmpty(widget.userId);
  }

  bool data = false;
  SiteSetting? site;

  Future<Map<String, dynamic>> getSiteSettings() async {
    var accessToken = getStringAsync("access_token");

    Response response = await dioService.dio.get(
      'get_site_settings',
      options: Options(
        headers: {"Authorization": 'Bearer $accessToken'},
      ),
    );

    return response.data;
  }

  void onTap() async {
    await Future.delayed(Duration.zero, () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: getSiteSettings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!["data"];
            site = SiteSetting.fromJson(data);
            return FutureBuilder<dynamic>(
                future: apiClient.get_user_data(userId: widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!["internet"] == true) {
                      // Handle no internet case
                    } else if (snapshot.data!["data"] != null) {
                      var data = snapshot.data!["data"];
                      usr = Usr.fromJson(data);
                    }

                    return snapshot.data!['message'] ==
                                translate(context, 'blocked_user') &&
                            snapshot.data!['data'] == null
                        ? Scaffold(
                            appBar: AppBar(
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 1,
                                      offset: Offset(0.1, 0.1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    translate(
                                        context, 'cannot_access_profile')!,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(translate(context, 'go_back')!),
                                  )
                                ],
                              ),
                            ),
                          )
                        : snapshot.data!["internet"] == true
                            ? CupertinoButton(
                                child: Text(translate(context, 'no_internet')!),
                                onPressed: () {
                                  setState(() {});
                                },
                              )
                            : Scaffold(
                                body: SafeArea(
                                  child: NestedScrollView(
                                    controller: _scrollController,
                                    headerSliverBuilder: (context, value) {
                                      return [
                                        SliverToBoxAdapter(
                                          child: UserDetail(
                                            data: usr,
                                            id: widget.userId,
                                          ),
                                        ),
                                      ];
                                    },
                                    body: widget.userId ==
                                                getStringAsync("user_id") ||
                                            widget.userId == null
                                        ? PostsTab(
                                            userId: widget.userId,
                                            controller: _scrollController,
                                          )
                                        : usr.isFriend == '1'
                                            ? PostsTab(
                                                userId: widget.userId,
                                                controller: _scrollController,
                                              )
                                            : usr.privateAccount == "1"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              AppColors
                                                                  .primaryColor,
                                                          child: Icon(
                                                            Icons.privacy_tip,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                usr.gender ==
                                                                        'Male'
                                                                    ? "${usr.firstName} ${translate(context, 'locked_his_profile')}"
                                                                    : '${usr.firstName} ${translate(context, 'locked_her_profile')}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                translate(
                                                                    context,
                                                                    'only_friends_can_see')!,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : PostsTab(
                                                    userId: widget.userId,
                                                    controller:
                                                        _scrollController,
                                                  ),
                                  ),
                                ),
                              );
                  } else {
                    return Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      body: Center(
                        child: Loader(),
                      ),
                    );
                  }
                });
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: Center(
                child: Loader(),
              ),
            );
          }
        });
  }
}

// User Image Class
class UserImage extends StatefulWidget {
  final Usr? usr;
  const UserImage({super.key, this.usr});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  @override
  Widget build(BuildContext context) {
    bool isUserOnline(String lastSeen) {
      if (lastSeen.isEmpty) {
        return false; // No last seen data, consider user offline
      }

      DateTime lastSeenTime = DateTime.parse(lastSeen);
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(lastSeenTime);
      // Consider the user online if the difference is within a certain timeframe
      return difference.inMinutes <= 5; // Adjust the timeframe as needed
    }

    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      image: widget.usr!.avatar,
                    ),
                  ),
                );
              },
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.usr!.avatar.toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // const Spacer(),
          ],
        ),
        // Online Status
        isUserOnline(widget.usr!.lastSeen)
            ? Positioned(
                bottom: 2,
                left: 20,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white)),
                ))
            : const SizedBox.shrink(),
      ],
    );
  }
}

// Username class
class UserName extends StatefulWidget {
  final Usr? usr;

  const UserName({super.key, this.usr});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "${widget.usr?.firstName} ${widget.usr?.lastName}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )),
                            if (widget.usr?.isVerified == "1")
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.verified,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (getUserData.value.id == widget.usr?.id) {
                      if (getUserData.value.facebook == '' ||
                          getUserData.value.facebook == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          getUserData.value.facebook)) {
                        launchUrlString(getUserData.value.facebook);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    } else {
                      if (widget.usr!.facebook == '' ||
                          widget.usr!.facebook == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          widget.usr!.facebook)) {
                        launchUrlString(widget.usr!.facebook);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    }
                  },
                  child: const Icon(LineIcons.facebook_square),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () async {
                    if (getUserData.value.id == widget.usr?.id) {
                      if (getUserData.value.instagram == '' ||
                          getUserData.value.instagram == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          getUserData.value.instagram)) {
                        launchUrlString(getUserData.value.instagram);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    } else {
                      if (widget.usr!.instagram == '' ||
                          widget.usr!.instagram == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          widget.usr!.instagram)) {
                        launchUrlString(widget.usr!.instagram);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    }
                  },
                  child: const Icon(LineIcons.instagram),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () async {
                    if (getUserData.value.id == widget.usr?.id) {
                      if (getUserData.value.youtube == '' ||
                          getUserData.value.youtube == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          getUserData.value.youtube)) {
                        launchUrlString(getUserData.value.youtube);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    } else {
                      if (widget.usr!.youtube == '' ||
                          widget.usr!.youtube == null) {
                        toast(translate(context, 'no_social_link')!);
                      } else if (await canLaunchUrlString(
                          widget.usr!.youtube)) {
                        launchUrlString(widget.usr!.youtube);
                      } else {
                        toast(translate(context, 'invalid_url')!);
                      }
                    }
                  },
                  child: const Icon(LineIcons.youtube),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Text(
              widget.usr?.username != null && widget.usr?.username != ""
                  ? "@${widget.usr?.username}"
                  : "",
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            //edit this username
                            title: const Text(
                              "Edit Username",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),

                            content: TextField(
                              controller: userNameController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 14),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    final getUsrData = Usr.fromJson(
                                      jsonDecode(
                                        getStringAsync("userData"),
                                      ),
                                    );
                                    log("User data isss ${getUsrData.id}");
                                    Map<String, dynamic> dataArray = {};
                                    dataArray['username'] =
                                        userNameController.text;
                                    log("Username is ${userNameController.text}");
                                    dynamic res =
                                        await apiClient.callApiCiSocial(
                                            apiPath: 'update-user-profile',
                                            apiData: dataArray);

                                    if (res["code"] == '200') {
                                      print(
                                          "vvvvvvvvvvvvvvvvv${res["data"].toString()}");
                                      setState(() {
                                        widget.usr!.username =
                                            userNameController.text;
                                      });
                                      Navigator.pop(context);
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ProfileTab(
                                      //       userId: getUsrData.id,
                                      //     ),
                                      //   ),
                                      // );

                                      toast(res['message']);
                                      //  getUserDataFunc(id);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(fontSize: 14),
                                  )),
                            ],
                          ));
                },
                icon: Icon(
                  Icons.edit,
                  color: AppColors.primaryColor,
                  size: 18,
                )),
          ],
        ),
        widget.usr?.aboutYou.toString() != "" && widget.usr?.aboutYou != null
            ? SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: Text(
                  widget.usr!.aboutYou.toString(),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

// //  User Details on Top class

class UserDetail extends StatefulWidget {
  final Usr? data;

  final String? id;

  const UserDetail({Key? key, this.data, this.id}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail>
    with SingleTickerProviderStateMixin {
  Future requestAction(
      {required String action, required String userId, int? index}) async {
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
        toast(translate(context, 'friend_request_accepted')!);
        setState(() {
          widget.data!.isFriend = '1';
        });
      } else {
        toast(translate(context, 'friend_request_cancelled')!);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast('Error: ${res['message']}');
    }
  }

  Future followUser({userId, name, cancelRequest}) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> mapData = {"friend_two": userId};
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: "make-friend", apiData: mapData);
    if (res["code"] == "200") {
      if (mounted) {
        Navigator.pop(context);
      }
      if (res["friend_status"] == "Not Friends") {
        if (cancelRequest == true) {
          toast(translate(context, 'friend_request_cancelled')!);

          setState(() {
            widget.data?.isFriend = '0';
            widget.data?.isPending = '0';
          });
        }
      } else if (res['friend_status'] == 'Request Sent') {
        setState(() {
          widget.data?.isPending = '1';
        });
        toast(translate(context, 'friend_request_sent')!);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future unfriendUser({userId, name}) async {
    String url = 'unfriend';
    Map<String, dynamic> mapData = {"user_id": userId};
    await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    setState(
      () {
        widget.data!.isFriend = '0';
        widget.data!.isPending = '0';
        widget.data!.isRequestReceived = '0';
      },
    );
  }

  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List relation = ["None", "Single", "In a relationship", "Married", "Engaged"];
  Future<void> blockUser(userid) async {
    log('User id is ${userid}');
    Map<String, dynamic> dataArray = {
      "user_id": userid,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'block-user', apiData: dataArray);
    if (res["code"] == 200) {
      toast(res['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlockProfile(),
        ),
      );
    } else {
      log('Error : ${res['message']}');
    }
  }

  // Future<void> pokeUser(userid) async {
  //   Map<String, dynamic> dataArray = {
  //     "user_id": userid,
  //   };
  //   dynamic res = await apiClient.callApiCiSocial(
  //     apiPath: 'poke-user',
  //     apiData: dataArray,
  //   );
  //   if (res["code"] == '200') {
  //     toast('You Poked');
  //   } else {
  //     log('Error : ${res['message']}');
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  bool isVisible(String? privacy) {
    bool isUserOwnData = widget.data!.id == getUserData.value.id;

    bool isEmailVisibleToFriends =
        widget.data!.isFriend == '1' && privacy == '1';

    bool isVisibleToEveryone = privacy == '0';

    bool isVisible =
        isUserOwnData || isEmailVisibleToFriends || isVisibleToEveryone;

    return isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailScreen(
                      image: widget.data!.cover.toString(),
                    )));
          },
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.22,
            width: MediaQuery.sizeOf(context).width,
            decoration: (widget.data!.cover == '' || widget.data!.cover == null)
                ? BoxDecoration(color: Colors.grey[300])
                : BoxDecoration(
                    image: DecorationImage(
                    image: NetworkImage(
                      widget.data!.cover.toString(),
                    ),
                    fit: BoxFit.cover,
                  )),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            offset: Offset(0.1, 0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          '${AppConfig.baseUrl}${widget.data!.username}');
                    },
                    child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.share_outlined,
                          size: 20,
                          shadows: [
                            Shadow(blurRadius: 1, offset: Offset(0.1, 0.1))
                          ],
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder<Usr>(
            valueListenable: getUserData,
            builder: (context, userData, child) {
              return Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.13,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        image: userData.id == widget.data!.id
                                            ? userData.avatar
                                            : widget.data!.avatar,
                                      ),
                                    ),
                                  );
                                },
                                child: UserImage(
                                  usr: userData.id == widget.data!.id
                                      ? userData
                                      : widget.data,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (!(widget.data!.privateAccount == '1' ||
                                widget.data!.id == getStringAsync("user_id")))
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 50, right: 20),
                                child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isDismissible: true,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: radiusCircular(10),
                                              topRight: radiusCircular(10),
                                            ),
                                          ),
                                          builder: (BuildContext bc) {
                                            return SizedBox(
                                              child: Wrap(
                                                children: [
                                                  if (widget.data!.isFriend ==
                                                      '1')
                                                    Consumer<
                                                            ProfilePostsProvider>(
                                                        builder: (context,
                                                            profileProvider,
                                                            child) {
                                                      return ListTile(
                                                        leading:
                                                            //  Lottie.asset('assets/LottieLogo1.json'),
                                                            Image(
                                                          image: AssetImage(
                                                            'assets/images/poke.png',
                                                          ),
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                          width: 35,
                                                        ),
                                                        title: profileProvider
                                                                .isPokeTileEnable
                                                            ? Text(
                                                                translate(
                                                                    context,
                                                                    'poke')!,
                                                              )
                                                            : Text(
                                                                "Already Poked"),
                                                        onTap: profileProvider
                                                                .isPokeTileEnable
                                                            ? () {
                                                                Navigator.pop(
                                                                    context);

                                                                profileProvider
                                                                    .pokeUser(
                                                                        widget
                                                                            .data!
                                                                            .id)
                                                                    .then(
                                                                        (val) {
                                                                  // if (val ==
                                                                  //     true) {
                                                                  //   // showLottiePopup(
                                                                  //   //     context);
                                                                  //   profileProvider
                                                                  //       .disableTileFor10Minutes();
                                                                  // }
                                                                });

                                                                // Future.delayed(
                                                                //     const Duration(
                                                                //         milliseconds:
                                                                //             200),
                                                                //     () {
                                                                //   Future.delayed(
                                                                //       Duration(
                                                                //           seconds:
                                                                //               2));
                                                                //   showLottiePopup(
                                                                //       context);

                                                                //   profileProvider
                                                                //       .pokeUser(widget
                                                                //           .data!
                                                                //           .id);
                                                                //   profileProvider
                                                                //       .disableTileFor10Minutes();
                                                                // });
                                                              }
                                                            : null,
                                                      );
                                                    }),
                                                  ListTile(
                                                    leading: const Icon(
                                                        CupertinoIcons
                                                            .exclamationmark_bubble_fill),
                                                    title: Text(
                                                      translate(context,
                                                          'report_profile')!,
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReportUser(
                                                            user: widget
                                                                    .data!.id ??
                                                                getStringAsync(
                                                                    "user_id"),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.person_off),
                                                    title: Text(
                                                      translate(
                                                          context, 'block')!,
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            titlePadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            title: Text(
                                                              translate(context,
                                                                  'block_confirmation')!,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            content: Text(
                                                              translate(context,
                                                                  'block_description')!,
                                                              style: const TextStyle(
                                                                  wordSpacing:
                                                                      1,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                child: Text(
                                                                  translate(
                                                                      context,
                                                                      'cancel')!,
                                                                  style: const TextStyle(
                                                                      color: AppColors
                                                                          .primaryColor),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  translate(
                                                                      context,
                                                                      'block')!,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  blockUser(widget
                                                                          .data!
                                                                          .id ??
                                                                      getStringAsync(
                                                                          "user_id"));
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    child: const Icon(
                                      Icons.more_vert,
                                      size: 20,
                                      color: AppColors.primaryColor,
                                    )),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: UserName(
                            usr: userData.id == widget.data?.id
                                ? userData
                                : widget.data,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: (widget.data!.privateAccount != '1' ||
                                        widget.data!.id == userData.id)
                                    ? () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileDetailScreen(
                                                        data: widget.data!)));
                                      }
                                    : null,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      translate(context, 'see_more_details')!,
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                              if ((isVisible(widget.data!.privacyEmail) &&
                                      widget.data!.email.toString() != "" &&
                                      widget.data!.email != null) &&
                                  (widget.data!.privateAccount != '1' ||
                                      widget.data!.id == userData.id))
                                Row(
                                  children: [
                                    const Icon(Icons.email),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.data!.email!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              if ((isVisible(widget.data!.privacyPhone) &&
                                      widget.data!.phone.toString() != "" &&
                                      widget.data!.phone != null) &&
                                  (widget.data!.privateAccount != '1' ||
                                      widget.data!.id == userData.id))
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.data!.phone!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              if ((isVisible(widget.data!.city) &&
                                      widget.data!.city.toString() != "" &&
                                      widget.data!.city != null) &&
                                  (widget.data!.privateAccount != '1' ||
                                      widget.data!.id == userData.id))
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.data!.city!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: widget.data!.id ==
                                          getStringAsync("user_id")
                                      ? () async {
                                          var userId = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserFriends(
                                                        userName:
                                                            userData.username,
                                                        userid: widget.data?.id,
                                                        friendCount: widget
                                                            .data!
                                                            .friendsCount!,
                                                      )));
                                          if (userId != null) {
                                            if (mounted) {
                                              context
                                                  .read<ProfilePostsProvider>()
                                                  .setUserId(userId,
                                                      flag: true);
                                            }
                                          }
                                        }
                                      : (widget.data!.privacySeeFriend == '0' ||
                                              (widget.data!.privacySeeFriend ==
                                                      '1' &&
                                                  widget.data!.isFriend == '1'))
                                          ? () async {
                                              var userId = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserFriends(
                                                            userName: userData
                                                                .username,
                                                            userid:
                                                                widget.data?.id,
                                                            friendCount: widget
                                                                .data!
                                                                .friendsCount!,
                                                          )));
                                              if (userId != null) {
                                                if (mounted) {
                                                  context
                                                      .read<
                                                          ProfilePostsProvider>()
                                                      .setUserId(userId,
                                                          flag: true);
                                                }
                                              }
                                            }
                                          : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            LineIcons.user_friends,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            translate(context, 'friends')!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                widget.data!.id ==
                                        getStringAsync(
                                          "user_id",
                                        )
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountSubpage(
                                                id: getStringAsync("user_id"),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12.0, horizontal: 15),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  translate(
                                                      context, 'edit_profile')!,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (widget.data!.isPending ==
                                              '1') ...[
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor),
                                                onPressed: () {
                                                  followUser(
                                                      cancelRequest: true,
                                                      userId: widget.data?.id,
                                                      name: widget
                                                          .data?.username);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person_add,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      translate(context,
                                                          'requested')!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                )),
                                          ] else ...[
                                            if (widget.data!.isFriend == '0' &&
                                                widget.data!
                                                        .isRequestReceived ==
                                                    '0') ...[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor),
                                                onPressed: (widget.data!
                                                                .privacyFriends ==
                                                            '0' ||
                                                        (widget.data!
                                                                    .privacyFriends ==
                                                                '1' &&
                                                            widget
                                                                    .data!
                                                                    .details!
                                                                    .mutualFriendCount! >
                                                                0))
                                                    ? () {
                                                        followUser(
                                                            userId:
                                                                widget.data?.id,
                                                            name: widget.data
                                                                ?.username);
                                                      }
                                                    : null,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person_add,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      translate(context,
                                                          'add_friend')!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ] else if (widget.data?.isFriend ==
                                                    '0' &&
                                                (widget.data?.isRequestReceived ==
                                                        '1' &&
                                                    widget.data?.isPending ==
                                                        '0')) ...[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        AppColors.primaryColor),
                                                onPressed: () async {
                                                  await requestAction(
                                                    action: 'accept',
                                                    userId: widget.data!.id!,
                                                  );
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      translate(context,
                                                          'accept_request')!,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ] else if (widget.data?.isFriend ==
                                                '1') ...[
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.2),
                                                  ),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      isDismissible:
                                                          true, // Set to true to allow dismissing on tap outside
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surface,
                                                      context: context,
                                                      builder:
                                                          (BuildContext bc) {
                                                        return SizedBox(
                                                          child: ListTile(
                                                            leading: const Icon(
                                                              Icons.cancel,
                                                            ),
                                                            title: Text(
                                                              translate(context,
                                                                  'unfriend')!,
                                                            ),
                                                            onTap: () {
                                                              unfriendUser(
                                                                      name: widget
                                                                          .data!
                                                                          .username,
                                                                      userId: widget
                                                                          .data!
                                                                          .id)
                                                                  .then(
                                                                (value) => {
                                                                  Navigator.pop(
                                                                      context),
                                                                  toast(
                                                                      '${translate(context, 'unfriend')} ${widget.data!.firstName.toString()} ${translate(context, 'successfully')}')
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.how_to_reg,
                                                        size: 18,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ],
                                                  )),
                                            ] else
                                              ...[],
                                          ],
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor),
                                            onPressed: () {
                                              isVisible(widget.data!
                                                          .privacyMessage) ==
                                                      true
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AgoraMessaging(
                                                                userId: widget
                                                                    .data!.id,
                                                                userAvatar:
                                                                    widget.data!
                                                                        .avatar,
                                                                userFirstName:
                                                                    widget.data!
                                                                        .firstName,
                                                                userLastName:
                                                                    widget.data!
                                                                        .lastName,
                                                              )))
                                                  : null;
                                            },
                                            child: const Icon(
                                              Icons.chat_outlined,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                        ],
                                      ),
                                const SizedBox(width: 5),
                                widget.data!.id == getStringAsync("user_id")
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            backgroundColor:
                                                AppColors.primaryColor),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PokeListPage()));
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/poke.png",
                                                color: Colors
                                                    .white, // Apply the white color
                                                colorBlendMode: BlendMode
                                                    .srcIn, // Blend mode to apply color
                                                height: 20,
                                                width: 20),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                translate(context, "pokes")
                                                    .toString(),
                                                style: TextStyle(
                                                    color: AppColors
                                                        .primaryLightColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10)),
                                          ],
                                        ))
                                    : Container(),
                                const SizedBox(width: 5),
                                if (userData.id == widget.data!.id)
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsPage(
                                                    userName: userData.username,
                                                    id: userData.id,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.settings,
                                      size: 25,
                                    ),
                                  )
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              translate(context, 'user_timeline')!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )),
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.1),
                          indent: 10,
                          endIndent: 10,
                          thickness: 1,
                        ),
                      ]));
            }),
      ],
    );
  }

  void showLottiePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: LottiePopup(),
        );
      },
    );
  }
}

class LottiePopup extends StatefulWidget {
  @override
  _LottiePopupState createState() => _LottiePopupState();
}

class _LottiePopupState extends State<LottiePopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Lottie.asset(
        'assets/images/lote-poke.json',
        height: 150,
        width: 150,
        onLoaded: (composition) {
          Future.delayed(composition.duration, () {
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}
