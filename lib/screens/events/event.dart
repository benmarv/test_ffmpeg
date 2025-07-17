import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/screens/events/create_event.dart';
import 'package:link_on/screens/events/events.dart';
import 'package:link_on/screens/events/going_events.dart';
import 'package:link_on/screens/events/interested.dart';
import 'package:link_on/screens/events/my_events.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
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
        length: 4,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEvent(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 100,
                  child: Image(
                    image: NetworkImage(
                      getStringAsync("appLogo"),
                    ),
                  ),
                ),
                // Text(
                //   translate(context, 'events').toString(),
                //   style: const TextStyle(
                //     fontStyle: FontStyle.italic,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
            elevation: 1,
            bottom: TabBar(
              labelColor: AppColors.primaryColor,
              tabAlignment: TabAlignment.center,
              isScrollable: true,
              dividerHeight: 0,
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: translate(context, 'events').toString()),
                Tab(text: translate(context, 'my_events').toString()),
                Tab(text: translate(context, 'going').toString()),
                Tab(text: translate(context, 'interested').toString()),
              ],
            ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                Events(),
                MyEvents(),
                GoingEvents(),
                InterestedEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
