import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';

class NearByProvider extends ChangeNotifier {
  List<Usr> nearbyFriends = [];
  Map<String, String> selectedValues = {
    'gender': 'All',
    'relationship': 'Single',
    'status': 'Both'
  };
  String selectedDistance = '5';
  bool isLoading = false;

  Future<dynamic> makeRelation(
      {required String userId,
      required String name,
      required bool cancelRequest,
      required int index}) async {
    return _apiCall('make-friend', {"friend_two": userId});
  }

  Future<dynamic> unfriendUser(
      {required String userId, required String name}) async {
    return _apiCall('unfriend', {"user_id": userId});
  }

  Future<void> getNearbyFriends(
      {String? gender,
      String? distance,
      String? relationship,
      String? status}) async {
    log('Gender ${gender.toString()}');
    log('Relationship ${relationship.toString()}');
    log('Status ${status.toString()}');

    try {
      isLoading = true;
      notifyListeners();
      const endPoints = "search-friend-filter";
      final data = {
        'gender': gender == 'All' ? null : gender,
        'distance': distance,
        'relation_id': relationship == 'Single'
            ? '1'
            : relationship == 'Married'
                ? '3'
                : '4',
        'status': status == 'Both' ? null : status,
      };
      final response = await _apiCall(endPoints, data);
      nearbyFriends = List.from(response['users'])
          .map<Usr>((e) => Usr.fromJson(e))
          .toList();
    } catch (e) {
      nearbyFriends = [];
      toast('Something went wrong');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> _apiCall(String endpoint, Map<String, dynamic> data) async {
    dynamic response =
        await apiClient.callApiCiSocial(apiPath: endpoint, apiData: data);
    if (response["code"] != '200') {
      toast('Error: ${response['message']}');
      return null;
    }
    return response;
  }
}
