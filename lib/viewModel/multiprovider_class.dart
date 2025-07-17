import 'package:link_on/controllers/CommentsProvider/comment_provider2.dart';
import 'package:link_on/controllers/CommentsProvider/main_comments.dart';
import 'package:link_on/controllers/CourseProviderClass/get_course_api_provider.dart';
import 'package:link_on/controllers/EventsProvider/get_event_api_provider.dart';
import 'package:link_on/controllers/Follower/follow_request_provider.dart';
import 'package:link_on/controllers/Follower/friend_suggestions_Provider.dart';
import 'package:link_on/controllers/GroupsProvider/user_joined_groups.dart';
import 'package:link_on/controllers/LoaderProgress/create_post_loader.dart';
import 'package:link_on/controllers/LoaderProgress/create_story_progress.dart';
import 'package:link_on/controllers/MessagesProvider/get_messages_api.dart';
import 'package:link_on/controllers/PageProvider/delet_page.dart';
import 'package:link_on/controllers/PageProvider/like_page.dart';
import 'package:link_on/controllers/PageProvider/my_pages.dart';
import 'package:link_on/controllers/PageProvider/update_page_data_provider.dart';
import 'package:link_on/controllers/ReportActionProvider/report_provider.dart';
import 'package:link_on/controllers/SavePostProvider/save_post_provider.dart';
import 'package:link_on/controllers/advertisement_controller/advertisement_controller.dart';
import 'package:link_on/controllers/auth/auth_provider.dart';
import 'package:link_on/controllers/block_user_provider/block_user_provier.dart';
import 'package:link_on/controllers/blogsProvider/blog_provider.dart';
import 'package:link_on/controllers/common_things_provider/common_things_provider.dart';
import 'package:link_on/controllers/donner_provider/donner_provider.dart';
import 'package:link_on/controllers/explore_people_provider/explore_people_provider.dart';
import 'package:link_on/controllers/gamesProvider/game_provider.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_posts_videos.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_video.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_video_data.dart';
import 'package:link_on/controllers/jobsProvider/joblist_provider.dart';
import 'package:link_on/controllers/mention_provider/mention_provider.dart';
import 'package:link_on/controllers/moviesProvider/movie_provider.dart';
import 'package:link_on/controllers/filters_provider.dart';
import 'package:link_on/controllers/my_loading.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/postProvider/postdetail_provider.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';
import 'package:link_on/controllers/session_provider/sessionprovider.dart';
import 'package:link_on/controllers/video_provider.dart';
import 'package:link_on/controllers/videolike/video_like_provider.dart';
import 'package:link_on/screens/bloodDonation/blood_donation_provider.dart';
import 'package:link_on/screens/openai/chatbot/chat_controller.dart';
import 'package:link_on/screens/openai/openai_controller.dart';
import 'package:link_on/screens/reactionlist/reaction_list_controller.dart';
import 'package:link_on/screens/tabs/explore/video_provider.dart';
import 'package:link_on/screens/wallet/payment_service_provider.dart';
import 'package:link_on/screens/web3/web3_provider.dart';
import 'package:link_on/screens/spaces/spaces_provider/spaces_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:link_on/controllers/Follower/following_provider.dart';
import 'package:link_on/controllers/FriendProvider/friend_followe_provider.dart';
import 'package:link_on/controllers/FriendProvider/friend_request_provider.dart';
import 'package:link_on/controllers/FriendProvider/friends_suggestions_Provider.dart';
import 'package:link_on/controllers/FriendProvider/friends_provider.dart';
import 'package:link_on/controllers/GroupsProvider/add_member_provider.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/controllers/chats_provider/get_all_chats.dart';
import 'package:link_on/controllers/jobsProvider/myjobs_provider.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/controllers/theme_controller.dart';
import 'package:link_on/controllers/withdraw/withdraw_history_provider.dart';
import 'package:link_on/screens/NearbyFriends/nearby_friends_provider.dart';
import 'package:link_on/screens/search/search_page_provider.dart';
import 'package:link_on/screens/tabs/profile/notifications/notification_provider.dart';

import '../screens/PokeScreens/poke_provider.dart';

class MultiProviderClass {
  static List<SingleChildWidget> get providersList => [
        ChangeNotifierProvider(create: (context) => PaymentServiceProvider()),
        ChangeNotifierProvider(create: (context) => Web3Provider()),
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => ImageController()),
        ChangeNotifierProvider(create: (context) => ExplorePeopleProvider()),
        ChangeNotifierProvider(create: (context) => UpdatePageDataProvider()),
        ChangeNotifierProvider(create: (context) => FiltersProvider()),
        ChangeNotifierProvider(create: (context) => BloodDonationProvider()),
        ChangeNotifierProvider(create: (context) => GetAllChatProvider()),
        ChangeNotifierProvider(create: (context) => VideoPlayerProvider()),
        ChangeNotifierProvider(create: (context) => ReactionListController()),
        ChangeNotifierProvider(create: (context) => SpaceProvider()),
        ChangeNotifierProvider(create: (context) => MoviesProvider()),
        ChangeNotifierProvider(create: (context) => BlogsProvider()),
        ChangeNotifierProvider(create: (context) => GamesProvider()),
        ChangeNotifierProvider(create: (context) => MentionProvider()),
        ChangeNotifierProvider(create: (context) => AdvertisementController()),
        ChangeNotifierProvider(create: (context) => BlockUserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeChange()),
        ChangeNotifierProvider(create: (context) => LiveStreamProvider()),
        ChangeNotifierProvider(create: (context) => NearByProvider()),
        ChangeNotifierProvider(create: (context) => GreetingsProvider()),
        ChangeNotifierProvider(create: (context) => FriendsFollowingProvider()),
        ChangeNotifierProvider(
            create: (context) => FriendFollowRequestProvider()),
        ChangeNotifierProvider(
            create: (context) => FriendFriendSuggestProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvier()),
        ChangeNotifierProvider(create: (context) => FriendFollower()),
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => AddMemberGroup()),
        ChangeNotifierProvider(create: (context) => GroupsProvider()),
        ChangeNotifierProvider(create: (context) => CreatePostLoader()),
        ChangeNotifierProvider(create: (context) => VideosLikeProvider()),
        ChangeNotifierProvider(create: (context) => CreatStoryProgress()),
        ChangeNotifierProvider(create: (context) => GetMessagesApiprovider()),
        ChangeNotifierProvider(create: (context) => GetUserStoryProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => RandomVideoProvider()),
        ChangeNotifierProvider(create: (context) => GetEventApiProvider()),
        ChangeNotifierProvider(create: (context) => UserJoinedGroups()),
        ChangeNotifierProvider(create: (context) => MyJobList()),
        ChangeNotifierProvider(create: (context) => DeletePageProvider()),
        ChangeNotifierProvider(create: (context) => LikePageProvider()),
        ChangeNotifierProvider(create: (context) => MyPagesProvider()),
        ChangeNotifierProvider(create: (context) => ReportActionpProvider()),
        ChangeNotifierProvider(create: (context) => FollowingProvider()),
        ChangeNotifierProvider(create: (context) => GetProductProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => FollowRequestProvider()),
        ChangeNotifierProvider(
            create: (context) => IntializeVideoDataProvider()),
        ChangeNotifierProvider(create: (context) => SaveProvider()),
        ChangeNotifierProvider(create: (context) => JobListProvider()),
        ChangeNotifierProvider(create: (context) => FriendSuggestProvider()),
        ChangeNotifierProvider(create: (context) => InitializePostsVideos()),
        ChangeNotifierProvider(create: (context) => InitializeVideoData()),
        ChangeNotifierProvider(
            create: (context) => InitializePostVideoProvider()),
        ChangeNotifierProvider(create: (context) => PostComments2()),
        ChangeNotifierProvider(create: (context) => ProfilePostsProvider()),
        ChangeNotifierProvider(create: (context) => PostProviderTemp()),
        ChangeNotifierProvider(create: (context) => PostDetailProvider()),
        ChangeNotifierProvider(create: (context) => MainCommentsProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WithdrawHistoryProvider()),
        ChangeNotifierProvider(create: (context) => MyLoading()),
        ChangeNotifierProvider(create: (context) => GetCourseApiProvider()),
        ChangeNotifierProvider(create: (context) => PokeProvider()),
        ChangeNotifierProvider(create: (context) => DonnersProvider()),
        ChangeNotifierProvider(create: (context) => CommonThingsProvider())
      ];
}
