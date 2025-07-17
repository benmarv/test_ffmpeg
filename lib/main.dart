import 'package:dio/dio.dart';
import 'router/router.dart' as router;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_on/controllers/theme_controller.dart';
import 'package:link_on/viewModel/multiprovider_class.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:link_on/screens/call_screen/call_screen.dart';
import 'package:link_on/localization/language_localization.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:link_on/screens/message_details.dart/audio_call.dart';
import 'package:link_on/screens/message_details.dart/video_call.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';

void main() async {
  ErrorWidget.builder = (details) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        "Error is ${details.exception}",
        style: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  AppConfig.setupConfig(isDevelopmentEnviroment: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('is_dark') ?? false;
  MobileAds.instance.initialize();
  await initialize();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await FlutterAppBadger.updateBadgeCount(0);
  initializeOneSignal();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'call_channel',
      channelName: 'Call Notifications',
      channelDescription: 'Notification channel for call alerts',
      importance: NotificationImportance.Max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      defaultRingtoneType: DefaultRingtoneType.Ringtone,
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
    )
  ]);
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod,
  );
  runApp(App(isDark: isDark));
}

// My App
class App extends StatefulWidget {
  final bool isDark;
  const App({super.key, required this.isDark});

  @override
  State<App> createState() => _AppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setLocale(newLocale);
  }
}

class _AppState extends State<App> {
  Locale _locale = Locale("en");

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
          setState(() {
            this._locale = local;
          })
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProviderClass.providersList,
      child: OverlaySupport(
        child: Builder(
          builder: (BuildContext context) {
            Provider.of<ThemeChange>(context, listen: false)
                .themeChange(widget.isDark);
            return Consumer<ThemeChange>(
              builder: (context, value, child) {
                return MaterialApp(
                  locale: _locale,
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.dark(
                      primary: AppColors.primaryColor,
                      secondary: const Color(0xff282828),
                      surface: const Color(0xff282828).withOpacity(0.6),
                      onSurface: Colors.white,
                    ),
                    brightness: Brightness.dark,
                    textTheme: const TextTheme(
                      titleLarge: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xff111111),
                    ),
                  ),
                  theme: ThemeData(
                    useMaterial3: true,
                    brightness: Brightness.light,
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryColor,
                      secondary: Colors.grey.shade200,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textTheme: const TextTheme(
                      titleLarge: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  supportedLocales: [
                    Locale(ENGLISH, 'US'),
                    Locale(SPANISH, 'ES'),
                    Locale(ARABIC, 'AE'),
                    Locale(URDU, 'PK'),
                    Locale(GERMAN, 'DE'),
                    Locale(FRENCH, 'FR'),
                    Locale(CHINESE, 'CN'),
                    Locale(DUTCH, 'NL'),
                  ],
                  localizationsDelegates: [
                    LanguageLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocal, supportedLocales) {
                    for (var local in supportedLocales) {
                      if (local.languageCode == deviceLocal!.languageCode &&
                          local.countryCode == deviceLocal.countryCode) {
                        return deviceLocal;
                      }
                    }
                    return supportedLocales.first;
                  },
                  themeMode: value.currentTheme,
                  navigatorKey: navigatorKey,
                  title: Constants.appName,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: router.generateRoute,
                  initialRoute: AppRoutes.splash,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// initialize OneSignal
void initializeOneSignal() async {
  await dotenv.load(fileName: '.env');

  Response response = await dioService.dio.get('get_site_settings');
  dynamic res = response.data;
  await setValue('agoraAppId', res['data']['agora_app_id']);

  initPlatformState();

  Stripe.publishableKey = res["data"]["stripe_public_key"];
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  final String oneSignalAppId = dotenv.env['OneSignal_APP_ID']!;
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.Debug.setAlertLevel(OSLogLevel.none);
  OneSignal.consentRequired(true);
  OneSignal.consentGiven(true);
  OneSignal.LiveActivities.setupDefault();
  OneSignal.Notifications.requestPermission(true);
  OneSignal.initialize(oneSignalAppId);

  OneSignal.User.pushSubscription.addObserver((state) {
    log("opted in : ${OneSignal.User.pushSubscription.optedIn}");
    log("push subscription id : ${OneSignal.User.pushSubscription.id}");
    log("push subscription token : ${OneSignal.User.pushSubscription.token}");
    log("current state : ${state.current.jsonRepresentation()}");
  });

  OneSignal.User.addObserver((state) {
    var userState = state.jsonRepresentation();
    log('OneSignal user changed: $userState');
  });

  OneSignal.Notifications.addPermissionObserver((state) {
    log("Has permission $state");
  });

  OneSignal.Notifications.addClickListener((event) {
    log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');

    log("Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  });

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    log('NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

    // Display Notification, preventDefault to not display
    event.preventDefault();
    event.notification.display();
    log(' onesignal ${event.notification.additionalData}');

    oneSignalData = event.notification.additionalData!;

    if (oneSignalData!['type'] == 'call_declined') {
      Provider.of<LiveStreamProvider>(navigatorKey.currentContext!,
              listen: false)
          .isCallDeclinedFunc();
    } else if (oneSignalData!['type'] == 'liveRequestAccepted') {
      Provider.of<LiveStreamProvider>(navigatorKey.currentContext!,
              listen: false)
          .liveRequestAccepted();
    } else if (oneSignalData!['type'] == 'video_call' ||
        oneSignalData!['type'] == 'audio_call') {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'call_channel',
            title: 'Incoming Call',
            body: '${oneSignalData!['username'] ?? ''} is calling...',
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: oneSignalData!['user_profile'] ?? '',
            actionType: ActionType.KeepOnTop,
            displayOnBackground: true,
            displayOnForeground: true,
            category: NotificationCategory.Call,
            duration: const Duration(seconds: 15),
            autoDismissible: true,
            wakeUpScreen: true),
        actionButtons: [
          NotificationActionButton(
              key: 'decline_call',
              label: 'Decline',
              actionType: ActionType.KeepOnTop),
          NotificationActionButton(
              key: 'accept_call',
              label: 'Accept',
              actionType: ActionType.KeepOnTop),
        ],
      );
    }

    int badgeCount = event.notification.additionalData?['badgeCount'] ?? 0;

    FlutterAppBadger.updateBadgeCount(badgeCount);

    log("Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  });

  OneSignal.InAppMessages.addClickListener((event) {
    log("In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}");
  });
  OneSignal.InAppMessages.addWillDisplayListener((event) {
    log("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addDidDisplayListener((event) {
    log("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addWillDismissListener((event) {
    log("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
  });
  OneSignal.InAppMessages.addDidDismissListener((event) {
    log("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
  });
}

String orderNumbers(String num1Str, String num2Str) {
  int num1 = int.parse(num1Str);
  int num2 = int.parse(num2Str);
  if (num1 < num2) {
    return '$num1$num2';
  } else {
    return '$num2$num1';
  }
}

Map<String, dynamic>? oneSignalData;

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'accept_call') {
      if (oneSignalData!['type'] == 'video_call') {
        Provider.of<LiveStreamProvider>(navigatorKey.currentContext!,
                listen: false)
            .generateAgoraToken(
                channelName:
                    "${orderNumbers(oneSignalData!['user_id'], getStringAsync('user_id'))}video")
            .then((value) {
          navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => VideoCallScreen(
                agoraToken: value.token,
                userAvatar: oneSignalData!['user_profile'],
                userName: oneSignalData!['username'],
                channelName:
                    "${orderNumbers(oneSignalData!['user_id'], getStringAsync('user_id'))}video"),
          ));
        });
      } else if (oneSignalData!['type'] == 'audio_call') {
        Provider.of<LiveStreamProvider>(navigatorKey.currentContext!,
                listen: false)
            .generateAgoraToken(
          channelName:
              "${orderNumbers(oneSignalData!['user_id'], getStringAsync('user_id'))}audio",
        )
            .then((value) {
          navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => AudioCallScreen(
              agoraToken: value.token,
              userAvatar: oneSignalData!['user_profile'],
              userName: oneSignalData!['username'],
              channelName:
                  "${orderNumbers(oneSignalData!['user_id'], getStringAsync('user_id'))}audio",
            ),
          ));
        });
      }
    } else if (receivedAction.buttonKeyPressed == 'decline_call') {
      var accessToken = getStringAsync("access_token");
      FormData form = FormData.fromMap({'user_id': oneSignalData!['user_id']});
      Response response = await dioService.dio.post(
        'decline-call',
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      log('User declined the call ${response.data}');
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            callType: oneSignalData!['type'],
            userImageUrl: oneSignalData!['user_profile'],
            userName: oneSignalData!['username'],
            userId: oneSignalData!['user_id'],
          ),
        ),
      );
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}
