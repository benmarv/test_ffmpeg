import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/screens/events/widgets/event_card.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class InterestedEvents extends StatefulWidget {
  const InterestedEvents({super.key});

  @override
  State<InterestedEvents> createState() => _InterestedEventsState();
}

class _InterestedEventsState extends State<InterestedEvents> {
  late ScrollController _scrollController;

  void updateInterestedEvents() {
    print('Update Interest');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "interested";
    provider.setEventName = "interested";

    _scrollController = ScrollController();
    _loadData();
    _scrollController.addListener(() {
      var postId = provider.interestedevents.length;

      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        _loadMoreData(postId);
      }
    });
  }

  Future<void> _loadData() async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    pro.interestedevents.clear();
    if (pro.interestedevents.isEmpty) {
      await pro.eventHandler("interested");
      setState(() {});
    }
  }

  Future<void> _loadMoreData(int postId) async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    await pro.eventHandler(
      "interested",
      afterPostId: postId.toString(),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    context.read<GetEventApiProvider>().interestedevents.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "interested";
    provider.setEventName = "interested";
    return Consumer<GetEventApiProvider>(builder: (context, value, index) {
      value.setEventName = 'interested';
      return (value.loading == true && value.interestedevents.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (value.loading == false && value.interestedevents.isEmpty)
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
                      itemCount: value.interestedevents.length,
                      itemBuilder: (context, index) {
                        return CustomEventCard(
                          eventModel: value.interestedevents[index],
                          index: index,
                          screenName: 'interested',
                          onUpdate: updateInterestedEvents,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (value.loading == true &&
                        value.interestedevents.isNotEmpty) ...[
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    ]
                  ],
                );
    });
  }
}
