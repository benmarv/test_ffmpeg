import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/screens/events/update_event.dart';

class EventDetails extends StatefulWidget {
  final EventModel? eventData;
  final int? index;
  final bool? isHomePost;
  final String? screenName;
  final bool? isProfilePost;
  const EventDetails(
      {super.key,
      this.eventData,
      this.index,
      this.isHomePost,
      this.screenName,
      this.isProfilePost});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  cusotmDialouge(contex, {eventId, eventIndex}) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(translate(context, 'delete_event')!),
        content: Text(translate(context, 'confirm_delete_event')!),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              context.read<GetEventApiProvider>().deleteEvents(
                  screenName: widget.isHomePost == true
                      ? "home"
                      : widget.isProfilePost == true
                          ? "profile"
                          : widget.screenName,
                  eventId: eventId,
                  eventIndex: eventIndex,
                  context: context,
                  isEventDetailScreen: true);
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: Text(
              translate(context, 'delete')!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(translate(context, 'go_back')!),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          image: widget.eventData!.cover,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.35,
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors
                        .black, // Default background in case of image failure
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        /// **Cached Event Cover Image**
                        CachedNetworkImage(
                          imageUrl: widget.eventData!.cover ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300], // Placeholder color
                            child: const Center(
                                child: CircularProgressIndicator()), // Loader
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.black,
                              ),
                            ), // Error icon
                          ),
                        ),

                        /// **Gradient Overlay**
                        Container(
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                          margin: const EdgeInsets.only(top: 20, left: 20),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white60),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: Colors.black,
                          )),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () =>
                          Share.share(widget.eventData!.url.toString()),
                      child: Container(
                          margin: const EdgeInsets.only(top: 20, right: 20),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white60),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.share,
                            size: 16,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10, bottom: 50),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: radiusCircular(20),
                  topRight: radiusCircular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Utils.formatTimestamp(
                                widget.eventData!.startDate!,
                              ) +
                              " - " +
                              Utils.formatTimestamp(
                                widget.eventData!.endDate!,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .9,
                      child: Text(
                        "${widget.eventData!.name} ",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.profile,
                            arguments: widget.eventData!.userdata!.id);
                      },
                      child: Text(
                        "Event by ${widget.eventData!.userdata!.firstName} ${widget.eventData!.userdata!.lastName}",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    widget.eventData!.userId == getStringAsync("user_id")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cusotmDialouge(
                                    context,
                                    eventId: widget.eventData!.id!,
                                    eventIndex: widget.index,
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width / 2.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.red,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_note,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        translate(context, 'delete')!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateEvent(
                                          eventData: widget.eventData!,
                                          index: widget.index,
                                          isHomePost: widget.isHomePost,
                                          isProfilePost: widget.isProfilePost,
                                          screenName: widget.screenName,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.sizeOf(context).width / 2.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: AppColors.primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_note,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        translate(context, 'edit_event')!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  context
                                      .read<GetEventApiProvider>()
                                      .interestedEvent(context,
                                          widget.eventData!.id, widget.index,
                                          screenName: widget.isHomePost == true
                                              ? 'home'
                                              : widget.isProfilePost == true
                                                  ? "profile"
                                                  : widget.screenName,
                                          isEventDetail: true);
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.sizeOf(context).width * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        widget.eventData!.isInterested == true
                                            ? const Color.fromARGB(
                                                255, 204, 203, 203)
                                            : AppColors.primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.eventData!.isInterested == true
                                          ? const Icon(Icons.star_border,
                                              color: Colors.white)
                                          : const Icon(Icons.star,
                                              color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.eventData?.isInterested == true
                                            ? translate(
                                                context, 'not_interested')!
                                            : translate(context, 'interested')!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: widget.eventData!
                                                        .isInterested ==
                                                    true
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context
                                      .read<GetEventApiProvider>()
                                      .goingevent(context,
                                          id: widget.eventData!.id,
                                          index: widget.index,
                                          screenName: widget.isHomePost == true
                                              ? 'home'
                                              : widget.isProfilePost == true
                                                  ? "profile"
                                                  : widget.screenName,
                                          isEventDetail: true);
                                },
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.sizeOf(context).width * .45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: widget.eventData!.isGoing == true
                                        ? const Color.fromARGB(
                                            255, 204, 203, 203)
                                        : AppColors.primaryColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.eventData!.isGoing == true
                                          ? const Icon(
                                              Icons.event_available,
                                              color: Colors.black,
                                            )
                                          : Icon(Icons.event_available_outlined,
                                              color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        widget.eventData?.isGoing == true
                                            ? translate(context, 'not_going')!
                                            : translate(context, 'going')!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: widget.eventData?.isGoing ==
                                                    true
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Your Location"),
                              content: Container(
                                height: 300,
                                width: 300,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(24.8607,
                                        67.0011), // Example: Karachi, Pakistan
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId("current_location"),
                                      position: LatLng(24.8607, 67.0011),
                                    ),
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 10,
                        leading: const Icon(
                          Icons.location_pin,
                          color: Color.fromARGB(255, 79, 77, 77),
                        ),
                        title: Text(
                          widget.eventData!.location!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    if (widget.eventData!.userdata!.id !=
                        getStringAsync('user_id'))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 10,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgoraMessaging(
                                userAvatar: widget.eventData!.userdata!.avatar,
                                userFirstName:
                                    widget.eventData!.userdata!.firstName,
                                userId: widget.eventData!.userdata!.id,
                                userLastName:
                                    widget.eventData!.userdata!.lastName,
                              ),
                            )),
                        leading: const Icon(
                          LineIcons.facebook_messenger,
                          color: Color.fromARGB(255, 79, 77, 77),
                        ),
                        title: Text(
                          translate(context, 'chat')!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          translate(context, 'description')!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ReadMoreText(
                      '''${widget.eventData!.description}''',
                      trimLines: 1,
                      trimLength: 510,
                      style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      colorClickableText: AppColors.primaryColor,
                      trimCollapsedText: translate(context, 'read_more')!,
                      trimExpandedText: translate(context, 'show_less')!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
