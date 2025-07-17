// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:link_on/components/auth_base_view.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/login_form_field.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/auth/auth_provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/main.dart';
import 'package:link_on/screens/auth/forgot_password/forgot_password.page.dart';
import 'package:link_on/screens/auth/login/linked_in.dart';
import 'package:link_on/screens/auth/register/register.page.dart';
import 'package:link_on/screens/settings/subpages/change_language.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:twitter_login/twitter_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
// Get user location
  Future<Position?> getUserCurrentLocation(
      {required bool isSocialLogin}) async {
    var permission = await Geolocator.requestPermission();
    if (!isSocialLogin) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: ((context) => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )),
        );
      }
    }

    if (permission == LocationPermission.denied) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (error) {
      log('Error getting location: ${error.toString()}');
      return null;
    }
  }

// Login
  Future<void> login({lat, lon, String? timeZone}) async {
    dynamic res;
    res = await apiClient.login(
        email: email.text,
        password: password.text,
        model: _deviceData["model"],
        lat: lat,
        lon: lon,
        timeZone: timeZone);

    log("LOGIN time zone is $timeZone");
    if (res['status'] == 200) {
      String accessToken = res['token'];

      await setValue("access_token", accessToken);
      await setValue("user_id", res["user_id"]);
      toast('Logged in Successfully');
      getUserDataFunc(res["user_id"]);
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast(
        res['messages']['error'],
        bgColor: Colors.red.shade300,
      );
    }
  }

// Get user data
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  Future<void> getUserDataFunc(userid) async {
    dynamic res = await apiClient.get_user_data(userId: userid);

    log('User Data is ${res['data']}');
    log('User language is ${res['data']['lang']}');

    if (res["code"] == '200') {
      await setValue("userData", res["data"]);
      await setValue('userLevel', res["data"]['user_level']);
      await setValue('user_first_name', res["data"]['first_name']);
      for (var lang in Language.languageList()) {
        if (lang.languageCode == res['data']['lang']) {
          Locale locale = await setLocale(lang.languageCode);
          App.setLocale(context, locale);
          await setValue('current_language_code', lang.languageCode);
        }
      }
      getUserData.value = Usr.fromJson(
        jsonDecode(
          getStringAsync("userData"),
        ),
      );

      if (mounted) {
        final provider = Provider.of<GreetingsProvider>(context, listen: false);
        provider.setCurrentTabIndex(index: 0);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TabsPage(),
            ),
            (Route route) => false);
      }
    } else {
      toast('Something went wrong!');
    }
  }

// Device info
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
      if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      log('My Device Info ${deviceData.toString()}');
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

// Android Info
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

// ios Info
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

// Socail Login API
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

    try {
      FormData form = FormData.fromMap(dataArray);
      Response response = await dioService.dio.post(
        "social-login",
        data: form,
      );

      dynamic res = response.data;
      log('social login response : ${res['status']}');
      if (res['status'] == 200) {
        String accessToken = res['token'];
        await setValue("user_id", res["user_id"]);
        await setValue("access_token", accessToken);
        toast('Logged in Successfully');
        getUserDataFunc(res["user_id"]);
      } else {
        if (mounted) {
          Navigator.pop(context);
        }
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

// Google Login
  Future<void> handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isAndroid
            ? null
            : "921573785222-fhdjkldnq7but2c0hk1t6qmbd220i2g5.apps.googleusercontent.com",
        signInOption: SignInOption.standard,
      );
      await googleSignIn.signIn().then((value) async {
        if (value != null) {
          final GoogleSignInAuthentication googleAuth =
              await value.authentication;
          final String? accessToken = googleAuth.accessToken;
          if (mounted) {
            // await getUserCurrentLocation(isSocialLogin: true).then((value) {
            socialLogin(
                    acess: accessToken,
                    lat: 0.0,
                    lon: 0.0,
                    context: context,
                    provider: "Google")
                .then((value) {});
            // });
          }
        }
      });
    } catch (error) {
      log('google sign in error >>> $error');
    }
  }

// Facebook Login
  Future<void> handleFacebookSignIn() async {
    FacebookAuth authIntance = FacebookAuth.instance;
    try {
      await authIntance.login(
          loginBehavior: LoginBehavior.webOnly,
          loginTracking: LoginTracking.enabled);
      await authIntance.accessToken.then(
        (facebookValue) async {
          log("facebook token : ${facebookValue!.tokenString}");
          // await getUserCurrentLocation(isSocialLogin: true).then((value) {
          socialLogin(
              acess: facebookValue.tokenString,
              lat: 0.0,
              lon: 0.0,
              context: context,
              provider: "facebook");
          // });
        },
      );
    } catch (e) {
      log("Something went wrong : $e");
    }
  }

// Twitter Login
  // Future<void> handleTwitterLogin() async {
  //   String apiKey = 'xGbX8TwZSuAsWneZoo3CRjX7r';
  //   String apiSecretKey = 'XXpxPLQOyxCPgedNzdRsjm2iSr0SnmKMXGNDJpYytnAVjVnT6b';
  //   log("Twiterr auth");

  //   try {
  //     final twitterLogin = TwitterLogin(
  //         apiKey: apiKey, apiSecretKey: apiSecretKey, redirectURI: 'linkon://');
  //     await twitterLogin.login(forceLogin: true).then(
  //       (twitterValue) async {
  //         log("Twiterr auth : ${twitterValue.authToken}");
  //         log("Twiterr auth : ${twitterValue.authTokenSecret}");
  //         log("Twiterr auth : ${twitterValue.user!.name}");
  //         // await getUserCurrentLocation(isSocialLogin: true).then((value) {
  //         socialLogin(
  //             acess: twitterValue.authToken,
  //             lat: 0.0,
  //             lon: 0.0,
  //             context: context,
  //             provider: "twitter");
  //         // });
  //       },
  //     );
  //   } on Exception catch (e) {
  //     log("error is ....... $e");
  //   }
  // }

  SiteSetting? site;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getLocalTimezone();

    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    initPlatformState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);

    final image = Container(
      margin: const EdgeInsets.only(top: 50.0, bottom: 20),
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: LottieBuilder.asset('assets/images/login-lottie.json'),
    );

    final title = Row(
      children: [
        Text(
          translate(context, AppString.login).toString(),
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          textAlign: TextAlign.left,
        ),
      ],
    );

    final emailField = LoginFormField(
      suffixIcon: Icon(LineIcons.at),
      hintText:
          translate(context, AppString.email_address), // Use translated hint
      controller: email,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return translate(
              context, 'enter_email'); // Translated key for 'Enter Your Email'
        }
        // Regular expression for validating an email address
        String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(val.trim())) {
          return translate(context,
              'valid_email'); // Translated key for 'Enter a valid Email Address'
        }
        return null;
      },
    );

    final passwordField = LoginFormField(
      controller: password,
      validator: (val) {
        if (val!.trim().isEmpty) {
          return translate(context,
              'enter_password'); // Translated key for 'Enter Your Password'
        }
        return null;
      },
      isPasswordField: true,
      hintText: translate(context, 'password'), // Translated key for 'Password'
    );

    final forgotPassword = Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () =>
            Navigator.of(context).push(createRoute(ForgotPasswordPage())),
        child: Text(
          translate(context, 'forgot_password')
              .toString(), // Translated key for "Forgot Password?"
          style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
      ),
    );

    final button = CustomButton(
      color: AppColors.primaryColor,
      textColor: Colors.white,
      text: translate(context, 'log_in'), // Translated key for "LOG IN"
      onPressed: () async {
        var provider = Provider.of<AuthProvider>(context, listen: false);
        if (!await provider.checkInternetConnection()) {
          return null;
        }
        if (_formKey.currentState!.validate()) {
          await getUserCurrentLocation(isSocialLogin: false)
              .then((value) async {
            login(
                lat: value?.latitude,
                lon: value?.longitude,
                timeZone: provider.localTimezone);
          });
        }
      },
      isGradient: true,
    );

    final form = Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(children: <Widget>[
          const SizedBox(height: 10),
          emailField,
          const SizedBox(height: 10),
          passwordField,
          const SizedBox(height: 20),
          forgotPassword,
          button,
        ]));

    return AuthBaseView(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            title,
            form,
            if (site!.chckUserRegistration == '1')
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: translate(
                        context, 'dont_have_account'), // Translated text
                    style: Theme.of(context).textTheme.bodySmall,
                    children: <TextSpan>[
                      TextSpan(text: ' '),
                      TextSpan(
                        text: translate(context, 'sign_up'), // Translated text
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacement(
                              createRoute(
                                RegisterPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            if (site!.chckGoogleLogin == '1' ||
                site!.chckFacebookLogin == '1' ||
                site!.chckTwitterLogin == '1' ||
                site!.chckLinkedinLogin == '1') ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Text(
                    translate(context, 'or').toString(), // Translated text
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (site!.chckGoogleLogin == '1')
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (await provider.checkInternetConnection() ==
                              false) {
                            return null;
                          }
                          await handleGoogleSignIn();
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(146, 237, 238, 238),
                              borderRadius: BorderRadius.circular(10)),
                          child: Image(
                            image: const AssetImage("assets/images/google.png"),
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  if (site!.chckFacebookLogin == '1')
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (!await provider.checkInternetConnection()) {
                            return null;
                          }
                          await handleFacebookSignIn();
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(146, 237, 238, 238),
                              borderRadius: BorderRadius.circular(10)),
                          child: Image(
                            image:
                                const AssetImage("assets/images/facebook.png"),
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  // if (site!.chckTwitterLogin == '1')
                  //   Center(
                  //     child: GestureDetector(
                  //       onTap: () async {
                  //         if (!await provider.checkInternetConnection()) {
                  //           return null;
                  //         }
                  //         await handleTwitterLogin();
                  //       },
                  //       child: Container(
                  //         height: 40,
                  //         margin: const EdgeInsets.symmetric(
                  //             vertical: 10, horizontal: 10),
                  //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  //         decoration: BoxDecoration(
                  //             color: const Color.fromARGB(146, 237, 238, 238),
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: Image(
                  //           image:
                  //               const AssetImage("assets/images/twitter.png"),
                  //           height: 20,
                  //           width: 20,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  if (site!.chckLinkedinLogin == '1')
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (!await provider.checkInternetConnection()) {
                            return null;
                          }
                          Navigator.of(context).push(createRoute(LinkedIn()));
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(146, 237, 238, 238),
                              borderRadius: BorderRadius.circular(10)),
                          child: Image(
                              image: const AssetImage(
                                  "assets/images/linkedin.png"),
                              height: 20,
                              width: 20),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class UserCredential {
  final String? accessToken;
  final String? secret;

  UserCredential({this.accessToken, this.secret});
}
