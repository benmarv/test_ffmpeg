import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/EventsModel/create_event.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';

class SearchProvider extends ChangeNotifier {
  int? currentIndex;
  String? peopleMessage;
  String? pageMessage;
  String? groupMessage;
  String? eventMessage;
  String? jobMessage;
  bool data = false;
  List<Usr> user = [];
  List<JoinGroupModel> group = [];
  List<GetLikePage> page = [];
  List<EventModel> events = [];
  List<MyJobModel> jobs = [];

  Future makeRelation({userId, name, cancelRequest, index}) async {
    String url = 'make-friend';
    Map<String, dynamic> mapData = {"friend_two": userId};
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      return res;
    } else {
      toast('Error: ${res['message']}');
    }
    notifyListeners();
  }

  Future unfriendUser({userId, name}) async {
    String url = 'unfriend';
    Map<String, dynamic> mapData = {"user_id": userId};

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      return res;
    } else {
      toast('Error: ${res['message']}');
    }
    notifyListeners();
  }

  Future<void> search({query, required String type}) async {
    try {
      data = false;
      notifyListeners();
      Map<String, dynamic> mapData = {
        "search_string": query,
        "type": type,
        "limit": 20
      };
      dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData,
        apiPath: "search-user",
      );
      data = true;
      notifyListeners();
      if (res.containsKey('error')) {
        data = true;
        notifyListeners();
      }
      log('Response of search api is ${res} type is $type and query is ${query}');
      if (res['code'] == '200') {
        var decodedData = res;
        if (res['data'] != null && type == 'people') {
          peopleMessage = '';
          var usrData = decodedData['data'];
          user = List.from(usrData).map<Usr>(
            (e) {
              return Usr.fromJson(e);
            },
          ).toList();
        } else if (res['data'] != null && type == 'group') {
          groupMessage = '';
          var grpData = decodedData['data'];
          group = List.from(grpData).map<JoinGroupModel>(
            (e) {
              return JoinGroupModel.fromJson(e);
            },
          ).toList();
        } else if (res['data'] != null && type == 'page') {
          pageMessage = '';
          var grpData = decodedData['data'];
          page = List.from(grpData).map<GetLikePage>(
            (e) {
              return GetLikePage.fromJson(e);
            },
          ).toList();
        } else if (res['data'] != null && type == 'event') {
          eventMessage = '';
          var eventData = decodedData['data'];
          events = List.from(eventData).map<EventModel>(
            (e) {
              return EventModel.fromJson(e);
            },
          ).toList();
        } else if (res['data'] != null && type == 'job') {
          jobMessage = '';
          var jobData = decodedData['data'];
          jobs = List.from(jobData).map<MyJobModel>(
            (e) {
              return MyJobModel.fromJson(e);
            },
          ).toList();
        } else {
          if (type == 'people') {
            peopleMessage = res['message'];
          } else if (type == 'page') {
            pageMessage = res['message'];
          } else if (type == 'group') {
            groupMessage = res['message'];
          } else if (type == 'job') {
            jobMessage = res['message'];
          } else {
            eventMessage = res['message'];
          }
        }

        data = true;
        notifyListeners();
      } else {
        data = true;
        toast('Something Went Wrong');
      }
    } catch (e) {
      data = true;
      // toast('Something Went Wrong');
    }
  }
}
