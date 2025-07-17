// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/screens/events/event_details.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class EventSearch extends StatefulWidget {
  TextEditingController searchController = TextEditingController();

  EventSearch({super.key, required this.searchController});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (widget.searchController.text.isEmpty) {
      searchProvider.search(query: '', type: 'event');
    } else {
      searchProvider.search(query: widget.searchController.text, type: 'event');
    }
    setState(() {
      searchProvider.currentIndex = 4;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, value, child) {
        return value.data == false
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : value.eventMessage ==
                        translate(context, 'enter_something_to_search') ||
                    value.eventMessage == translate(context, 'event_not_found')
                ? Center(
                    child: Text(
                      value.eventMessage.toString(),
                    ),
                  )
                : value.events.isNotEmpty && value.data == true
                    ? ListView.separated(
                        itemCount: value.events.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EventSearchTile(
                            event: value.events[index],
                            index: index,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.secondary,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          translate(context, 'event_not_found').toString(),
                        ),
                      );
      },
    );
  }
}

class EventSearchTile extends StatefulWidget {
  final EventModel? event;

  final int? index;

  const EventSearchTile({Key? key, this.event, this.index}) : super(key: key);

  @override
  _EventSearchTileState createState() => _EventSearchTileState();
}

class _EventSearchTileState extends State<EventSearchTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: ((context, value, child) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(
                  eventData: widget.event,
                  index: widget.index,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 3,
          ),
          leading: CircularImage(
            image: widget.event!.cover.toString(),
          ),
          title: Text(
            widget.event?.name ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    translate(context, 'date_label').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('dd-MM-yyyy').format(DateTime.tryParse(
                        Utils.formatTimestamp(widget.event!.startDate!))!),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    translate(context, 'time_label').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.event!.startTime!),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primaryColor,
          ),
        );
      }),
    );
  }
}
