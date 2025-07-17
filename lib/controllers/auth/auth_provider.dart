// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:link_on/consts/routes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/viewModel/api_client.dart';

class AuthProvider extends ChangeNotifier {
  String? localTimezone;
  // Function to check OTP
  Future<void> checkOtp({
    required mobile,
    required BuildContext context,
    required otp,
  }) async {
    // Display a custom loader dialogue
    customDialogueLoader(context: context);

    // Prepare the data for the API call
    Map<String, dynamic> mapData = {
      "type": "validate",
      "mobile": mobile,
      "otp": otp,
    };

    // Call the API to check OTP
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "mobile_login");

    // Log the result of the OTP check
    log("check otp is $res");

    if (res["api_status"] == 200) {
      // Set access token and user ID
      setValue("access_token", res["access_token"]);
      setValue("user_id", res["user_id"]);

      // Close the loader dialogue
      Navigator.pop(context);

      // Show a toast message
      toast("${res["message"]}");

      // Check if OTP check is enabled and decide the next step
      if (getBoolAsync("otp_check") == true) {
        await getUserData(context: context);
      } else if (getStringAsync("userData") == '') {
        Navigator.pushReplacementNamed(context, AppRoutes.updateUser);
      }
    } else {
      // Close loader dialogues and show an error toast
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      toast("Check your internet connection"); // Show a toast message
      return false; // Return false if there's no internet
    }
    if (connectivityResult.contains(ConnectionState.waiting)) {
      toast("Your internet is weak");
    }
    return true; // Return true if the internet is available
  }

  // Function to get user data
  Future<void> getUserData({context}) async {
    // Get user data from the API
    dynamic res = await apiClient.get_user_data();

    log("user data is =>>>>> $res");

    if (res["code"] == '200') {
      await setValue("userData", res["data"]);
      await setValue("otp_check", true);

      Navigator.of(context).pushReplacementNamed(AppRoutes.tabs);
    } else {}
  }

  Future<String?> getLocalTimezone() async {
    localTimezone = await FlutterTimezone.getLocalTimezone();
    log("TimeZone is $localTimezone");
    if (localTimezone == null) {
      throw ArgumentError(
          "Time Zone is null and Invalid return from platform getLocalTimezone");
    }
    return localTimezone;
  }
}
