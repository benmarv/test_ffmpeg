import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';

class ReportActionpProvider extends ChangeNotifier {
  // Function for report action on videos
  Future reportAction({url, Map<String, dynamic>? mapData, context}) async {
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    log('Response of report api is ${res.toString()}');
    if (res['code'] == '200') {
      toast(res['message']);
    } else {
      toast('Something Went Wrong');
    }
  }
}
