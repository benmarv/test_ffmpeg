// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:link_on/screens/groups/group.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/models/usr.dart';
import 'dart:developer' as dev;

class GroupsProvider extends ChangeNotifier {
  bool loader = false;
  int homeMenuIndex = 0;

  void setHomeMenuIndex(int index) {
    homeMenuIndex = index;
    notifyListeners();
  }

  String currentScreen = '';

  final List<JoinGroupModel> myGroups = [];
  final List<JoinGroupModel> joinGroups = [];
  final List<JoinGroupModel> discoverGroups = [];

  // Get recommended groups
  Future<void> getdiscovergroup({
    String? afterPostId,
  }) async {
    // Start loading data
    loadData(true);
    Map<String, dynamic> mapData = {
      "offset": afterPostId,
      "limit": 6,
    };
    String endPoint = 'all-groups';
    // Make an API call to fetch recommended groups
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: endPoint);

    if (res['code'] == '200') {
      // Parse the response data and add it to the list of discoverGroups
      List<JoinGroupModel> tempList = List.from(res['data'])
          .map<JoinGroupModel>((e) => JoinGroupModel.fromJson(e))
          .toList();
      discoverGroups.addAll(tempList);
      loadData(false);
      notifyListeners();
    } else if (res['code'] == '400') {
      loadData(false);
      if (res['message'] == 'No data found') {
        toast('No more data to show');
      } else {
        toast(res['message']);
      }
      notifyListeners();
    } else {
      // Finish loading data and display an error message
      loadData(false);
      notifyListeners();
    }
  }

// Get user's groups
  Future<void> getmygroups({required BuildContext context}) async {
    // Start loading data
    loadData(true);

    String endPoint = 'user-groups';

    // Make an API call to fetch user's groups
    dynamic res = await apiClient.callApiCiSocialGetType(
        apiPath: endPoint, context: context);

    if (res['code'] == '200') {
      // Parse the response data and add it to the list of myGroups
      List<JoinGroupModel> tempList = List.from(res['data'])
          .map<JoinGroupModel>((e) => JoinGroupModel.fromJson(e))
          .toList();
      myGroups.addAll(tempList);

      // Finish loading data
      loadData(false);
      notifyListeners();
    } else {
      // Finish loading data and display an error message
      loadData(false);
      notifyListeners();
    }
  }

  // Get user's joined groups
  Future<void> getJoinGroups({
    String? afterPostId,
  }) async {
    // Start loading data
    loadData(true);
    Map<String, dynamic> mapData = {"offset": afterPostId, 'limit': 6};
    String endPoint = 'joined-groups';
    // Make an API call to fetch user's joined groups
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: endPoint);
    dev.log("response is $res");
    if (res['code'] == '200') {
      // Parse the response data and add it to the list of joinGroups
      List<JoinGroupModel> tempList = List.from(res['data'])
          .map<JoinGroupModel>((e) => JoinGroupModel.fromJson(e))
          .toList();
      joinGroups.addAll(tempList);
      // Finish loading data
      loadData(false);
      notifyListeners();
    } else if (res['code'] == '400') {
      loadData(false);
      if (res['message'] == 'No data found') {
        toast('No data to show');
      } else {
        toast(res['message']);
      }
      notifyListeners();
    } else {
      // Finish loading data and display an error message
      loadData(false);
      notifyListeners();
    }
  }

// Create a new group
  Future<void> createGroup(BuildContext context,
      {required Map<String, dynamic> mapData}) async {
    // Display a loading dialog
    customDialogueLoader(context: context);

    // Make an API call to create a new group
    dynamic res =
        await apiClient.callApiCiSocial(apiData: mapData, apiPath: "add-group");

    if (res['code'] == '200') {
      // Group created successfully, show a success message
      toast("Group Created Successfully");
      JoinGroupModel createdGroup = JoinGroupModel.fromJson(res['data']);
      insertAtSpecificIndex(createdGroup, index: 0);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
  }

// Join a group
  Future joinGroup({
    required JoinGroupModel joinGroupModel,
    required BuildContext context,
    // required int index,
  }) async {
    // Display a custom loading dialog
    customDialogueLoader(context: context);

    // Make an API call to join the group
    dynamic res = await apiClient.joinGroupApi(groupId: joinGroupModel.id);
    log('Response of join Group api .... ${res.toString()}');

    if (res["code"] == "200") {
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Groups(),
          ));
      toast(res['message']);
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
  }

// Leave a group
  Future<void> leaveGroup({
    index,
    required BuildContext context,
    required JoinGroupModel? joinGroupModel,
  }) async {
    // Display a custom loading dialog
    customDialogueLoader(context: context);

    Map<String, dynamic> mapData = {
      "group_id": joinGroupModel?.id,
    };

    // Make an API call to leave the group
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "leave-group");

    if (res['code'] == '200') {
      toast(res['message'].toString());

      // Close the loading dialog and navigate back multiple times
      Navigator.pop(context);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Groups(),
          ));
    } else {
      // Close the loading dialog and show an error message
      Navigator.pop(context);
    }
  }

// Delete a group
  Future groupDeletFuntion({
    required groupId,
    required password,
    int? index,
    required BuildContext context,
  }) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);
    // Prepare API request data
    Map<String, dynamic> mapData = {
      "group_id": groupId,
    };

    // Make an API call to delete the group
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: 'delete-group');

    if (res["code"] == '200') {
      // Display a success message
      toast("Delete group successfully", print: true);

      // If an index is provided, remove the group at that index
      if (index != null) {
        removeAtSpecificIndex(index);
      }
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      // Close the loading dialog and display an error message
      Navigator.pop(context);
    }
  }

// List of all group members
  List<Usr> _memberDataList = [];
  List<Usr> get getMemberDataList => _memberDataList;

// List of only group members
  List<Usr> _onlyMembers = [];
  List<Usr> get getOnlyMembers => _onlyMembers;

// List of only group administrators (admins)
  List<Usr> _onlyAdmin = [];
  List<Usr> get getOnlyAdmin => _onlyAdmin;

// Indicates whether the current user is an admin of the group
  bool isAdmin = false;

  Future<void> groupmemberslist({
    groupid,
    context,
    String? afterPostId,
  }) async {
    // Display loading indicator
    loadData(true);

    // Prepare API request data
    Map<String, dynamic> mapData = {
      "group_id": groupid,
      "limit": 20,
    };

    if (afterPostId != null) {
      mapData['offset'] = afterPostId;
    } else {
      // Reset member lists and admin status when not using pagination
      _memberDataList = [];
      _onlyMembers = [];
      _onlyAdmin = [];
      isAdmin = false;
    }

    // Make an API call to fetch group members
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: 'get-group-members');

    if (res['code'] == '200') {
      dev.log("get group member response ${res['data']}");

      var decodedData = res;
      var productsData = decodedData["data"];
      List<Usr> temList =
          List.from(productsData).map<Usr>((e) => Usr.fromJson(e)).toList();
      _memberDataList.addAll(temList);

      dev.log("get group member templist data ${temList[0].isAdmin}");

      // Split members into admins and non-admin members
      for (int i = 0; i < temList.length; i++) {
        if (temList[i].isAdmin == '1') {
          _onlyAdmin.add(temList[i]);
          isAdmin = true;
        } else {
          _onlyMembers.add(temList[i]);
        }
      }

      // Hide loading indicator
      loadData(false);
    } else {
      // Hide loading indicator and show an error message
      loadData(false);
    }
  }

// Promote a group member to admin
  Future makeGroupAdminProvider({
    required groupId,
    required userId,
    required int index,
    required BuildContext context,
  }) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    // Prepare API request data
    Map<String, dynamic> mapData = {"group_id": groupId, "user_id": userId};

    // Make an API call to promote the group member to admin
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "make-group-admin");
    if (res["code"] == '200') {
      // Move the member from the 'onlyMembers' list to the 'onlyAdmin' list
      _onlyAdmin.insert(_onlyAdmin.length - 1, _onlyMembers[index]);
      _onlyMembers.removeAt(index);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Notify listeners about the change
      notifyListeners();
    } else {
      // Close the loading dialog and display an error message
      Navigator.of(context).pop();
    }
  }

// Delete a group member
  Future deleteMemberProvder(
    context, {
    required groupId,
    required userId,
    required int index,
    groupIndex,
  }) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    // Prepare API request data
    Map<String, dynamic> mapData = {"group_id": groupId, "user_id": userId};

    // Make an API call to delete the group member
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: 'remove-member');

    if (res["code"] == '200') {
      // Remove the member from the '_memberDataList'
      for (int i = 0; i < 5; i++) {
        if (_onlyMembers[index].id == _memberDataList[i].id) {
          _memberDataList.removeAt(index);
          break;
        }
      }

      // Update the 'membersCount' for the group in the appropriate list
      if (groupIndex != null) {
        switch (currentScreen) {
          case 'mygroups':
            myGroups[groupIndex].membersCount =
                (int.parse(myGroups[groupIndex].membersCount!) - 1).toString();
            break;
          case "joingroups":
            joinGroups[groupIndex].membersCount =
                (int.parse(myGroups[groupIndex].membersCount!) - 1).toString();
            break;
          default:
            discoverGroups[groupIndex].membersCount =
                (int.parse(myGroups[groupIndex].membersCount!) - 1).toString();
        }
      }

      // Remove the member from the 'onlyMembers' list
      _onlyMembers.removeAt(index);

      // Display a success message
      toast("Delete member successfully");

      // Close the loading dialog
      Navigator.pop(context);
      Navigator.pop(context);

      // Notify listeners about the change
      notifyListeners();
    } else {
      // Display an error message and close the loading dialog
      Navigator.pop(context);
    }
  }

// leave  group for admin
  Future leaveGroupForAdmin(
    context, {
    required groupId,
    required userId,
    // required int index,
    groupIndex,
  }) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    // Prepare API request data
    Map<String, dynamic> mapData = {"group_id": groupId, "user_id": userId};

    // Make an API call to delete the group member
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: 'dismiss-admin');
    if (res["code"] == '200') {
      toast(res['message']);
      // Close the loading dialog
      Navigator.pop(context);
      Navigator.pop(context);

      // Notify listeners about the change
      notifyListeners();
    } else {
      // Display an error message and close the loading dialog
      Navigator.pop(context);
    }
  }

// Clear group lists
  void makeGroupListEmpty(String? status) {
    status == "mygroups"
        ? myGroups.clear()
        : status == "joined"
            ? joinGroups.clear()
            : discoverGroups.clear();
    notifyListeners();
  }

// Remove a group at a specific index from the appropriate list
  void removeAtSpecificIndex(int index) {
    switch (currentScreen) {
      case 'mygroups':
        {
          myGroups.removeAt(index);
          break;
        }
      case "joingroups":
        {
          joinGroups.removeAt(index);
          break;
        }
      default:
        {
          discoverGroups.removeAt(index);
        }
    }
    notifyListeners();
  }

// Insert a group at a specific index in the appropriate list
  void insertAtSpecificIndex(
    JoinGroupModel joinGroupModel, {
    index,
  }) {
    switch (currentScreen) {
      case 'mygroups':
        {
          myGroups.insert(index ?? 0, joinGroupModel);
          break;
        }
      case "joingroups":
        {
          joinGroups.insert(index ?? 0, joinGroupModel);
          break;
        }
      default:
        {
          discoverGroups.insert(index ?? 0, joinGroupModel);
        }
    }
    notifyListeners();
  }

// Set the loader state to indicate loading or not
  void loadData(bool value) {
    loader = value;
    notifyListeners();
  }
}
