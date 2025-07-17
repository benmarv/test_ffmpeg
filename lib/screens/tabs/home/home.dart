// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/components/GoogleAd/banner_ad.dart';
import 'package:link_on/components/PostSkeleton/groupsShimmer.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/components/connectivity_screen/nointernet.dart';
import 'package:link_on/components/connectivity_screen/timeout.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/controllers/FriendProvider/friends_suggestions_Provider.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/controllers/PageProvider/update_page_data_provider.dart';
import 'package:link_on/controllers/gamesProvider/game_provider.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/controllers/jobsProvider/myjobs_provider.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/create_post/overlay.dart';
import 'package:link_on/screens/deep_linking/deep_link_handler.dart';
import 'package:link_on/screens/events/event_details.dart';
import 'package:link_on/screens/games/game_detail_screen.dart';
import 'package:link_on/screens/groups/group_details.dart';
import 'package:link_on/screens/jobs/jobs_details.dart';
import 'package:link_on/screens/pages/detail_page.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/products/product_detail.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/tabs/profile/notifications/notifications.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/screens/spaces/spaces_home/live_spaces.dart';
import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/ChatsScreens/chats_tab.dart';
import 'package:link_on/screens/search/new_search_page.dart';
import 'package:link_on/screens/tabs/home/greetings_card.dart';
import 'package:link_on/screens/tabs/home/widgets/home_widgets.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  SiteSetting? site;
  Usr? getUserData;
  // PageController _pageController = PageController();

  updateTimeZone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: {"timeZone": currentTimeZone});
  }

  // void logMemoryUsage() {
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     developer.log('Memory Usage: ${ProcessInfo.currentRss} bytes');
  //     developer.log('Memory Usage maximum: ${ProcessInfo.maxRss} bytes');
  //   }
  // }

  @override
  void initState() {
    final pro = Provider.of<PostProvider>(context, listen: false);
    final videoPro = Provider.of<VideoPlayerProvider>(context, listen: false);
    final randomVideoPro =
        Provider.of<RandomVideoProvider>(context, listen: false);
    final getUserStoryPro =
        Provider.of<GetUserStoryProvider>(context, listen: false);
    final liveStreamPro =
        Provider.of<LiveStreamProvider>(context, listen: false);

    updateTimeZone();
    DeepLinkHandler.initDeepLinks();

    getUserData = Usr.fromJson(jsonDecode(getStringAsync('userData')));
    log('Token ${getStringAsync('access_token')}');

    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }

    videoPro.disposeController();

    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    pro.initScrollController();

    progressValue.addListener(() {
      if (progressValue.value == 100.0) {
        if (pro.isAudioData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pro.postListProvider.clear();
            pro.getApiDataProvider(context: context);
            pro.isAudioData = false;
          });
        }
      }
    });

    if (pro.postListProvider.isEmpty) {
      pro.getApiDataProvider(context: context);
    }

    if (!context.read<PostProvider>().hideNotification) {
      context.read<PostProvider>().forNotificationBadge();
    }

    if (randomVideoPro.randomVideoListProvider.isEmpty) {
      randomVideoPro.gertRandomVideo(context: context, isHome: true);
    }

    getUserStoryPro.getUsersStories(context: context);
    liveStreamPro.getAllLiveUsers();

    context.read<PostProvider>().scrollController.addListener(() {
      var postId = pro.postListProvider[pro.postListProvider.length - 1].id;
      final scrollController = pro.scrollController;
      final maxScrollExtent = scrollController.position.maxScrollExtent;
      final currentPixels = scrollController.position.pixels;

      // Track the last known scroll position
      if (pro.lastScrollingPosition == null) {
        pro.lastScrollingPosition = currentPixels;
      }

      // Check the scroll direction
      bool isScrollingDown = currentPixels > pro.lastScrollingPosition!;

      // Number of posts left to reach the bottom to trigger the API call
      final thresholdPostsCount = 3;
      final postHeight = scrollController.position.maxScrollExtent /
          pro.postListProvider.length;
      final triggerPosition =
          maxScrollExtent - (postHeight * thresholdPostsCount);
      // get more posts
      if (currentPixels >= triggerPosition &&
          pro.hitApi == false &&
          isScrollingDown) {
        pro.checkBottomBool(true);
        pro.hitPostApi(true);
        pro.getApiDataProvider(afterPostId: postId, context: context);
      }
      // Update the last known scroll position
      pro.lastScrollingPosition = currentPixels;
    });
    super.initState();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    context.read<PostProvider>().remvoveController();
    Provider.of<InitializePostVideoProvider>(context, listen: false)
        .flickManager!
        .dispose();
    // _pageController.animateToPage(0,
    //     duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    super.dispose();
  }

  // Community
  // List<String> getCommunityIcon() {
  //   return [
  //     if (site!.chckGroups == '1') "assets/images/groups.png",
  //     if (site!.chckPages == '1') "assets/images/page.png",
  //     if (site!.chckEvents == '1') "assets/images/events.png",
  //     if (site!.chckSpaces == '1') "assets/images/spaces.png",
  //     "assets/images/friend.png",
  //     if (site!.chckGames == '1') "assets/images/game.png",
  //     if (site!.chckJobSystem == '1') "assets/images/jobs.png",
  //     if (site!.chckProduct == '1') "assets/images/packaging.png",
  //   ].where((iconPath) => iconPath.isNotEmpty).toList();
  // }

  // List<String> getCommunityText() {
  //   return [
  //     if (site!.chckGroups == '1') translate(context, "groups").toString(),
  //     if (site!.chckPages == '1') translate(context, "pages").toString(),
  //     if (site!.chckEvents == '1') translate(context, "events").toString(),
  //     if (site!.chckSpaces == '1') translate(context, "spaces").toString(),
  //     translate(context, "friends").toString(),
  //     if (site!.chckGames == '1') translate(context, "games").toString(),
  //     if (site!.chckJobSystem == '1') translate(context, "jobs").toString(),
  //     if (site!.chckProduct == '1') translate(context, "market").toString(),
  //   ].where((text) => text.isNotEmpty).toList();
  // }

  // List<dynamic> getCommunityIconColor() {
  //   return [
  //     if (site!.chckGroups == '1') const Color(0xffffc928).withOpacity(0.15),
  //     if (site!.chckPages == '1') const Color(0xff90caf8).withOpacity(0.15),
  //     if (site!.chckEvents == '1') const Color(0xffdc4d45).withOpacity(0.15),
  //     if (site!.chckSpaces == '1') const Color(0xff456cff).withOpacity(0.15),
  //     const Color(0xff4a9b4d).withOpacity(0.15),
  //     if (site!.chckGames == '1') const Color(0xffb7e1ab).withOpacity(0.15),
  //     if (site!.chckJobSystem == '1') const Color(0xff8c6e63).withOpacity(0.15),
  //     if (site!.chckProduct == '1') const Color(0xffffaf40).withOpacity(0.15),
  //     // ignore: unnecessary_null_comparison
  //   ].where((element) => element != null).toList();
  // }

  @override
  Widget build(BuildContext context) {
    // GroupsProvider groupsProvider =
    // Provider.of<GroupsProvider>(context, listen: false);
    // final double screenWidth = MediaQuery.sizeOf(context).width;
    // final BorderRadius avatarBorderRadius = BorderRadius.circular(100);
    // final Color avatarBorderColor = Colors.grey.shade400.withOpacity(.5);
    const Color avatarBackgroundColor = AppColors.primaryColor;
    var postProviderIns = Provider.of<PostProvider>(context, listen: false);
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: avatarBackgroundColor,
      strokeWidth: 3.0,
      onRefresh: () async {
        postProviderIns.resfreshPosts(
          context: context,
        );
        Provider.of<LiveStreamProvider>(context, listen: false)
            .getAllLiveUsers();
        Provider.of<GetUserStoryProvider>(context, listen: false)
            .getUsersStories(
          context: context,
        );
      },
      child: Scaffold(
        body: postProviderIns.noInternet == true &&
                postProviderIns.postListProvider.isEmpty
            ? NoInternet(
                onPress: () {
                  postProviderIns.getApiDataProvider(context: context);
                },
              )
            : postProviderIns.connectivityTimeout == true &&
                    postProviderIns.postListProvider.isEmpty
                ? Timeout(
                    onPress: () {
                      postProviderIns.getApiDataProvider(context: context);
                    },
                  )
                : CustomScrollView(
                    key: const PageStorageKey("posts"),
                    controller: postProviderIns.scrollController,
                    slivers: [
                      // App bar
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        pinned: true,
                        forceElevated: true,
                        surfaceTintColor: Colors.transparent,
                        flexibleSpace: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (!postProviderIns.hitApi) {
                                    postProviderIns.resfreshPosts(
                                        context: context);
                                    postProviderIns.scrollController
                                        .jumpToTop();
                                  }
                                },
                                child: Container(
                                  height: 20,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        getStringAsync("appLogo"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NewSearchPage(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.search_rounded,
                                      size: 24,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationsTab()),
                                      );
                                    },
                                    icon: Consumer<PostProvider>(
                                      builder: (context, value, child) {
                                        return Badge(
                                          backgroundColor:
                                              AppColors.gradientColor1,
                                          textColor: Colors.white,
                                          label: Text(
                                            value.totalNotifications.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          isLabelVisible:
                                              value.totalNotifications == 0
                                                  ? false
                                                  : true,
                                          child: const Icon(
                                            Icons.notifications,
                                            size: 24,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatsTab(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      CupertinoIcons
                                          .bolt_horizontal_circle_fill,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Stories, Live, create Post
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               CreatePostPage(val: true)),
                                //     );
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //         left: 10, top: 5, bottom: 5),
                                //     child: Row(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Row(
                                //           children: [
                                //             GestureDetector(
                                //               onTap: () {
                                //                 Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                     builder: (context) =>
                                //                         ProfileTab(),
                                //                   ),
                                //                 );
                                //               },
                                //               child: getUserData?.avatar ==
                                //                           null ||
                                //                       getUserData?.avatar == ""
                                //                   ? const CircleAvatar(
                                //                       backgroundColor:
                                //                           avatarBackgroundColor,
                                //                       radius: 18,
                                //                     )
                                //                   : PhysicalModel(
                                //                       color: Colors.white,
                                //                       borderRadius:
                                //                           avatarBorderRadius,
                                //                       child: Container(
                                //                         decoration:
                                //                             BoxDecoration(
                                //                           borderRadius:
                                //                               avatarBorderRadius,
                                //                           border: Border.all(
                                //                               color:
                                //                                   avatarBorderColor),
                                //                         ),
                                //                         child: CircleAvatar(
                                //                           radius: 18,
                                //                           backgroundColor:
                                //                               avatarBackgroundColor,
                                //                           backgroundImage:
                                //                               NetworkImage(
                                //                             getUserData!.avatar
                                //                                 .toString(),
                                //                           ),
                                //                         ),
                                //                       ),
                                //                     ),
                                //             ),
                                //             const SizedBox(width: 10),
                                //             Container(
                                //               height: 35,
                                //               width: screenWidth * .7,
                                //               decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(20),
                                //                 border: Border.all(
                                //                     color: Colors.grey
                                //                         .withOpacity(.4)),
                                //               ),
                                //               child: Padding(
                                //                 padding: EdgeInsets.only(
                                //                     top: 3,
                                //                     bottom: 3,
                                //                     left: 15,
                                //                     right: screenWidth * .1),
                                //                 child: Text(
                                //                   translate(context,
                                //                           "whats_on_your_mind")
                                //                       .toString(),
                                //                   style: TextStyle(
                                //                       fontWeight:
                                //                           FontWeight.w400,
                                //                       fontSize: 14),
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //          const Padding(
                                //            padding: EdgeInsets.only(right: 15.0),
                                //            child: Icon(
                                //                Icons.photo_library_outlined,
                                //               color: Colors.green,
                                //               size: 23),
                                //          )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Divider(
                                    thickness: 8,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                site?.enableDisableStories == "1"
                                    ? Column(
                                        children: [
                                          const SizedBox(height: 2),
                                          customListView(
                                              context: context,
                                              avatar: getUserData!.avatar!),
                                          Divider(
                                              thickness: 8,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                site?.chckAfternoonSystem == '1'
                                    ? Consumer<GreetingsProvider>(
                                        builder: (context, value, child) =>
                                            value.greetingVisibilty != false
                                                ? const GreetingCard()
                                                : const SizedBox.shrink(),
                                      )
                                    :  SizedBox.shrink(),
                                // if (site?.chckHomeMenuTab == '1') ...[
                                //   Consumer<GreetingsProvider>(
                                //     builder: (context, value, child) =>
                                //         value.homeMenuTab != false
                                //             ? Column(
                                //                 children: [
                                //                   Stack(
                                //                     children: [
                                //                       Container(
                                //                         height: 200,
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .only(
                                //                                 top: 20),
                                //                         width: MediaQuery
                                //                                 .sizeOf(
                                //                                     context)
                                //                             .width,
                                //                         child: PageView(
                                //                           controller:
                                //                               _pageController,
                                //                           physics:
                                //                               NeverScrollableScrollPhysics(),
                                //                           children: [
                                //                             Wrap(
                                //                               spacing: MediaQuery.sizeOf(
                                //                                           context)
                                //                                       .width *
                                //                                   0.05,
                                //                               direction: Axis
                                //                                   .horizontal,
                                //                               runAlignment:
                                //                                   WrapAlignment
                                //                                       .spaceBetween,
                                //                               alignment:
                                //                                   WrapAlignment
                                //                                       .start,
                                //                               children: [
                                //                                 for (int index =
                                //                                         0;
                                //                                     index <
                                //                                         getCommunityText().length;
                                //                                     index++)
                                //                                   Padding(
                                //                                     padding: const EdgeInsets
                                //                                         .only(
                                //                                         top:
                                //                                             12,
                                //                                         left:
                                //                                             1,
                                //                                         right:
                                //                                             1),
                                //                                     child:
                                //                                         InkWell(
                                //                                       onTap:
                                //                                           () async {
                                //                                         log('tab index $index');
                                //                                         groupsProvider.setHomeMenuIndex(index);
                                //                                         setState(() {});
                                //                                         // Slide to the next page
                                //                                         _pageController.animateToPage(1,
                                //                                             duration: Duration(milliseconds: 300),
                                //                                             curve: Curves.easeInOut);

                                //                                         if (index ==
                                //                                             0) {
                                //                                           groupsProvider.currentScreen = "discover";
                                //                                           groupsProvider.makeGroupListEmpty('discover');
                                //                                           groupsProvider.getdiscovergroup();
                                //                                         } else if (index ==
                                //                                             1) {
                                //                                           UpdatePageDataProvider pageProvider = Provider.of<UpdatePageDataProvider>(context, listen: false);
                                //                                           pageProvider.makeDiscoverPagesEmpty();
                                //                                           pageProvider.getAllPages();
                                //                                         } else if (index ==
                                //                                             2) {
                                //                                           var provider = Provider.of<GetEventApiProvider>(context, listen: false);

                                //                                           provider.currentEventName = "events";
                                //                                           provider.setEventName = "events";
                                //                                           provider.getEventData.clear();
                                //                                           if (provider.getEventData.isEmpty) {
                                //                                             await provider.eventHandler("events");
                                //                                           }
                                //                                         } else if (index ==
                                //                                             3) {
                                //                                           final spaceProvider = context.read<SpaceProvider>();
                                //                                           spaceProvider.makeSpacesListEmpty();
                                //                                           spaceProvider.getAllSpaces();
                                //                                         } else if (index ==
                                //                                             4) {
                                //                                           FriendFriendSuggestProvider friendSuggestProvider = Provider.of<FriendFriendSuggestProvider>(context, listen: false);
                                //                                           friendSuggestProvider.makeFriendSuggestedEmtyList();
                                //                                           Map<String, dynamic> mapData = {
                                //                                             "limit": 10,
                                //                                           };
                                //                                           friendSuggestProvider.friendSuggestUserList(mapData: mapData);
                                //                                         } else if (index ==
                                //                                             5) {
                                //                                           Provider.of<GamesProvider>(context, listen: false).getGames();
                                //                                         } else if (index ==
                                //                                             6) {
                                //                                           MyJobList provider = Provider.of<MyJobList>(context, listen: false);
                                //                                           provider.makeAllJobsListEmpty();
                                //                                           if (provider.alljoblist.isEmpty) {
                                //                                             await provider.searchjob(currentJobTab: "alljobs");
                                //                                           }
                                //                                         } else if (index ==
                                //                                             7) {
                                //                                           final provider = Provider.of<GetProductProvider>(context, listen: false);
                                //                                           provider.setScreenName = "get_product";
                                //                                           provider.productList.clear();
                                //                                           if (provider.productList.isEmpty) {
                                //                                             await provider.getProducts(screenName: 'get_product');
                                //                                           }
                                //                                         }
                                //                                       },
                                //                                       child:
                                //                                           SizedBox(
                                //                                         height:
                                //                                             75,
                                //                                         width:
                                //                                             MediaQuery.sizeOf(context).width * .19,
                                //                                         child:
                                //                                             Center(
                                //                                           child: Column(
                                //                                             children: [
                                //                                               Container(
                                //                                                 height: 50,
                                //                                                 width: 50,
                                //                                                 decoration: BoxDecoration(
                                //                                                   shape: BoxShape.circle,
                                //                                                   color: getCommunityIconColor()[index],
                                //                                                 ),
                                //                                                 child: Center(
                                //                                                   child: Container(
                                //                                                     height: 32,
                                //                                                     width: 32,
                                //                                                     decoration: BoxDecoration(
                                //                                                       shape: BoxShape.circle,
                                //                                                       image: DecorationImage(image: AssetImage(getCommunityIcon()[index]), fit: BoxFit.cover),
                                //                                                     ),
                                //                                                   ),
                                //                                                 ),
                                //                                               ),
                                //                                               const SizedBox(
                                //                                                 height: 7,
                                //                                               ),
                                //                                               Center(
                                //                                                 child: Text(
                                //                                                   getCommunityText()[index],
                                //                                                   textAlign: TextAlign.center,
                                //                                                   style: const TextStyle(
                                //                                                     fontSize: 11,
                                //                                                     fontWeight: FontWeight.w700,
                                //                                                   ),
                                //                                                 ),
                                //                                               ),
                                //                                             ],
                                //                                           ),
                                //                                         ),
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                               ],
                                //                             ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 0)
                                //                               GroupsListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 1)
                                //                               PagesListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 2)
                                //                               EventsListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 3)
                                //                               SpacesListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 4)
                                //                               FriendsListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 5)
                                //                               GamesListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 6)
                                //                               JobsListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                             if (groupsProvider
                                //                                     .homeMenuIndex ==
                                //                                 7)
                                //                               MarketPlaceListView(
                                //                                 pagecontroller:
                                //                                     _pageController,
                                //                               ),
                                //                           ],
                                //                         ),
                                //                       ),
                                //                       Positioned(
                                //                         top: -10,
                                //                         right: 0,
                                //                         child: IconButton(
                                //                           icon: const Icon(
                                //                               Icons.close),
                                //                           onPressed: () {
                                //                             Provider.of<GreetingsProvider>(
                                //                                     context,
                                //                                     listen:
                                //                                         false)
                                //                                 .closeHomeMenuTab();
                                //                           },
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   Divider(
                                //                       thickness: 8,
                                //                       color:
                                //                           Theme.of(context)
                                //                               .colorScheme
                                //                               .secondary),
                                //                 ],
                                //               )
                                //             : const SizedBox.shrink(),
                                //   ),
                                // ],
                              ],
                            ),
                          ),
                        ]),
                      ),
                      // Posts

                      Consumer<PostProvider>(
                        builder: (context, value, child) {
                          final bool isEmpty = value.postListProvider.isEmpty;
                          final bool dataCheckFalse = value.datacheck == false;
                          final bool dataCheckTrue = value.datacheck == true;
                          final bool isAdEnabled =
                              getStringAsync('isAdEnabled') == '1';
                          int adAfterPost =
                              int.parse(getStringAsync('adAfterPost'));

                          if (isEmpty && dataCheckFalse) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    const PostSkeleton(),
                                childCount: 5
                              )
                            );
                          } else if (isEmpty && dataCheckTrue) {
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) => SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      loading(),
                                      Center(
                                        child: Text(
                                          translate(context, 'no_post_yet')
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Center(
                                        child: Text(
                                          translate(context,
                                                  'be_the_first_to_post')
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                childCount: 1,
                              ),
                            );
                          } else {
                            return SliverList(
                              
                              delegate: SliverChildBuilderDelegate(

                                (BuildContext context, int index) {
                                  final adjustedIndex =
                                      index - (index ~/ (adAfterPost + 1));
                                  if (isAdEnabled &&
                                      index > 0 &&
                                      index % (adAfterPost + 1) == 0) {
                                    return Column(
                                      children: [
                                        BannerAdWidget(
                                            adSize: AdSize.largeBanner,
                                            adIdr: getStringAsync('adId')),
                                        Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            height: 8),
                                      ],
                                    );
                                  } else {
                                    return PostTile(
                                      posts:
                                          value.postListProvider[adjustedIndex],
                                      index: adjustedIndex,
                                      isMainPosts: true,
                                    );
                                  }
                                },
                                childCount: isAdEnabled
                                    ? value.postListProvider.length +
                                        (value.postListProvider.length ~/
                                            (adAfterPost + 1))
                                    : value.postListProvider.length,
                              ),
                            );
                          }
                        },
                      ),

                      // Post skeleton
                      Consumer<PostProvider>(builder: (context, value, child) {
                        return SliverList(
                          delegate: SliverChildListDelegate([
                            if (value.hitApi == true &&
                                value.postListProvider.isNotEmpty) ...[
                              value.checkBottom == true
                                  ? const PostSkeleton()
                                  : const SizedBox.shrink(),
                            ],
                          ]),
                        );
                      }),
                    ],
                  ),
      ),
    );
  }
}

class GroupsListView extends StatelessWidget {
  final PageController pagecontroller;
  const GroupsListView({super.key, required this.pagecontroller});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.loader == true && value.discoverGroups.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.loader == false && value.discoverGroups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              translate(context, 'no_data_found')!,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.discoverGroups.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(DetailsGroup(
                                  index: index,
                                  joinGroupModel: value.discoverGroups[index],
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        value.discoverGroups[index].avatar!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      value.discoverGroups[index].groupName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class PagesListView extends StatelessWidget {
  const PagesListView({super.key, required this.pagecontroller});

  final PageController pagecontroller;

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdatePageDataProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.isLoading == true && value.discoverPages.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.isLoading == false && value.discoverPages.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.discoverPages.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(DetailsPage(
                                  pageid: value.discoverPages[index].id,
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        value.discoverPages[index].avatar!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      value.discoverPages[index].pageTitle!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class EventsListView extends StatelessWidget {
  const EventsListView({required this.pagecontroller});

  final PageController pagecontroller;

  @override
  Widget build(BuildContext context) {
    return Consumer<GetEventApiProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.loading == true && value.allevents.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.loading == false && value.allevents.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.allevents.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(EventDetails(
                                  eventData: value.allevents[index],
                                  isHomePost: true,
                                  index: index,
                                  isProfilePost: false,
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        value.allevents[index].cover!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      value.allevents[index].name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class SpacesListView extends StatelessWidget {
  const SpacesListView({required this.pagecontroller});

  final PageController pagecontroller;

  @override
  Widget build(BuildContext context) {
    return Consumer<SpaceProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.loading == true && value.spacesList.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.loading == false && value.spacesList.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.spacesList.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(SpacesHome()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        value.spacesList[index].member.avatar!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      value.spacesList[index].title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class FriendsListView extends StatelessWidget {
  const FriendsListView({required this.pagecontroller});
  final PageController pagecontroller;
  @override
  Widget build(BuildContext context) {
    return Consumer<FriendFriendSuggestProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.isLoading == true && value.suggestionfriend.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.isLoading == false && value.suggestionfriend.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.suggestionfriend.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(ProfileTab(
                                  userId: value.suggestionfriend[index].id,
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        value.suggestionfriend[index].avatar!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      "${value.suggestionfriend[index].firstName!} ${value.suggestionfriend[index].lastName!}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class GamesListView extends StatelessWidget {
  const GamesListView({required this.pagecontroller});
  final PageController pagecontroller;
  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.checkData == false && value.data.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.checkData == true && value.data.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.data.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(GameDetailScreen(
                                  gameData: value.data[index],
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(value.data[index].image!),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      "${value.data[index].name!}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class JobsListView extends StatelessWidget {
  const JobsListView({required this.pagecontroller});
  final PageController pagecontroller;
  @override
  Widget build(BuildContext context) {
    return Consumer<MyJobList>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.loading == true && value.alljoblist.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.loading == false && value.alljoblist.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.alljoblist.length,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(createRoute(JobDetail(
                                  index: index,
                                  jobdetails: value.alljoblist[index],
                                  // searchJobDetails: ,
                                )));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage:
                                        AssetImage("assets/images/jobs.png"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      "${value.alljoblist[index].jobTitle!}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}

class MarketPlaceListView extends StatelessWidget {
  const MarketPlaceListView({required this.pagecontroller});
  final PageController pagecontroller;
  @override
  Widget build(BuildContext context) {
    return Consumer<GetProductProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Slide to the next page
                pagecontroller.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      translate(context, 'back')!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            value.laoding == true && value.productList.isEmpty
                ? SizedBox(
                    height: 130,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) => const GroupsShimmer()),
                  )
                : value.laoding == false && value.productList.isEmpty
                    ? Center(
                        child: Text(
                          translate(context, 'no_data_found')!,
                        ),
                      )
                    : SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.productList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  ProducDetail(
                                    index: index,
                                    isHomePost: true,
                                    isProfilePost: false,
                                    productModel: value.productList[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(value
                                        .productList[index].images[0]
                                        .toString()),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.2,
                                    child: Text(
                                      "${value.productList[index].productName!}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        );
      },
    );
  }
}
