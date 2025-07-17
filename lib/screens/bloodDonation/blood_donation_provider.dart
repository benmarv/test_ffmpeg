// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/screens/bloodDonation/model/blood_request_model.dart';
import 'package:link_on/screens/bloodDonation/model/donor_model.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';

class BloodDonationProvider extends ChangeNotifier {
  String? selectedBloodGroup;
// select blood group
  void selectBloodGroup(String bloodGroup) {
    selectedBloodGroup = bloodGroup;
    notifyListeners();
  }

// remove previosuly selected blood group
  void removeSelectedBloodGroup() {
    selectedBloodGroup = '';
    notifyListeners();
  }

  List<DonorModel> donorList = [];
// get donor's list
  Future<void> getDonorsList(
      {required BuildContext context, required String bloodGroup}) async {
    // Show a custom loading dialog
    donorList = [];
    var accessToken = getStringAsync("access_token");
    customDialogueLoader(context: context);

    log("donor list by blood group : $bloodGroup");

    Map<String, dynamic> mapData = {};
    if (bloodGroup.isNotEmpty) {
      mapData["blood_group"] = bloodGroup;
    }

    String url = 'get-donor-list';
    FormData form = FormData.fromMap(mapData);
    Response response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    if (response.data["code"] == 200) {
      log("donor list sucess: ${response.data['data']}");

      var temp = List.from(response.data['data']).map<DonorModel>((e) {
        return DonorModel.fromJson(e);
      }).toList();

      for (int i = 0; i < temp.length; i++) {
        if (!donorList.any((donor) => donor.id == temp[i].id)) {
          donorList.add(temp[i]);
        }
      }
      Navigator.pop(context);
      notifyListeners();
    } else {
      log("donor list failed : ${response.data['data']}");

      // Close the loading dialog and display an error message
      Navigator.pop(context);
    }
  }

// update donor info
  Future<void> updateDonorData(
      {required BuildContext context,
      required Map<String, dynamic> dataArray}) async {
    customDialogueLoader(context: context);

    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: dataArray);

    log('update donor info : ${res['message']}');
    if (res["code"] == '200') {
      toast(res['message']);

      // Close the loading dialog and navigate back
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  // create blood request
  Future<void> createBloodRequest(
      {required BuildContext context,
      required Map<String, dynamic> dataArray}) async {
    customDialogueLoader(context: context);

    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'add-blood-request', apiData: dataArray);

    log('update donor info : ${res['message']}');
    if (res["code"] == '200') {
      toast(res['message']);

      // Close the loading dialog and navigate back
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  List<BloodRequestModel> bloodRequestList = [];

  Future<void> deleteBloodRequest({
    required String bloodRequestId,
    required BuildContext context,
  }) async {
    customDialogueLoader(context: context);

    var accessToken = getStringAsync("access_token");

    final Map<String, dynamic> mapData = {"request_id": bloodRequestId};

    String endPoint = 'delete-bloodrequest';
    FormData form = FormData.fromMap(mapData);
    Response response = await dioService.dio.post(
      endPoint,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );
    Navigator.pop(context);
    if (response.data['code'] == 200) {
      log('length of request list is ${bloodRequestList.length}');
      bloodRequestList.removeWhere(
        (item) => item.id == bloodRequestId,
      );
      notifyListeners();
      log('length of request list is ${bloodRequestList.length}');

      toast(response.data['message']);
    } else {
      toast(response.data['message']);
    }
  }

// get donor's list
  Future<void> getBloodRequestsList(
      {required BuildContext context,
      required String bloodGroup,
      String? urgentNeed}) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    bloodRequestList = [];
    var accessToken = getStringAsync("access_token");

    Map<String, dynamic> mapData = {};
    if (bloodGroup.isNotEmpty) {
      mapData["blood_group"] = bloodGroup;
    }
    if (urgentNeed!.isNotEmpty) {
      mapData["is_urgent_need"] = urgentNeed;
    }

    String url = 'get-blood-request';
    FormData form = FormData.fromMap(mapData);
    Response response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
    );

    if (response.data["code"] == "200") {
      log("blood request list sucess: ${response.data['data']}");

      var temp = List.from(response.data['data']).map<BloodRequestModel>((e) {
        return BloodRequestModel.fromJson(e);
      }).toList();

      for (int i = 0; i < temp.length; i++) {
        if (!bloodRequestList.any((donor) => donor.id == temp[i].id)) {
          bloodRequestList.add(temp[i]);
        }
      }
      Navigator.pop(context);
      notifyListeners();
    } else {
      log("blood request list error : ${response.data['data']}");

      // Close the loading dialog and display an error message
      Navigator.pop(context);
    }
  }
}
