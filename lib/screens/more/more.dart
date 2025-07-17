// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/settings_base_view.dart';
import 'package:link_on/screens/bloodDonation/blood_donation.dart';
import 'package:link_on/screens/hashtag/trending_hashtag.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/settings/settings.page.dart';
import 'package:link_on/screens/settings/widgets/icon_tile.dart';
import 'package:link_on/screens/settings_base_view/settings_base_view.page.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/screens/upgrade/upgrade_pro.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/NearbyFriends/nearby_friends.dart';
import 'package:link_on/screens/friend_unfriend/friend_tab.dart';
import 'package:link_on/screens/games/games_screen.dart';
import 'package:link_on/screens/invite/invite_screen.dart';
import 'package:link_on/screens/products/products_home.dart';
import 'package:link_on/screens/search/new_search_page.dart';
import 'package:link_on/screens/settings/subpages/privacy_safety.subpage.dart';
import 'package:link_on/screens/settings/subpages/push_notifications.subpage.dart';
import 'package:link_on/screens/spaces/spaces_home/live_spaces.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/Blog/blogs.dart';
import 'package:link_on/screens/SavePosts/save_posts.dart';
import 'package:link_on/screens/events/event.dart';
import 'package:link_on/screens/groups/group.dart';
import 'package:link_on/screens/jobs/jobs.dart';
import 'package:link_on/screens/movies/movie.dart';
import 'package:link_on/screens/wallet/wallet.dart';
import 'package:provider/provider.dart';

import '../commonThings/common_things.dart';
import '../courses/courses.dart';

class More extends StatefulWidget {
  const More({super.key});
  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  // Explore
  List<String> getExploreIcon() {
    return [
      if (site!.chckSavedPost == '1') "assets/images/post.png",
      if (site!.chckHashtag == '1') "assets/images/hashtag.png",
      if (site!.chckMovies == '1') "assets/images/movie.png",
      if (site!.chckBlogs == '1') "assets/images/blog.png",
      if (site!.chckGames == '1') "assets/images/game.png",
      if (site!.chckJobSystem == '1') "assets/images/jobs.png",
      if (site!.chckProduct == '1') "assets/images/packaging.png",
      if (site!.chckCommonThings == '1') "assets/images/common.png",
      if (site!.chckAlbum == '1') "assets/images/album.png",
    ].where((iconPath) => iconPath.isNotEmpty).toList();
  }

  List<String> getExploreText() {
    return [
      if (site!.chckSavedPost == '1')
        translate(context, AppString.saved).toString(),
      if (site!.chckHashtag == '1')
        translate(context, AppString.hashtag).toString(),
      if (site!.chckMovies == '1')
        translate(context, AppString.movies).toString(),
      if (site!.chckBlogs == '1') translate(context, AppString.blog).toString(),
      if (site!.chckGames == '1')
        translate(context, AppString.games).toString(),
      if (site!.chckJobSystem == '1')
        translate(context, AppString.jobs).toString(),
      if (site!.chckProduct == '1')
        translate(context, AppString.market).toString(),
      if (site!.chckCommonThings == '1')
        translate(context, AppString.common_thing).toString(),
      if (site!.chckAlbum == '1')
        translate(context, AppString.album).toString(),
    ].where((text) => text.isNotEmpty).toList();
  }

  List<dynamic> getExploreRoute() {
    return [
      if (site!.chckSavedPost == '1') const SavePosts(),
      if (site!.chckHashtag == '1') const TrendingHashtag(),
      if (site!.chckMovies == '1') const MoviesList(),
      if (site!.chckBlogs == '1') const Blogs(),
      if (site!.chckGames == '1') const GamesScreen(),
      if (site!.chckJobSystem == '1') const JobPage(),
      if (site!.chckProduct == '1') const ProductsHomeScreen(),
      if (site!.chckCommonThings == '1') const CommonThings(),
      // if (site!.chckAlbum == '1') const AlbumMainList(),
    ].where((route) => route != null).toList();
  }

  List<dynamic> getExploreIconColor() {
    return [
      if (site!.chckSavedPost == '1') const Color(0xff1391dd).withOpacity(0.15),
      if (site!.chckHashtag == '1') const Color(0xffbde3fa).withOpacity(0.15),
      if (site!.chckMovies == '1') const Color(0xffd55bef).withOpacity(0.15),
      if (site!.chckBlogs == '1') const Color(0xff627d89).withOpacity(0.15),
      if (site!.chckGames == '1') const Color(0xffb7e1ab).withOpacity(0.15),
      if (site!.chckJobSystem == '1') const Color(0xff8c6e63).withOpacity(0.15),
      if (site!.chckProduct == '1') const Color(0xffffaf40).withOpacity(0.15),
      if (site!.chckCommonThings == '1')
        const Color.fromARGB(255, 255, 186, 204).withOpacity(0.15),
      // if (site!.chckAlbum == '1')
      //   const Color.fromARGB(255, 71, 248, 180).withOpacity(0.15),
    ].where((element) => element != null).toList();
  }

  // Community
  List<String> getCommunityIcon(bool isFriendSystem) {
    return [
      if (site!.chckGroups == '1') "assets/images/groups.png",
      if (site!.chckPages == '1') "assets/images/page.png",
      if (site!.chckEvents == '1') "assets/images/events.png",
      if (site!.chckSpaces == '1') "assets/images/spaces.png",
      if (site!.chckBloodBank == '1') "assets/images/blood-donation.png",
      "assets/images/friend.png",
      "assets/images/nearby.png",
      "assets/images/course.png",
    ].where((iconPath) => iconPath.isNotEmpty).toList();
  }

  List<String> getCommunityText(bool isFriendSystem) {
    return [
      if (site!.chckGroups == '1')
        translate(context, AppString.groups).toString(),
      if (site!.chckPages == '1')
        translate(context, AppString.pages).toString(),
      if (site!.chckEvents == '1')
        translate(context, AppString.events).toString(),
      if (site!.chckSpaces == '1')
        translate(context, AppString.spaces).toString(),
      if (site!.chckBloodBank == '1')
        translate(context, AppString.blood_bank).toString(),
      isFriendSystem
          ? translate(context, AppString.friends).toString()
          : "Following",
      if (site!.chckFindFriends == '1')
        translate(context, AppString.find_nearby).toString(),
      if (site!.chckFindFriends == '1')
        translate(context, AppString.courses).toString(),
      // "Explore"
    ].where((text) => text.isNotEmpty).toList();
  }

  List<dynamic> getCommunityIconColor() {
    return [
      if (site!.chckGroups == '1') const Color(0xffffc928).withOpacity(0.15),
      if (site!.chckPages == '1') const Color(0xff90caf8).withOpacity(0.15),
      if (site!.chckEvents == '1') const Color(0xffdc4d45).withOpacity(0.15),
      if (site!.chckSpaces == '1') const Color(0xff456cff).withOpacity(0.15),
      if (site!.chckBloodBank == '1') Colors.red.withOpacity(0.15),
      const Color(0xff4a9b4d).withOpacity(0.15),
      if (site!.chckFindFriends == '1')
        const Color(0xff456cff).withOpacity(0.15),
      if (site!.chckFindFriends == '1')
        const Color.fromARGB(255, 247, 0, 255).withOpacity(0.15),
      // const Color(0xff456cff).withOpacity(0.15),
    ].where((element) => element != null).toList();
  }

  Usr getUsrData = Usr();
  SiteSetting? site;
  @override
  void initState() {
    super.initState();
    final pro = Provider.of<PostProvider>(context, listen: false);
    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }
    Provider.of<VideoPlayerProvider>(context, listen: false)
        .disposeController();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));
  }

  Future<void> logout(comtext) async {
    var accessToken = getStringAsync("access_token");

    customDialogueLoader(context: context);
    String? url = "logout";
    Response response = await dioService.dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": 'Bearer $accessToken',
        },
      ),
    );

    var res = response.data;

    if (res["code"] == 200) {
      if (mounted) {
        Navigator.pop(context);
      }
      await removeKey("access_token");
      await removeKey("userData");
      await removeKey('access_token');

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login, (Route<dynamic> route) => false);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> getCommunityRoute(bool isFriendSystem) {
      return [
        if (site!.chckGroups == '1') const Groups(),
        if (site!.chckPages == '1') const ExplorePages(),
        if (site!.chckEvents == '1') const Event(),
        if (site!.chckSpaces == '1') const SpacesHome(),
        if (site!.chckBloodBank == '1') const BloodDonation(),
        const FriendTabs(),
        const NearbyFriends(),
        CoursesScreen(user: getUsrData),
        // CardPictures(getUsrData, [getUsrData, getUsrData], 1)
      ].where((route) => route != null).toList();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(getStringAsync("appLogo")),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewSearchPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.search_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                        id: getUsrData.id, userName: getUsrData.username),
                  ));
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: _NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder<Usr>(
                    valueListenable: getUserData,
                    builder: (context, value, child) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ProfileTab(
                                  userId: getUsrData.id,
                                )),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 25, right: 20),
                          leading: GestureDetector(
                            child: CircularImageNetwork(
                              image: value.avatar.toString(),
                              size: 45.0,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                          title: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: Text(
                                  (value.firstName != null &&
                                              value.lastName != null) &&
                                          (value.firstName != "" &&
                                              value.lastName != "")
                                      ? "${value.firstName!} ${value.lastName!}"
                                      : value.username.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              4.sw,
                              value.isVerified == "1"
                                  ? verified()
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          subtitle: Text(
                            translate(context, AppString.edit_personal_details)
                                .toString(),
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Theme(
                    data: ThemeData()
                        .copyWith(dividerColor: Colors.black.withOpacity(0.1)),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      expandedAlignment: Alignment.topLeft,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            const Color(0xfff2613a).withOpacity(0.1),
                        child: const Icon(
                          Icons.explore_outlined,
                          color: Color(0xfff2613a),
                          size: 20,
                        ),
                      ),
                      iconColor: AppColors.primaryColor,
                      collapsedIconColor:
                          Theme.of(context).colorScheme.onSurface,
                      title: Text(
                        translate(context, AppString.explore).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      children: [
                        Wrap(
                          spacing: MediaQuery.sizeOf(context).width * .05,
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            for (int index = 0;
                                index < getExploreRoute().length;
                                index++)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 1, right: 1),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                getExploreRoute()[index]));
                                  },
                                  child: SizedBox(
                                    height: 75,
                                    width:
                                        MediaQuery.sizeOf(context).width * .19,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  getExploreIconColor()[index],
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      getExploreIcon()[index],
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Center(
                                            child: Text(
                                              getExploreText()[index],
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: ThemeData()
                        .copyWith(dividerColor: Colors.black.withOpacity(0.1)),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: AppColors.primaryColor,
                      collapsedIconColor:
                          Theme.of(context).colorScheme.onSurface,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            const Color(0xFF456cff).withOpacity(0.1),
                        child: const Icon(
                          Icons.groups,
                          color: Color(0xFF456cff),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        translate(context, AppString.community).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      expandedAlignment: Alignment.topLeft,
                      children: [
                        Wrap(
                          spacing: MediaQuery.sizeOf(context).width * .05,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.spaceBetween,
                          alignment: WrapAlignment.start,
                          children: [
                            for (int index = 0;
                                index <
                                    getCommunityText(Constants.isFriendSystem)
                                        .length;
                                index++)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12, left: 1, right: 1),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                getCommunityRoute(Constants
                                                    .isFriendSystem)[index]));
                                  },
                                  child: Container(
                                    height: 75,
                                    width:
                                        MediaQuery.sizeOf(context).width * .19,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: getCommunityIconColor()[
                                                  index],
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          getCommunityIcon(
                                                              true)[index]),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Center(
                                            child: Text(
                                              getCommunityText(Constants
                                                  .isFriendSystem)[index],
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconTile(
                        icon: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.deepPurple.withOpacity(0.1),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                        ),
                        title:
                            translate(context, AppString.settings_and_activity)
                                .toString(),
                        onTap: () {
                          Navigator.of(context).push(createRoute(
                            SettingsPage(
                                id: getUsrData.id,
                                userName: getUsrData.username),
                          ));
                        },
                      ),
                      IconTile(
                        icon: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                const Color(0xff69609b).withOpacity(0.1),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Color(0xff69609b),
                            )),
                        title: translate(context, AppString.push_notifications)
                            .toString(),
                        onTap: () => navigateTo(
                          translate(context, AppString.push_notifications)
                              .toString(),
                          const PushNotificationsSubpage(),
                        ),
                      ),
                      IconTile(
                        icon: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(
                              Icons.privacy_tip_outlined,
                              color: Colors.blue,
                              size: 20,
                            )),
                        title: translate(context, AppString.privacy_and_safety)
                            .toString(),
                        onTap: () => navigateTo(
                            translate(
                              context,
                              AppString.privacy_and_safety,
                            ).toString(),
                            const PrivacySafetySubpage()),
                      ),
                      if (site!.chkWallet == "1")
                        IconTile(
                          icon: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            child: const Icon(
                              Icons.wallet,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                          title:
                              translate(context, AppString.wallet).toString(),
                          onTap: () => Navigator.of(context).push(createRoute(
                            const Wallet(),
                          )),
                        ),
                      if (site!.chkWallet == "1")
                        IconTile(
                          icon: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                const Color(0xffffc928).withOpacity(0.1),
                            child: const Icon(
                              Icons.workspace_premium_outlined,
                              color: Color(0xffffc928),
                              size: 20,
                            ),
                          ),
                          title: translate(context, AppString.upgrade_to_pro)
                              .toString(),
                          onTap: () => Navigator.of(context).push(createRoute(
                            const UpgradePro(),
                          )),
                        ),
                      SizedBox(
                        child: IconTile(
                          icon: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                const Color(0xff4a9b4d).withOpacity(0.1),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              color: Color(0xff4a9b4d),
                              size: 20,
                            ),
                          ),
                          title: translate(context, AppString.invite_a_friend)
                              .toString(),
                          onTap: () => Navigator.of(context).push(createRoute(
                            const InviteFriend(),
                          )),
                        ),
                      ),
                      IconTile(
                          icon: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: const Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          title:
                              translate(context, AppString.log_out).toString(),
                          onTap: () async {
                            await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    translate(
                                            context,
                                            AppString
                                                .are_you_sure_you_want_to_logout)
                                        .toString(),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      isDestructiveAction: true,
                                      onPressed: () async {
                                        logout(context);
                                      },
                                      child: Text(
                                        translate(context, AppString.log_out)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text(
                                        translate(context, AppString.cancel)
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateTo(String title, Widget widget) {
    Navigator.of(context).push(createRoute(
      SettingsBaseViewPage(
        baseView: SettingsBaseView(
          title: title,
          body: widget,
        ),
      ),
    ));
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
