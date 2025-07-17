import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'widgets/event_card.dart';

class GoingEvents extends StatefulWidget {
  const GoingEvents({super.key});

  @override
  State<GoingEvents> createState() => _GoingEventsState();
}

class _GoingEventsState extends State<GoingEvents> {
  late ScrollController _scrollController;

  void updateGoingEvents() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "going";
    provider.setEventName = "going";
    _scrollController = ScrollController();
    _loadData();
    _scrollController.addListener(() {
      var postId = provider.goingevents.length;

      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        _loadMoreData(postId);
      }
    });
  }

  Future<void> _loadData() async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    pro.goingevents.clear();
    if (pro.goingevents.isEmpty) {
      await pro.eventHandler("going");
      setState(() {});
    }
  }

  Future<void> _loadMoreData(int postId) async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    await pro.eventHandler(
      "going",
      afterPostId: postId.toString(),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    context.read<GetEventApiProvider>().goingevents.clear();
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);
    provider.currentEventName = "";
    provider.setEventName = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);

    provider.currentEventName = "going";
    provider.setEventName = "going";

    return Consumer<GetEventApiProvider>(builder: (context, value, index) {
      value.setEventName = 'going';
      return (value.loading == true && value.goingevents.isEmpty)
          ? const Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (value.loading == false && value.goingevents.isEmpty)
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
                      itemCount: value.goingevents.length,
                      itemBuilder: (context, index) {
                        for (int i = 0; i < value.goingevents.length; i++) {
                          log('final list is ${value.goingevents[i].name}');
                        }
                        log("final List length is ${value.goingevents.length}");

                        return CustomEventCard(
                          eventModel: value.goingevents[index],
                          index: index,
                          screenName: 'going',
                          onUpdate: updateGoingEvents,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (value.loading == true &&
                        value.goingevents.isNotEmpty) ...[
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
