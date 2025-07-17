import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'widgets/event_card.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);
    provider.currentEventName = "myevents";
    provider.setEventName = "myevents";

    _scrollController = ScrollController();
    _loadData();
    _scrollController.addListener(() {
      var postId = provider.myEventsListProvider.length;

      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        _loadMoreData(postId);
      }
    });
  }

  Future<void> _loadData() async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    pro.myEventsListProvider.clear();
    if (pro.myEventsListProvider.isEmpty) {
      await pro.eventHandler("myevents");
      setState(() {});
    }
  }

  Future<void> _loadMoreData(int postId) async {
    var pro = Provider.of<GetEventApiProvider>(context, listen: false);

    await pro.eventHandler(
      "myevents",
      afterPostId: postId.toString(),
    );
    setState(() {});
  }

  @override
  void dispose() {
    log('Disposing');
    _scrollController.dispose();
    context.read<GetEventApiProvider>().myEventsListProvider.clear();
    super.dispose();
  }

  void updateMyEvents() {
    print('Update myEvents');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetEventApiProvider>(context, listen: false);
    provider.currentEventName = "myevents";
    provider.setEventName = "myevents";
    return Consumer<GetEventApiProvider>(
      builder: (context, value, index) {
        value.setEventName = 'myevents';
        return (value.loading == true && value.myEventsListProvider.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (value.loading == false && value.myEventsListProvider.isEmpty)
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
                        itemCount: value.myEventsListProvider.length,
                        itemBuilder: (context, index) {
                          return CustomEventCard(
                            eventModel: value.myEventsListProvider[index],
                            index: index,
                            onUpdate: updateMyEvents,
                            screenName: 'myevents',
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (value.loading == true &&
                          value.myEventsListProvider.isNotEmpty) ...[
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      ]
                    ],
                  );
      },
    );
  }
}
