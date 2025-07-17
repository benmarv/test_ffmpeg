import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/screens/events/event_details.dart';

class CustomEventCard extends StatefulWidget {
  const CustomEventCard(
      {super.key,
      required this.index,
      this.screenName,
      this.onUpdate,
      required this.eventModel});
  final int? index;
  final String? screenName;
  final EventModel? eventModel;
  final VoidCallback? onUpdate;

  @override
  State<CustomEventCard> createState() => _CustomEventCardState();
}

class _CustomEventCardState extends State<CustomEventCard> {
  @override
  Widget build(BuildContext context) {
    // List<String> monthNames = [
    //   translate(context, 'jan')!,
    //   translate(context, 'feb')!,
    //   translate(context, 'mar')!,
    //   translate(context, 'apr')!,
    //   translate(context, 'may')!,
    //   translate(context, 'jun')!,
    //   translate(context, 'jul')!,
    //   translate(context, 'aug')!,
    //   translate(context, 'sep')!,
    //   translate(context, 'oct')!,
    //   translate(context, 'nov')!,
    //   translate(context, 'dec')!,
    // ];

    return InkWell(
      onTap: () {
        if (widget.eventModel != null && widget.index != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetails(
                  eventData: widget.eventModel,
                  index: widget.index,
                  screenName: widget.screenName),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translate(context, 'event_model_null')!),
            ),
          );
        }
      },
      child: Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: MediaQuery.sizeOf(context).width,
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:
              Colors.grey.shade300, // Background color in case of image failure
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// **Cached Event Cover Image**
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.eventModel?.cover ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300], // Placeholder color
                  child: const Center(
                      child: CircularProgressIndicator()), // Loader
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                      child:
                          Icon(Icons.error, color: Colors.red)), // Error icon
                ),
              ),
            ),

            /// **Event Details**
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// **Event Name**
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Text(
                      widget.eventModel?.name ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// **Date & Location**
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LineIcons.calendar,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 5),
                            Text(
                              Utils.formatTimestamp(
                                  widget.eventModel!.startDate!,
                                  isWithTime: true),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LineIcons.map_marker,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 5),
                            SizedBox(
                              // width: MediaQuery.sizeOf(context).height * 0.2,
                              child: Text(
                                widget.eventModel?.location ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  /// **User Info & Share Button**
                  Row(
                    children: [
                      /// **Cached User Avatar**
                      CachedNetworkImage(
                        imageUrl: widget.eventModel?.userdata?.avatar ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.contain),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[300]),
                          child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey[300]),
                          child: const Center(
                              child: Icon(Icons.error, color: Colors.red)),
                        ),
                      ),

                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: Text(
                          "${widget.eventModel?.userdata?.firstName ?? ''} ${widget.eventModel?.userdata?.lastName ?? ''}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Spacer(),

                      /// **Share Button**
                      InkWell(
                        onTap: () => Share.share(widget.eventModel?.url ?? ''),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.share,
                              size: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
