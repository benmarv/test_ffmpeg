import 'package:flutter/material.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/screens/pages/update_page.dart';
import 'package:link_on/screens/splash/splash.page.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/screens/auth/login/login.page.dart';
import 'package:link_on/screens/settings/settings.page.dart';
import 'package:link_on/screens/comments/comments.page.dart';
import 'package:link_on/screens/createstory/create_story.dart';
import 'package:link_on/screens/friend_unfriend/friend_tab.dart';
import 'package:link_on/screens/auth/register/register.page.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:link_on/screens/friend_unfriend/TABS/friends.dart';
import 'package:link_on/screens/onBoarding/onBoarding_screen.dart';
import 'package:link_on/screens/post_details/post_details.page.dart';
import 'package:link_on/screens/auth/forgot_password/forgot_password.page.dart';
import 'package:link_on/screens/settings_base_view/settings_base_view.page.dart';

Route<dynamic> generateRoute(settings) {
  switch (settings.name) {
    case AppRoutes.createStory:
      return MaterialPageRoute(
        builder: (context) => CreateStory(),
      );

    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => SplashPage());
    case AppRoutes.postDetails:
      var postid = settings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => PostDetailsPage(
                postid: postid,
                isProfilePost: false,
                index: 0,
                tempPost: false,
                isMainPosts: false,
              ));
    case AppRoutes.onboarding:
      return MaterialPageRoute(builder: (_) => OnboardingScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case AppRoutes.register:
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    case AppRoutes.forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
    case AppRoutes.tabs:
      return MaterialPageRoute(builder: (_) => const TabsPage());
    case AppRoutes.comments:
      var argumentsData = settings.arguments as CommentsPage;
      return MaterialPageRoute(
          builder: (_) => CommentsPage(
                isPostDetail: argumentsData.isPostDetail,
                isProfilePost: argumentsData.isProfilePost,
                isMainPost: argumentsData.isMainPost,
                isVideoScreen: argumentsData.isVideoScreen,
                postIndex: argumentsData.postIndex,
                post: argumentsData.post,
                postid: argumentsData.postid,
              ));

    case AppRoutes.profile:
      return MaterialPageRoute(
        builder: (_) => ProfileTab(
          userId: settings.arguments,
        ),
      );
    case AppRoutes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    case AppRoutes.friends:
      return MaterialPageRoute(
        builder: (context) => const Friends(),
      );
    case AppRoutes.createPost:
      var argumentsData = settings.arguments as CreatePostPage;
      return MaterialPageRoute(
          builder: (_) => CreatePostPage(
              groupId: argumentsData.groupId,
              pageId: argumentsData.pageId,
              val: argumentsData.val,
              flag: argumentsData.flag));
    case AppRoutes.settingsBase:
      return MaterialPageRoute(
        builder: (_) => SettingsBaseViewPage(
          baseView: settings.arguments,
        ),
      );
    case AppRoutes.updatePage:
      return MaterialPageRoute(
        builder: (_) => UpdatePage(
          pageData: settings.arguments,
        ),
      );
    case AppRoutes.friendsTab:
      return MaterialPageRoute(
        builder: (_) => const FriendTabs(),
      );
    case AppRoutes.imageDetail:
      var messagesAyrguments = settings.arguments as DetailScreen;
      return MaterialPageRoute(
          builder: (_) => DetailScreen(
                image: messagesAyrguments.image,
                withoutNetworkImage: messagesAyrguments.withoutNetworkImage,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  }
}
