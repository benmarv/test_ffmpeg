// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/screens/events/event.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:http_parser/http_parser.dart';

enum EventName {
  events,
  interested,
  going,
  myevents,
}

class GetEventApiProvider extends ChangeNotifier {
  bool loading = false;
  String currentEventName = '';
  List<EventModel> myEventsListProvider = [];
  List<EventModel> allevents = [];
  final List<EventModel> goingevents = [];
  final List<EventModel> interestedevents = [];

// Get the appropriate list of event data based on the current event name

  setEventsEmpty(String currentEventName) {
    switch (currentEventName) {
      case "myevents":
        {
          allevents = [];
          break;
        }
      case "events":
        {
          myEventsListProvider = [];
          break;
        }
    }
  }

  Future<void> eventHandler(
    String eventName, {
    String? afterPostId,
    bool isRefresh = false,
  }) async {
    // Indicates that data loading is in progress
    loading = true;

    // Prepare the data to be sent in the API request
    Map<String, dynamic> mapData = {"fetch": eventName, "limit": 5};

    // If an afterPostId is provided, set it in the request data
    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    } else {
      // If not, make the list empty
      makeListEmpty();
    }

    // Call the API to fetch event data
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "get-events");
    log("events : ${res["data"]}");
    // Check if the response is valid and contains data
    if (res["code"] == 200) {
      List<EventModel> tempList = [];

      // Convert the response data into a list of EventModel objects
      tempList = List.from(res['data']).map<EventModel>((event2) {
        EventModel eventModel2 = EventModel.fromJson(event2);
        return eventModel2;
      }).toList();

      // Add the fetched data to the appropriate event lists based on the event name
      switch (eventName) {
        case "myevents":
          myEventsListProvider.addAll(tempList);
          notifyListeners();
          break;
        case "interested":
          interestedevents.addAll(tempList);
          notifyListeners();
          break;
        case "going":
          goingevents.addAll(tempList);
          notifyListeners();
          break;
        case "events":
          allevents.addAll(tempList);
          notifyListeners();
          break;
        default:
          break;
      }
      // If the fetched data is empty, show a message based on the event name
      if (tempList.isEmpty) {
        switch (eventName) {
          case "myevents":
            if (myEventsListProvider.isNotEmpty) {
              toast("No more data to show");
            }
            break;
          case "events":
            if (allevents.isNotEmpty) {
              toast("No more data to show");
            }
            break;
          case "going":
            if (goingevents.isNotEmpty) {
              toast("No more data to show");
            }
            break;
          default:
            if (interestedevents.isNotEmpty) {
              toast("No more data to show");
            }
            break;
        }
      }

      // Data loading is complete
      loading = false;

      notifyListeners();
    } else {
      // Data loading failed, show an error message
      loading = false;

      notifyListeners();
    }
  }

  List<EventModel> get getEventData {
    switch (currentEventName) {
      case "myevents":
        return myEventsListProvider;
      case "interested":
        return interestedevents;
      case "going":
        return goingevents;
      default:
        return allevents;
    }
  }

  // Create an event using API
  Future createEventApi(
      {required BuildContext context,
      evetName,
      coverimage,
      eventLocation,
      eventDescription,
      eventStartDate,
      eventEndDate,
      eventStartTime,
      eventEndTime}) async {
    // Show a custom loading dialog while the event is being created
    customDialogueLoader(context: context);

    // Prepare the data to be sent in the API request
    Map<String, dynamic> mapData = {
      "name": evetName,
      "location": eventLocation,
      "description": eventDescription,
      "start_date": eventStartDate,
      "end_date": eventEndDate,
      "start_time": eventStartTime,
      "end_time": eventEndTime,
    };

    // If a cover image is provided, attach it to the request
    if (coverimage != null) {
      String? mimeType1 = mime(coverimage);
      String mimee1 = mimeType1!.split('/')[0];
      String type1 = mimeType1.split('/')[1];
      log(mimee1);
      log(type1);
      mapData['cover'] = await MultipartFile.fromFile(coverimage,
          contentType: MediaType(mimee1, type1));
    }

    // Call the API to create the event
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: "add-event");
    log("create event : ${res}");
    // Check if the response is valid and contains data
    if (res["code"] == 200) {
      // Convert the response data into an EventModel
      EventModel eventData = EventModel.fromJson(res["data"]);

      // Show a success message
      toast(res['message'].toString(), bgColor: Colors.green);

      // Add the created event to the list of user's events
      addMyEventInList(event: eventData);

      // Close the loading dialog
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
    notifyListeners();
  }

// Create an event using API
  Future updateEventApi(
      {required BuildContext context,
      required eventId,
      evetName,
      coverimage,
      eventLocation,
      eventDescription,
      eventStartDate,
      eventEndDate,
      eventStartTime,
      eventEndTime}) async {
    // Show a custom loading dialog while the event is being created
    customDialogueLoader(context: context);

    // Prepare the data to be sent in the API request
    Map<String, dynamic> mapData = {
      "event_id": eventId,
    };
    if (evetName != null) {
      mapData["name"] = evetName;
    }
    if (eventLocation != null) {
      mapData["location"] = eventLocation;
    }
    if (eventDescription != null) {
      mapData["description"] = eventDescription;
    }
    if (eventStartDate != null) {
      mapData["start_date"] = eventStartDate;
    }
    if (eventEndDate != null) {
      mapData["end_date"] = eventEndDate;
    }
    if (eventStartTime != null) {
      mapData["start_time"] = eventStartTime;
    }
    if (eventEndTime != null) {
      mapData["end_time"] = eventEndTime;
    }

    // If a cover image is provided, attach it to the request
    if (coverimage != null) {
      String? mimeType1 = mime(coverimage);
      String mimee1 = mimeType1!.split('/')[0];
      String type1 = mimeType1.split('/')[1];
      log(mimee1);
      log(type1);
      mapData['cover'] = await MultipartFile.fromFile(coverimage,
          contentType: MediaType(mimee1, type1));
    }

    // Call the API to create the event
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "update-event");

    // Check if the response is valid and contains data
    if (res["code"] == '200') {
      // Convert the response data into an EventModel
      EventModel eventData = EventModel.fromJson(res["data"]);

      // Show a success message
      toast(res['message'].toString(), bgColor: Colors.green);

      // Add the created event to the list of user's events
      addMyEventInList(event: eventData);

      // Close the loading dialog
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Event()),
      );
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
  }

// Mark an event as going using the API
  Future goingevent(BuildContext context,
      {id,
      int? index,
      bool? isPop,
      String? screenName,
      bool? isEventDetail}) async {
    // Show a custom loading dialog while processing the event status
    customDialogueLoader(context: context);
    // Prepare the data to be sent in the API request
    Map<String, dynamic> dataArray = {
      "event_id": id,
    };

    // Call the API to update the event status
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'go-to-event', apiData: dataArray);

    // Check if the API response indicates a successful operation
    if (res["code"] == '200') {
      // Show a toast message based on the going status
      toast("${res["message"]}");

      if (isEventDetail!) {
        Navigator.pop(context);
      }
      switch (screenName) {
        case "home":
          {
            context.read<PostProvider>().changeEventStatus(index!,
                isGoing: res['going_status'] == 'Going' ? true : false);
            break;
          }
        case "profile":
          {
            context.read<ProfilePostsProvider>().changeEventStatus(index!,
                isGoing: res['going_status'] == 'Going' ? true : false);
            break;
          }
        case "myevents":
          {
            myEventsListProvider.removeAt(index!);
            notifyListeners();
            break;
          }
        case "interested":
          {
            if (res["going_status"] == 'Not Going') {
              interestedevents[index!].isGoing = false;
              notifyListeners();
            } else {
              interestedevents[index!].isGoing = true;
              notifyListeners();
            }

            break;
          }
        case "going":
          {
            goingevents.removeAt(index!);
            notifyListeners();

            break;
          }
        default:
          {
            if (res["going_status"] == 'Not Going') {
              allevents[index!].isGoing = false;
              notifyListeners();
            } else {
              allevents[index!].isGoing = true;
              notifyListeners();
            }

            break;
          }
      }
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
    notifyListeners();

    return res;
  }

// Mark an event as interested using the API
  Future interestedEvent(BuildContext context, id, int? index,
      {String? screenName, bool? isEventDetail}) async {
    // Show a custom loading dialog while processing the interest status
    customDialogueLoader(context: context);
    // Prepare the data to be sent in the API request
    Map<String, dynamic> dataArray = {
      "event_id": id,
    };

    // Call the API to update the interest status
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'interest-event', apiData: dataArray);

    // Check if the API response indicates a successful operation
    if (res["code"] == '200') {
      // Show a toast message based on the interest status
      toast("${res["interested_status"]}");

      if (isEventDetail!) {
        Navigator.pop(context);
      }
      // Handle event removal based on the event type
      switch (screenName) {
        case "home":
          {
            context.read<PostProvider>().changeEventStatus(index!,
                isIntrested:
                    res['interested_status'] == 'Interested' ? true : false);
            break;
          }
        case "profile":
          {
            context.read<ProfilePostsProvider>().changeEventStatus(index!,
                isIntrested:
                    res['interested_status'] == 'Interested' ? true : false);
            break;
          }
        case "myevents":
          {
            myEventsListProvider.removeAt(index!);
            notifyListeners();

            break;
          }
        case "interested":
          {
            interestedevents.removeAt(index!);
            notifyListeners();
            break;
          }
        case "going":
          {
            // Update the interest status for the event
            if (res['interested_status'] != 'Not Interested') {
              goingevents[index!].isInterested = true;
              notifyListeners();
            } else {
              goingevents[index!].isInterested = false;
              notifyListeners();
            }
            break;
          }
        default:
          {
            if (res["interested_status"] == 'Not Interested') {
              allevents[index!].isInterested = false;
              notifyListeners();
            } else {
              allevents[index!].isInterested = true;
              notifyListeners();
            }

            break;
          }
      }
      // }
      // Close the loading dialog
      Navigator.pop(context);
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
    notifyListeners();
    return res;
  }

// Delete an event using the API
  Future<void> deleteEvents(
      {String? screenName,
      required eventId,
      required eventIndex,
      required isEventDetailScreen,
      required BuildContext context}) async {
    // Show a custom loading dialog while processing the delete operation
    customDialogueLoader(context: context);

    // Prepare the data to be sent in the API request
    Map<String, dynamic> map = {"event_id": eventId};

    // Call the API to delete the event
    dynamic res =
        await apiClient.callApiCiSocial(apiData: map, apiPath: "delete-event");

    // Check if the API response indicates a successful operation
    if (res["code"] == '200') {
      // Show a success message
      toast("Delete event successfully");
      notifyListeners();
      // Navigator.pop(context);
      Navigator.pop(context);
      if (isEventDetailScreen) {
        Navigator.pop(context);
      }

      // Handle event removal based on the screen name
      switch (screenName) {
        case "home":
          {
            context.read<PostProvider>().removePostAtIndex(eventIndex);

            break;
          }
        case "profile":
          {
            context.read<ProfilePostsProvider>().removeAtIndex(eventIndex!);

            break;
          }
        case "myevents":
          {
            // Remove the event from the list

            deleteMyEventInList(index: eventIndex, screenName: screenName);
            notifyListeners();
            break;
          }
      }

      // Close the loading dialog and navigate back
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
    notifyListeners();
  }

// Clear the list of events based on the current event name
  void makeListEmpty() {
    switch (currentEventName) {
      case "myevents":
        {
          // Clear the list of events associated with "my_events"
          myEventsListProvider.clear();
          notifyListeners();
          break;
        }
      case "interested":
        {
          // Clear the list of events associated with "interested"
          interestedevents.clear();
          break;
        }
      case "going":
        {
          // Clear the list of events associated with "going"
          goingevents.clear();
          break;
        }
      default:
        {
          // Clear the list of all events
          allevents.clear();
          break;
        }
    }

    // Notify listeners to reflect the changes
    notifyListeners();
  }

// Remove an event from the list based on the current event name
  void deleteMyEventInList({index, screenName}) {
    switch (screenName) {
      case "myevents":
        {
          // Remove the event at the specified index from "my_events" list
          myEventsListProvider.removeAt(index);
          notifyListeners();
          break;
        }
      case "interested":
        {
          // Remove the event at the specified index from "interested" list
          interestedevents.removeAt(index);
          break;
        }
      case "going":
        {
          // Remove the event at the specified index from "going" list
          goingevents.removeAt(index);
          break;
        }
      default:
        {
          // Remove the event at the specified index from the default event list
          allevents.removeAt(index);
          break;
        }
    }

    // Notify listeners to reflect the changes
    notifyListeners();
  }

// Delete an event at the specified index from the default event list
  void deleteEventInList({index}) {
    allevents.removeAt(index);
    notifyListeners();
  }

// Delete an event at the specified index from the "going" event list
  void deleteEventInGoingList({index}) {
    goingevents.removeAt(index);
    notifyListeners();
  }

// Delete an event at the specified index from the "interested" event list
  void deleteinterestEventInList({index}) {
    interestedevents.removeAt(index);
    notifyListeners();
  }

// Add an event to the "my_events" list
  void addMyEventInList({EventModel? event}) {
    myEventsListProvider.insert(0, event!);
    notifyListeners();
  }

// Set the current event name
  set setEventName(String eventName) {
    currentEventName = eventName;
    notifyListeners();
  }
}
