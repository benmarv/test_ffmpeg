// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/spaces_model/spaces_model.dart';
import 'package:link_on/viewModel/api_client.dart';

class SpaceProvider extends ChangeNotifier {
  bool loading = false;
  List<SpaceModel> spacesList = [];
  String? selectedTopic;
  List<Member> requestQueue = [];
  List<Member> spaceMembers = [];

  void removeSpace({required String spaceId}) {
    spacesList.removeWhere(
      (element) => element.id == spaceId,
    );
    notifyListeners();
  }

  List<String> approvedCoHost = [];

  void removeRequestQueue(String userId) {
    requestQueue.removeWhere((element) => element.userId == userId);
    notifyListeners();
  }

  void addToRequestQueue(String userId) {
    for (Member member in spaceMembers) {
      if (member.userId == userId &&
          !requestQueue.any((element) => element.userId == userId)) {
        requestQueue.add(member);
        log("Member added to the request queue.");
      }
    }
    notifyListeners();
  }

  void removeFromRequestQueue(String userId) {
    requestQueue.removeWhere(
      (element) => element.userId == userId,
    );
    notifyListeners();
  }

  List<SpaceModel> get getSpaceslist => spacesList;

  Future<SpaceModel?> createSpace({
    required BuildContext context,
    String? amount,
    required String title,
    required String description,
    required int privacy,
  }) async {
    loading = true;
    notifyListeners();
    try {
      Map<String, dynamic> mapData = {
        "title": title,
        "description": description,
        'privacy': privacy,
        'is_paid': amount != null ? '1' : '0',
        'amount': amount ?? '0'
      };

      dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData,
        apiPath: "create-space",
      );
      log('Response of create space ${res.toString()}');
      if (res["code"] == '200') {
        loading = false;
        SpaceModel space = SpaceModel.fromJson(
          res['data'],
        );
        toast(res["message"]);

        notifyListeners();

        return space;
      } else {
        loading = false;
        notifyListeners();
        throw Exception(res['message']);
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      toast(e.toString());
      return null;
    }
  }

  void makeSpacesListEmpty() {
    spacesList.clear();
    notifyListeners();
  }

  //Get all spaces

  Future<void> getAllSpaces({offset}) async {
    try {
      log('SPaces Offset $offset');
      List<SpaceModel> tempList = [];

      Map<String, dynamic> mapData = {"limit": 10};

      if (offset != null) {
        mapData['offset'] = offset;
      }

      loading = true;
      dynamic res = await apiClient.callApiCiSocial(
          apiData: mapData, apiPath: "get-spaces");

      log('Response of get Spaces ${res.toString()}');

      if (res["code"] == '200') {
        for (int i = 0; i < res["data"].length; i++) {
          SpaceModel spacesModel = SpaceModel.fromJson(res["data"][i]);
          tempList.add(spacesModel);
        }
        spacesList.addAll(tempList);

        loading = false;
      } else {
        if (tempList.isEmpty && offset != null) {
          toast('No more spaces to show');
        }
        loading = false;
        log("Error get all Spaces: ${res['message']}");
      }
    } catch (e) {
      loading = false;
      log(e.toString());
    }
    notifyListeners();
  }

  // Space join member
  Future<dynamic> joinSpace({
    required BuildContext context,
    required String spaceId,
  }) async {
    Map<String, dynamic> mapData = {
      "space_id": spaceId,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "join-space");
    return res;
  }

  // Space join member
  Future<void> leaveSpace({
    required BuildContext context,
    required spaceId,
  }) async {
    Map<String, dynamic> mapData = {
      "space_id": spaceId,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "leave-space");
    log('Response of Leave Api ${res.toString()}');
    if (res["code"] == '200') {
      log("leave space : ${res['message']}");
    } else {
      log("Error: ${res['message']}");
    }
  }

  Future<void> getSpaceMembers(
      {required BuildContext context, required spaceId}) async {
    loading = true;
    spaceMembers.clear();

    Map<String, dynamic> mapData = {
      "space_id": spaceId,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "get-space-members");
    if (res["code"] == '200') {
      for (int i = 0; i < res["data"].length; i++) {
        Member spaceModel = Member.fromJson(res["data"][i]);
        spaceMembers.add(spaceModel);
      }
      log("space members: ${res['data']}");
      loading = false;
    } else {
      loading = false;
      log("Error: ${res['message']}");
    }
    notifyListeners();
  }

  void clearSpaceMemberList() {
    spaceMembers = [];
    spaceMembers.clear();
    notifyListeners();
  }

  // search spaces
  List<SpaceModel> searchSpacesList = [];
  List<SpaceModel> get getSerachSpaceslist => searchSpacesList;

  Future<void> searchSpaces(
      {required BuildContext context, required String keyword}) async {
    searchSpacesList = [];
    loading = false;
    Map<String, dynamic> mapData = {"title": keyword, "limit": 10};
    dynamic res = await apiClient.callApiCiSocial(
      apiData: mapData,
      apiPath: "search-space",
    );
    if (res["code"] == '200') {
      for (int i = 0; i < res["data"].length; i++) {
        SpaceModel spacesModel = SpaceModel.fromJson(res["data"][i]);
        searchSpacesList.add(spacesModel);
      }
      print('search spaces first title print ${searchSpacesList[0].title}');

      loading = true;
      notifyListeners();
    } else {
      loading = true;
      log("Error: ${res['message']}");
    }
  }

  // Edit space
  Future<void> editSpace({
    required spaceId,
    spaceTitle,
    description,
    required BuildContext context,
    index,
    bool? isSearchScreen,
  }) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> mapData = {
      "space_id": spaceId,
    };
    if (spaceTitle != null) {
      mapData["space_title"] = spaceTitle;
    }
    if (description != null) {
      mapData["description"] = description;
    }
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: "spaces");
    if (res["code"] == '200') {
      Navigator.pop(context);
      if (isSearchScreen == true) {
        if (spaceTitle != null) {
          searchSpacesList[index].title = spaceTitle;
        }
        if (description != null) {
          searchSpacesList[index].description = description;
        }
      } else {
        if (spaceTitle != null) {
          spacesList[index].title = spaceTitle;
        }
        if (description != null) {
          spacesList[index].description = description;
        }
      }

      toast(res["message"]);
      notifyListeners();
    } else {
      Navigator.pop(context);
      log("Error: ${res['message']}");
    }
  }
}
