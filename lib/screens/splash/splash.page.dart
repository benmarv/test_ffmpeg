// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/video_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/main.dart';
import 'package:link_on/screens/settings/subpages/change_language.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
  final String accessToken = getStringAsync('access_token');
}

class _SplashPageState extends State<SplashPage> {
  Future<void> getSiteSettings() async {
    final pro = Provider.of<SplashProvider>(context, listen: false);
    pro.setSiteSettingDataLoading(value: false);
    Response response = await dioService.dio.get(
      'get_site_settings',
      cancelToken: cancelToken,
    );
    dynamic res = response.data;

    if (res["status"] == '200') {
      await setValue("chck_generative_ai", res["data"]["chck-ai"]);

      await setValue(
          "buy_credit_with_crypto", res["data"]["buy_credit_with_crypto"]);
      await setValue("oneSignalAppId", res["data"]["one_signal_app_id"]);
      await setValue("isFriendSystem", res["data"]["is_friend_system"]);
      await setValue("adId", res["data"]["adid"]);
      await setValue("adAfterPost", res["data"]["ad_after_post"]);
      await setValue("isAdEnabled", res["data"]["is_enable_ad"]);
      await setValue(
          "isVideoCompressorEnabled", res["data"]["is_video_compressor"]);
      await setValue("stripePublicKey", res["data"]["stripe_public_key"]);
      await setValue("paypalClient", res["data"]["paypal_public_key"]);
      await setValue("paypalSecret", res["data"]["paypal_secret_key"]);
      await setValue("stripeSecretKey", res["data"]["stripe_secret_key"]);
      await setValue("paystackPublicKey", res["data"]["paystack_public_key"]);
      await setValue(
          "flutterwavePublicKey", res["data"]["flutterwave_public_key"]);
      await setValue(
          "flutterwaveSecretKey", res["data"]["flutterwave_secret_key"]);
      await setValue("appName", res["data"]["app_name"]);
      await setValue("appLogo", res["data"]["site_logo"]);
      await setValue("config", res["data"]);

      if (getStringAsync('current_language_code').isEmpty ||
          getStringAsync('current_language_code') == '') {
        await setValue('current_language_code', 'en');
        for (var lang in Language.languageList()) {
          if (lang.languageCode == res['data']['defualt_language']) {
            Locale locale = await setLocale(lang.languageCode);
            App.setLocale(context, locale);
            await setValue('current_language_code', lang.languageCode);
          }
        }
      }

      pro.setSiteSettingDataLoading(value: true);
      navigationPage();
    } else {
      pro.setSiteSettingDataLoading(value: true);
      navigationPage();
      print('Error: ${res['message']}');
    }
  }

  void navigationPage() {
    var accessToken = getStringAsync('access_token');
    Future.delayed(const Duration(seconds: 5), () {
      if (getStringAsync("isOtpDataUpdate") != "" &&
          getStringAsync("isOtpDataUpdate") == "notUpdated") {
        Navigator.of(context).pushReplacementNamed(AppRoutes.updateUser);
      } else if (accessToken == "") {
        if (getBoolAsync("isOnBoardingShown")) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
        }
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TabsPage(),
            ),
            (Route route) => false);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterBuildCreated(() {
        getSiteSettings();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<SplashProvider>(
      builder: (context, value, child) => value.isDataLoaded == true
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  SizedBox(
                    height: 235,
                    width: MediaQuery.sizeOf(context).width * .75,
                    child: Center(
                      child: Image.network(
                        getStringAsync('appLogo'),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              translate(context, 'powered_by')!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'LinkOn.com',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )
                          ]))
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
    ));
  }
}
