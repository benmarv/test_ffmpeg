import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'widgets/event_card.dart';

class Events extends StatefulWidget {
  const Events({super.key});
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "events";
    provider.setEventName = "events";

    _loadData();
    _scrollController.addListener(() {
      var postId = provider.allevents.length;
      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        _loadMoreData(postId);
      }
    });
  }

  Future<void> _loadData() async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);
    pro.getEventData.clear();
    if (pro.getEventData.isEmpty) {
      await pro.eventHandler("events");
      setState(() {});
    }
  }

  Future<void> _loadMoreData(int postId) async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);
    await pro.eventHandler(
      "events",
      afterPostId: postId.toString(),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "events";
    provider.setEventName = "events";
    return Consumer<GetEventApiProvider>(builder: (context, value, index) {
      value.setEventName = "events";
      return (value.loading == true && value.allevents.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (value.loading == false && value.allevents.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(translate(context, 'no_events_found').toString()),
                  ],
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: value.allevents.length,
                      itemBuilder: (context, index) {
                        return CustomEventCard(
                          eventModel: value.allevents[index],
                          index: index,
                          screenName: 'events',
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (value.loading == true &&
                        value.allevents.isNotEmpty) ...[
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ],
                );
    });
  }
}
