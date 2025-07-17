import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/text_constants.dart';
import 'package:link_on/controllers/common_things_provider/common_things_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/screens/events/event_details.dart';
import 'package:link_on/screens/groups/group_details.dart';
import 'package:link_on/screens/pages/detail_page.dart';
import 'package:provider/provider.dart';

import '../../consts/colors.dart';
import '../../models/CommonThingsModel/common_things_model.dart';

class CommonThingFrinedView extends StatefulWidget {
  final User? user;

  CommonThingFrinedView({
    super.key,
    this.user,
  });

  @override
  State<CommonThingFrinedView> createState() => _CommonThingFrinedViewState();
}

class _CommonThingFrinedViewState extends State<CommonThingFrinedView> {
  late CommonThingsProvider provider;
  List<dynamic> filteredGroupList = [];
  List<dynamic> filteredPagesList = [];
  List<dynamic> filteredEventsList = [];

  @override
  void initState() {
    provider = Provider.of<CommonThingsProvider>(context, listen: false);
    provider.fetchCommonThings(widget.user!.id);
    super.initState();
  }

  void getFilteredList(commonthing) {
    filteredGroupList =
        commonthing!.groups.where((group) => group != null).toList();
    filteredPagesList =
        commonthing!.pages.where((page) => page != null).toList();
    filteredEventsList =
        commonthing!.events.where((event) => event != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(image: widget.user!.cover),
                  ),
                );
              },
              child: Container(
                height: 150,
                width: size.width,
                child: CachedNetworkImage(
                  imageUrl: widget.user!.cover.toString(),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Text(
                      widget.user!.firstName.toString(),
                      style: TextStyle(fontSize: 22),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail),
                        SizedBox(width: 5),
                        Text(widget.user!.email.toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.male),
                            Text(widget.user!.gender.toString())
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromARGB(190, 212, 212, 212),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Consumer<CommonThingsProvider>(
                              builder: (context, provider, child) {
                            final commonthing = provider.commonThingsModel;
                            getFilteredList(commonthing);

                            if (provider.isCommonThingDataLoading == true) {
                              return Center(child: CircularProgressIndicator());
                            } else
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          translate(context, "thing_in_common")
                                              .toString(),
                                          style: text4b),
                                    ],
                                  ),
                                  if (filteredPagesList.isNotEmpty)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              translate(context, "pages")
                                                  .toString(),
                                              style: text3b),
                                        ),
                                        Container(
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filteredPagesList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailsPage(
                                                          pageid:
                                                              filteredPagesList[
                                                                  index]['id'],
                                                        ),
                                                      ));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: AppColors
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        filteredPagesList[index]
                                                            ['page_title'],
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .033),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 5),
                                  if (filteredGroupList.isNotEmpty)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              translate(context, "groups")
                                                  .toString(),
                                              style: text3b),
                                        ),
                                        Container(
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filteredGroupList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  DetailsGroup(
                                                                    joinGroupModel:
                                                                        JoinGroupModel.fromJson(
                                                                            filteredGroupList[index]),
                                                                    index:
                                                                        index,
                                                                  )));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: AppColors
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        filteredGroupList[index]
                                                            ['group_title'],
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .033),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 5),
                                  if (filteredEventsList.isNotEmpty)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              translate(context, "events")
                                                  .toString(),
                                              style: text3b),
                                        ),
                                        Container(
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                filteredEventsList.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => EventDetails(
                                                            eventData: EventModel
                                                                .fromJson(
                                                                    filteredEventsList[
                                                                        index]),
                                                            index: index,
                                                            screenName: translate(
                                                                    context,
                                                                    "events")
                                                                .toString()),
                                                      ));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: AppColors
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        filteredEventsList[
                                                            index]['name'],
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .033),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                          }),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(25.0),
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.black.withOpacity(.2),
                  child: Icon(Icons.arrow_back),
                )),
          ],
        ),
        Positioned(
          top: 75, // Adjust to overlap the pink container (half-circle)
          left: (size.width - 150) / 2, // Center the circle horizontally
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(image: widget.user!.avatar),
                ),
              );
            },
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.white),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.user!.avatar.toString(),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ), // This will show while the image is loading
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
                  ), // This will show if the image fails to load
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
