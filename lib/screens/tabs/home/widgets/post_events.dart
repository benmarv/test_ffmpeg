import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_cache_netword_imge.dart';

import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/screens/events/event_details.dart';
import 'package:link_on/utils/utils.dart';

class PostEvents extends StatelessWidget {
  final EventModel? eventModel;
  const PostEvents(
      {super.key,
      required this.eventModel,
      this.index,
      required this.isMainPost,
      this.isProfilePost});
  final bool? isProfilePost;

  final bool? isMainPost;
  final int? index;
  @override
  Widget build(BuildContext context) {
    // List<String> monthNames = [
    //   'jan',
    //   'feb',
    //   'mar',
    //   'apr',
    //   'may',
    //   'jun',
    //   'jul',
    //   'aug',
    //   'sep',
    //   'oct',
    //   'nov',
    //   'dec'
    // ];
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventDetails(
            isProfilePost: isProfilePost,
            isHomePost: isMainPost,
            index: index,
            eventData: eventModel!,
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomCachedNetworkImage(
                imageUrl: eventModel?.cover,
                height: 239,
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      PhysicalModel(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child:
                              // Text(
                              //   "${translate(context, monthNames[eventModel!.startDate!.month - 1])} ${eventModel!.startDate!.day},${eventModel!.startDate!.year}",
                              //   maxLines: 2,
                              //   style: const TextStyle(
                              //     fontWeight: FontWeight.w500,
                              //     color: Colors.white,
                              //     overflow: TextOverflow.ellipsis,
                              //   ),
                              // ),
                              Text(
                            Utils.formatTimestamp(eventModel!.startDate!),
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              "${eventModel?.name}",
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              "${eventModel?.location}",
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
