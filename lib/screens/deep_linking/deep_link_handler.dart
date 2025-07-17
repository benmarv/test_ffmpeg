import 'package:app_links/app_links.dart';
import 'package:link_on/consts/routes.dart';
import 'package:nb_utils/nb_utils.dart';


class DeepLinkHandler {
  static Future<void> initDeepLinks() async {
    final AppLinks appLinks = AppLinks();

    try {
      final Uri? initialLink = await appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(
          initialLink,
        );
      }

      appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleDeepLink(
            uri,
          );
        }
      });
    } catch (e) {
      // Handle exception
    }
  }

  static void _handleDeepLink(
    Uri uri,
  ) {
    if (uri.queryParameters.containsKey("post_id")) {
      print(
          'deep linking _handledeeplinkksssssssssssssssssssssssssss ${uri.queryParameters['post_id']}');

      navigatorKey.currentState!.pushNamed(AppRoutes.postDetails,
          arguments: uri.queryParameters['post_id']);
    } else {
      // Get.off(NotificationScreen.route, arguments: uri.queryParameters);
    }
  }
}
