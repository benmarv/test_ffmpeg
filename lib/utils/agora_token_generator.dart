import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';

class AgoraTokenGenerator {
  static Future<String?> generateAgoraRTMToken() async {
    try {
      dynamic res =
          await apiClient.callApiCiSocial(apiPath: "generate-agora-rtm-token");

      if (res["code"] == "200") {
        print("token isss ${res["data"]}");
        return res["data"].toString();
      } else {
        log("API Error: ${res['code']} - ${res['message']}");
        return null; // Or throw an exception
      }
    } catch (e) {
      log("API Exception: $e");
      return null; // Or throw an exception
    }
  }

  static Future<String> generateAgoraRTCToken(String channelName) async {
    Map<String, dynamic> data = {
      "channel_name": channelName,
    };
    String agoraRTCToken = "";
    try {
      dynamic res = await apiClient.callApiCiSocial(
          apiPath: "generate-agoratoken", apiData: data);

      if (res["status"] == 200) {
        print("token isss ${res["token"]}");
        agoraRTCToken = res["token"].toString();
      } else {
        log("API Error: ${res['status']} - ${res['message']}");
      }
    } catch (e) {
      log("API Exception: $e");
    }
    return agoraRTCToken;
  }
}
