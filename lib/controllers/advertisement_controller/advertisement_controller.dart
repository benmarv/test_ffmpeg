import 'package:flutter/material.dart';
import 'package:link_on/models/post_advertisement/post_advertisement_model.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class AdvertisementController extends ChangeNotifier {
  bool isLoading = false;
  List<PostAdvertisement> advertisements = [];

  removeAdvertisement(int index) {
    advertisements.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchAdvertisementRequests() async {
    try {
      isLoading = true;

      final apiData = {'limit': 10, 'offset': 0};

      final response = await apiClient.callApiCiSocial(
        apiPath: 'post/advertisement-requests',
        apiData: apiData,
      );

      if (response['status'] == '200') {
        List<dynamic> responseData = response['data'];
        advertisements = responseData
            .map(
              (data) => PostAdvertisement.fromJson(data),
            )
            .toList();

        if (advertisements.isNotEmpty) {
          log(advertisements[0].id.toString());
        }
      } else {}
    } catch (e) {
      log('Error fetching advertisement requests: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future approveOrDisapproveAd(String action, int id) async {
    Map<String, dynamic> apiData = {'action': action, 'ad_id': id};
    final response = await apiClient.callApiCiSocial(
      apiPath: 'post/advertisement-request-action',
      apiData: apiData,
    );

    toast('${response['message']}');
    return response;
  }
}
