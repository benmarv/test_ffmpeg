// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/components/GoogleAd/banner_ad.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/tabs/explore/video_screen.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/connectivity_screen/nointernet.dart';
import 'package:link_on/components/connectivity_screen/timeout.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late PageController controller;
  late RandomVideoProvider randomVideoProvider;
  late int adAfterPost;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    final pro = Provider.of<PostProvider>(context, listen: false);
    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }
    controller = PageController();
    randomVideoProvider =
        Provider.of<RandomVideoProvider>(context, listen: false);
    adAfterPost = int.parse(getStringAsync('adAfterPost'));
    fun();
    super.initState();
  }

  List<Gifts> allGifts = [];
  Future<void> fun() async {
    if (randomVideoProvider.randomVideoListProvider.isEmpty) {
      await randomVideoProvider.gertRandomVideo(
          context: context, isHome: false);
    }
    if (getStringAsync("config").isEmpty) {
      await getSiteSettings();
    } else {
      final site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
      allGifts = site.gifts!;
    }
    setState(() {
      // Set loading to false after data is loaded
      _isLoading = false;
    });
  }

  Future<Map<String, dynamic>> getSiteSettings() async {
    var accessToken = getStringAsync("access_token");

    final response = await dioService.dio.get(
      'get_site_settings',
      options: Options(
        headers: {"Authorization": 'Bearer $accessToken'},
      ),
    );

    allGifts = List.from(response.data["data"]["gifts"])
        .map((e) => Gifts.fromJson(e))
        .toList();
    log("gifts first : ${allGifts.first.lottie_animation}");
    return response.data;
  }

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    Provider.of<InitializePostVideoProvider>(context, listen: false)
        .flickManager!
        .dispose();
    disposeController();
    super.dispose();
  }

  void disposeController() async {
    var provider = Provider.of<VideoPlayerProvider>(context, listen: false);
    provider.controller!.dispose();
    provider.disposeController();
  }

  Widget buildContent() {
    if (_isLoading) {
      // Show loading indicator if loading
      return const Center(child: CircularProgressIndicator());
    }
    if (randomVideoProvider.noInternet == true &&
        randomVideoProvider.randomVideoListProvider.isEmpty) {
      return NoInternet(
          onPress: () => randomVideoProvider.gertRandomVideo(
              context: context, isHome: false));
    } else if (randomVideoProvider.connectivityTimeout == true &&
        randomVideoProvider.randomVideoListProvider.isEmpty) {
      return Timeout(
          onPress: () => randomVideoProvider.gertRandomVideo(
              context: context, isHome: false));
    } else {
      return Consumer<RandomVideoProvider>(
        builder: (context, value, child) {
          if (value.randomVideoListProvider.length == 0)
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No Video Found",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          return PageView.builder(
            key: const PageStorageKey("video"),
            itemCount: getStringAsync('isAdEnabled') == '1'
                ? value.randomVideoListProvider.length +
                    (value.randomVideoListProvider.length ~/ (adAfterPost + 1))
                : value.randomVideoListProvider.length,
            physics: const BouncingScrollPhysics(),
            controller: controller,
            pageSnapping: true,
            onPageChanged: (pageValue) {
              var provider =
                  Provider.of<RandomVideoProvider>(context, listen: false);
              int length1 = value.randomVideoListProvider.length;
              int length2 = provider.randomVideoListProvider.length;
              var postId = provider.randomVideoListProvider.last.id;
              if (length1 == length2 && pageValue >= (length2 - 2)) {
                provider.gertRandomVideo(
                    afterPostIdVideo: postId, context: context, isHome: false);
              }
            },
            scrollDirection: Axis.vertical,
            itemBuilder: (context, itemIndex) {
              final adjustedIndex =
                  itemIndex - (itemIndex ~/ (adAfterPost + 1));
              int index = getStringAsync('isAdEnabled') == '1'
                  ? adjustedIndex
                  : itemIndex;
              if (itemIndex > 0 &&
                  itemIndex % (adAfterPost + 1) == 0 &&
                  getStringAsync('isAdEnabled') == '1') {
                return Container(
                  color: Colors.white,
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40.0),
                          BannerAdWidget(
                              adSize: AdSize.mediumRectangle,
                              adIdr: getStringAsync('adId')),
                          const Spacer(),
                          BannerAdWidget(
                              adSize: AdSize.mediumRectangle,
                              adIdr: getStringAsync('adId')),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return VideoScreen(
                    allGifts: allGifts,
                    posts: randomVideoProvider.randomVideoListProvider[index],
                    currentIndex: index);
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        randomVideoProvider.gertRandomVideo(
            onRefresh: true, context: context, isHome: false);
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          // appBar: AppBar(
          //   backgroundColor: Theme.of(context).brightness == Brightness.dark
          //       ? Color(0xff000000)
          //       : Color(0xffFFFFFF),
          //   title: Row(
          //     children: [
          //       SizedBox(
          //         height: 20,
          //         width: 100,
          //         child: Image(
          //             image: NetworkImage(
          //           getStringAsync("appLogo"),
          //         )),
          //       ),
          //     ],
          //   ),
          // ),
          key: const PageStorageKey("video"),
          body: SafeArea(
            child: buildContent(),
          ),
        ),
      ),
    );
  }
}
