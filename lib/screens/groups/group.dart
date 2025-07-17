import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/groups/discover.dart';
import 'package:link_on/screens/groups/for_you.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'widgets/create_group.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TabsPage(),
          ),
        );
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.primaryColor,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateGroup()));
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primaryColor,
                  )),
            ],
            automaticallyImplyLeading: false,
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
                //   translate(context, 'groups').toString(),
                //   style: const TextStyle(
                //       fontStyle: FontStyle.italic,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400),
                // ),
              ],
            ),
            elevation: 1,
            bottom: TabBar(
              controller: tabController,
              isScrollable: false,
              labelColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              dividerHeight: 0.1,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              tabs: [
                Tab(text: translate(context, 'discover').toString()),
                Tab(text: translate(context, 'my_groups').toString()),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Discover(),
              ForYouGroup(),
            ],
          ),
        ),
      ),
    );
  }
}
