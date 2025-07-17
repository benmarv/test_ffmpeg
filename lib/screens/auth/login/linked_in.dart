import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LinkedIn extends StatelessWidget {
  const LinkedIn({super.key});

  @override
  Widget build(BuildContext context) {
    String redirectUrl = 'https://linkon.social/';
    String clientId = '776oavy63s2oyb';
    String clientSecret = 'Np2UAC3sKOFR6VOm';
    Future<void> getUserDataFunc(userid) async {
      dynamic res = await apiClient.get_user_data(userId: userid);

      if (res["code"] == '200') {
        await setValue("userData", res["data"]);
        await setValue('userLevel', res["data"]['user_level']);
        await setValue('user_first_name', res["data"]['first_name']);

        getUserData.value =
            Usr.fromJson(jsonDecode(getStringAsync("userData")));
        // if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TabsPage(),
            ),
            (Route route) => false);
        // }
      } else {
        toast('Something went wrong!');
      }
    }

    Future<void> socialLogin(
        {String? acess,
        lat,
        lon,
        required BuildContext context,
        required String provider}) async {
      customDialogueLoader(context: context);
      var onesignalId = await OneSignal.User.pushSubscription.id;
      String deviceType = "";
      if (Platform.isAndroid) {
        deviceType = "Android";
      } else if (Platform.isIOS) {
        deviceType = "ios";
      }

      Map<String, dynamic> dataArray = {
        "device_type": deviceType,
        "device_id": onesignalId,
        "provider": provider,
        "token": acess,
        "lat": lat,
        "lon": lon
      };
      print('social login payload : $dataArray');
      try {
        FormData form = FormData.fromMap(dataArray);
        Response response = await dioService.dio.post(
          "social-login",
          data: form,
        );
        print('social login response : ${response.data}');

        dynamic res = response.data;
        if (res['status'] == 200) {
          String accessToken = res['token'];
          await setValue("user_id", res["user_id"]);
          await setValue("access_token", accessToken);
          toast('Logged in Successfully');
          getUserDataFunc(res["user_id"]);
        } else {
          // if (mounted) {
          Navigator.pop(context);
          // }
          toast(
            res['messages']['error'],
            bgColor: Colors.red.shade300,
          );
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception("Connection  Timeout Exception");
        }
        if (e.type == DioExceptionType.receiveTimeout) {
          toast("Something went wrong try again");
        }
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: LinkedInUserWidget(
            redirectUrl: redirectUrl,
            clientId: clientId,
            clientSecret: clientSecret,
            onGetUserProfile: (UserSucceededAction linkedInUser) {
              socialLogin(
                  context: context,
                  provider: 'linkedin',
                  acess: linkedInUser.user.token.accessToken,
                  lat: 0.0,
                  lon: 0.0);
            },
            onError: (UserFailedAction e) {
              print('Error: ${e.toString()}');
            },
          ),
        ),
      ),
    );
  }
}
