import 'package:flutter/material.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../viewModel/api_client.dart';

class DonnersProvider extends ChangeNotifier {
  List<Usr> getDonerList = [];
  bool isLoading = false;

  Future<void> getDonersList({
    required context,
    String? userId, // Your user ID
    String? bloodGroup,
    int offset = 0,
    int limit = 5,
  }) async {
    try {
      isLoading = true;

      // Prepare API data
      Map<String, dynamic> data = {
        "user_id": userId,
        "blood_group": bloodGroup,
        'offset': offset,
        'limit': limit,
      };
      print("Request Data: $data");

      // Call the API
      var res = await apiClient.callApiCiSocial(
          apiData: data, apiPath: "get-donor-list");
      print("Response of donor is $res");

      if (res["code"] == 200) {
        // Parse the new data and exclude your own entries
        List<Usr> newDonnerList = (res['data'] as List)
            .map((doner) => Usr.fromJson(doner as Map<String, dynamic>))
            .where((doner) {
          print("Donor ID: ${doner.id}, Current User ID: $userId");
          return doner.id != userId; // Filter out your own data
        }).toList();

        print("Parsed Donor List: $newDonnerList");

        // Avoid duplicates and append new data
        getDonerList.addAll(
          newDonnerList.where((newItem) => !getDonerList
              .any((existingItem) => existingItem.id == newItem.id)),
        );

        // Print the entire updated donor list
        print("Updated Donor List:");
        for (var donor in getDonerList) {
          print(
              "Donor ID: ${donor.id}, Name: ${donor.firstName}, Blood Group: ${donor.bloodGroup}, Created At: ${donor.createdAt}");
        }

        toast(res['message']);
      } else {
        print("Error Code: ${res['code']}, Message: ${res['message']}");
      }
    } catch (e) {
      log("Error is $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
