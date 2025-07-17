import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/pages/like_pages.dart';
import 'package:link_on/screens/pages/my_pages.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'create_page.dart';
import 'discover_page.dart';

class ExplorePages extends StatefulWidget {
  const ExplorePages({super.key});

  @override
  State<ExplorePages> createState() => _ExplorePagesState();
}

class _ExplorePagesState extends State<ExplorePages> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TabsPage()),
        );
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePage(),
                      ),
                    );
                  },
                  child: Text(
                    translate(context, 'create').toString(),
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                )),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              dividerHeight: 0,
              padding: EdgeInsets.zero,
              labelColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColors.primaryColor,
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
              tabs: [
                Tab(
                    child: Text(
                  translate(context, 'discover').toString(),
                )),
                Tab(
                  child: Text(
                    translate(context, 'liked_pages').toString(),
                  ),
                ),
                Tab(
                    child: Text(
                  translate(context, 'your_pages').toString(),
                )),
              ],
            ),
            title: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 100,
                  child: Image(
                      image: NetworkImage(
                    getStringAsync("appLogo"),
                  )),
                ),
                // Text(
                //   translate(context, 'pages').toString(),
                //   style: const TextStyle(
                //       fontStyle: FontStyle.italic,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400),
                // ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DiscoverPage(),
              LikePages(),
              MyPages(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loading() {
  return Center(
    child: Lottie.asset("assets/anim/nodata.json",
        repeat: true, reverse: true, width: 130, height: 100),
  );
}
