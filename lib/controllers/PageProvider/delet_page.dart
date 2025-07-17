import 'package:flutter/material.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';

class DeletePageProvider extends ChangeNotifier {
  // A function to delete a page
  Future deletPage({pageId, context}) async {
    var url = "delete-page";

    // Prepare the data for the API request
    Map<String, dynamic> mapData = {
      "page_id": pageId,
    };

    // Call the API to delete the page
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    toast(res['message'].toString());
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ExplorePages()));
  }
}
