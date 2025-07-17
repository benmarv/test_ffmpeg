// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/tabs/explore/explore_Screen.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/more/more.dart';
import 'package:link_on/screens/tabs/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

CancelToken cancelToken = CancelToken();

class TabsPage extends StatefulWidget {
  final int? index;
  const TabsPage({super.key, this.index});
  @override
  TabsPageState createState() => TabsPageState();
}

class TabsPageState extends State<TabsPage> {
  late final PostProvider postProvider;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    postProvider = context.read<PostProvider>();
    scrollController = postProvider.scrollController;
    fun();
    getUserDetail();
  }

  void onTabTapped(int index) {
    final provider = Provider.of<GreetingsProvider>(context, listen: false);
    if (index == 0 && provider.currentIndex == 0) {
      // postProvider.resfreshPosts(context: context);
      scrollController.jumpToTop();
    }
    provider.setCurrentTabIndex(index: index);
  }

  bool isSessionExpired = false;

  Future<void> getUserDetail() async {
    await apiClient
        .get_user_data(
      userId: getStringAsync('user_id'),
    )
        .then((value) {
      if (value['messages'] == 'Access denied: Missing or invalid Session') {
        setState(() {
          isSessionExpired = true;
        });
      } else {
        setValue('userData', value['data']);
        getUserData.value = Usr.fromJson(
          jsonDecode(
            getStringAsync('userData'),
          ),
        );
      }
    });
  }

  fun() {
    if (widget.index != null) {
      final provider = Provider.of<GreetingsProvider>(context, listen: false);

      provider.setCurrentTabIndex(index: widget.index!);
    }
  }

  logOutCurrentSession() async {
    await removeKey("access_token");
    await removeKey("userData");
    await removeKey('access_token');

    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login, (Route<dynamic> route) => false);
  }

  // Future<bool> _showExitDialog(BuildContext context) async {
  //   return showDialog<bool>(
  //     context: context,
  //     builder: (context) => CupertinoAlertDialog(
  //       content: const Text(
  //         'Do you want to exit the app?',
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () =>
  //               Navigator.of(context).pop(false), // Stay in the app
  //           child: const Text('No'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(true), // Exit the app
  //           child: const Text(
  //             'Yes',
  //             style: TextStyle(
  //               color: Colors.red,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ).then((value) => value ?? false); // Return false if dialog is dismissed
  // }

  @override
  void dispose() {
    Provider.of<PostProvider>(context, listen: false)
        .scrollController
        .dispose();
    super.dispose();
  }

  bool popval = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomeTab(),
      const ExploreScreen(),
      CreatePostPage(),
      const More(),
    ];

    return Consumer<GreetingsProvider>(
      builder: (context, provider, child) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool backPressed, dynamic result) async {
          if (provider.currentIndex == 0) {
            if ((context
                    .read<PostProvider>()
                    .scrollController
                    .position
                    .pixels >=
                MediaQuery.sizeOf(context).height)) {
              context.read<PostProvider>().scrollController.jumpToTop();
              return; // No return value needed
            }

            final shouldExit = await showDialog<bool>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                    translate(context, 'exit_app_title').toString(),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () {
                        setState(() {
                          popval = true;
                        });
                        Navigator.of(context).pop(true); // Exit the app
                      },
                      child: Text(
                        translate(context, 'yes').toString(),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        setState(() {
                          popval = false;
                        });
                        Navigator.of(context).pop(false); // Stay in the app
                      },
                      child: Text(
                        translate(context, 'no').toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            if (shouldExit == true) {
              SystemNavigator.pop(); // Close the app or navigate back
            }
          } else {
            onTabTapped(0); // Navigate to the first tab
          }
        },
        child: isSessionExpired
            ? Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      logOutCurrentSession();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: SizedBox(
                    height: 20,
                    width: 100,
                    child: Image(
                        image: NetworkImage(
                      getStringAsync("appLogo"),
                    )),
                  ),
                  centerTitle: true,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/session-expired.svg',
                        height: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate(context, 'session_expired')!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          logOutCurrentSession();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            translate(context, 'login_again')!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                body: pages[provider.currentIndex],
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(.1),
                      )
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: GNav(
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 5,
                        activeColor: Colors.white,
                        iconSize: 22,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        duration: const Duration(milliseconds: 400),
                        tabBackgroundColor: Colors.grey[100]!,
                        color: Theme.of(context).colorScheme.onSurface,
                        tabs: [
                          GButton(
                            style: GnavStyle.google,
                            icon: Icons.home_outlined,
                            text: translate(context, 'home')
                                .toString(), // Translation for "Home"
                            backgroundColor: AppColors.primaryColor,
                          ),
                          GButton(
                            style: GnavStyle.google,
                            icon: Icons.ondemand_video_rounded,
                            text: translate(context, 'videos')
                                .toString(), // Translation for "Videos"

                            backgroundColor: AppColors.primaryColor,
                          ),
                          GButton(
                            style: GnavStyle.google,
                            icon: Icons.add_rounded,
                            text: translate(context, 'create')
                                .toString(), // Translation for "Create"
                            backgroundColor: AppColors.primaryColor,
                          ),
                          GButton(
                            style: GnavStyle.google,
                            icon: Icons.menu_rounded,
                            text: translate(context, 'more')
                                .toString(), // Translation for "More"
                            backgroundColor: AppColors.primaryColor,
                          ),
                        ],
                        selectedIndex: provider.currentIndex,
                        onTabChange: (index) {
                          if (index == 0 && provider.currentIndex == 0) {
                            // If the user is already on the home page, scroll to the top and refresh posts
                            if (context.read<PostProvider>().hitApi == false) {
                              // context
                              //     .read<PostProvider>()
                              //     .resfreshPosts(context: context);
                              context
                                  .read<PostProvider>()
                                  .scrollController
                                  .jumpToTop();
                            }
                          } else {
                            // Otherwise, just update the current index
                            provider.setCurrentTabIndex(index: index);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
