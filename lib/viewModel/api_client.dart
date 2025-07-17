// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/LoaderProgress/create_post_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/sound/fav/favourite_music.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/screens/camera/session_manager.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:mime_type/mime_type.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/constants.dart';
import 'dart:io' show File, Platform, SocketException;
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

final ApiClient apiClient = ApiClient();

class ApiClient {
  // Step 2: Create a static instance of the class
  static final ApiClient _instance = ApiClient._internal();

  // Step 1: Make the constructor private
  ApiClient._internal();

  // Step 3: Provide a factory constructor to return the singleton instance
  factory ApiClient() {
    return _instance;
  }

  // HTTP client instance
  var client = http.Client();

// razor pay api
  Future<Map<String, dynamic>> razorPayApi(
      String amount, String recieptId) async {
    final razorPayKey = dotenv.get("RAZOR_KEY");
    final razorPaySecret = dotenv.get("RAZOR_SECRET");
    try {
      var auth =
          'Basic ${base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'))}';
      var headers = {'content-type': 'application/json', 'Authorization': auth};
      var request =
          http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'));
      request.body = json.encode({
        "amount": amount * 100, // Amount in smallest unit like in paise for INR
        "currency": "INR", //Currency
        "receipt": recieptId //Reciept Id
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      // Decode and log the response body if successful
      String responseBody = await response.stream.bytesToString();
      log("Response Body: $responseBody");
      log(response.reasonPhrase);
      log("${response.statusCode}");
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "body": jsonDecode(await response.stream.bytesToString())
        };
      } else {
        return {"status": "fail", "message": (response.reasonPhrase)};
      }
    } catch (e) {
      log("Something went wrong!!! $e");
    }
    return {};
  }

// Fetch a list of sounds
  Future<Sound> fetchSoundList() async {
    final response = await client.post(
      Uri.parse(Constants.fetchSoundList),
    );
    final responseJson = jsonDecode(response.body);
    // Log the sound data for debugging purposes
    log("sound data Is=>> $responseJson");
    return Sound.fromJson(responseJson);
  }

// add/remove favourite sound
  Future addRemoveFavSounds(String soundId) async {
    final bearer = getStringAsync('access_token');
    final response = await client.post(Uri.parse(Constants.addRemoveFavSounds),
        body: {'sound_id': soundId},
        headers: {Constants.authorization: 'Bearer $bearer'});
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

// Fetch a list of favorite sounds based on a keyword
  Future<FavouriteMusic> fetchSearchSoundList(String keyword) async {
    client = http.Client();
    SessionManager sessionManager = SessionManager();
    await sessionManager.initPref();
    final response = await client.post(
      Uri.parse(Constants.getSearchSoundList),
      body: {
        Constants.keyWord: keyword,
      },
    );
    final responseJson = jsonDecode(response.body);
    return FavouriteMusic.fromJson(responseJson);
  }

  Future<dynamic> registerUser(
      {date,
      email,
      username,
      password,
      confirmPassword,
      first,
      last,
      gender,
      String? timeZone}) async {
    try {
      var onesignalId = await OneSignal.User.pushSubscription.id;
      String deviceType = "";
      if (Platform.isAndroid) {
        deviceType = "Android";
      } else if (Platform.isIOS) {
        deviceType = "ios";
      }
      Map<String, dynamic> mapData = {
        'last_name': last,
        'first_name': first,
        'email': email,
        'username': username,
        'password': password,
        'password_confirm': confirmPassword,
        'gender': gender.toString(),
        'date_of_birth': date,
        "device_type": deviceType,
        "device_id": onesignalId ?? '0000',
        "timezone": timeZone,
      };
      FormData form = FormData.fromMap(mapData);

      Response response = await dioService.dio.post(
        'register',
        data: form,
      );
      log('Response of register api .. ${response.data['status'].toString()}');
      return response.data;
    } on DioException catch (e) {
      log('Error .. ${e.response?.data.toString()}');
      return e.response?.data;
    }
  }

  Future<dynamic> login(
      {required String email,
      required String password,
      model,
      lat,
      lon,
      String? timeZone}) async {
    var onesignalId = await OneSignal.User.pushSubscription.id;
    try {
      String deviceType = "";
      if (Platform.isAndroid) {
        deviceType = "Android";
      } else if (Platform.isIOS) {
        deviceType = "ios";
      }
      Map<String, dynamic> mapData = {
        'email': email,
        'password': password,
        "device_type": deviceType,
        'lat': lat,
        "lon": lon,
        "device_id": onesignalId ?? '0000',
        "device_model": model,
        "timezone": timeZone,
      };
      print('Time Zone is  $timeZone');
      print('device id $onesignalId');
      FormData form = FormData.fromMap(mapData);
      Response response = await dioService.dio.post('login', data: form);
      return response.data;
    } on DioException catch (e) {
      log('Error Login : ${e.response!.data}');
      return e.response!.data;
    }
  }

  Future<dynamic> reactionsApi({postId, reactionType}) async {
    try {
      log('ReactionType${reactionType.toString()}');
      var accessToken = getStringAsync("access_token");

      String? getReactionsUrl = "post/action";
      FormData form = FormData.fromMap({
        "action": "reaction",
        "post_id": postId,
        "reaction_type": reactionType
      });
      Response response = await dioService.dio.post(
        getReactionsUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      log('Errorrr ${e.message}');
      return e.response?.data;
    }
  }

  Future<dynamic> commentReplyApi({commentId, message}) async {
    try {
      var accessToken = getStringAsync("access_token");
      String? getCommentReplyUrl = "post/comments/add-reply";
      FormData form =
          FormData.fromMap({"comment_id": commentId, "comment": message});
      Response response = await dioService.dio.post(
        getCommentReplyUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> fetchReplyComment({commentId}) async {
    try {
      var accessToken = getStringAsync("access_token");
      String? getFetcCommentReplyUrl = "post/comments/get-replies";
      FormData form = FormData.fromMap({
        "comment_id": commentId,
      });
      Response response = await dioService.dio.post(
        getFetcCommentReplyUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deleteCommentReply({replyId}) async {
    try {
      var accessToken = getStringAsync("access_token");
      String? getDeleteCommentReplyUrl = "post/comments/delete-reply";
      FormData form = FormData.fromMap({
        "reply_id": replyId,
      });
      Response response = await dioService.dio.post(
        getDeleteCommentReplyUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> getMyPages() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      var accessToken = getStringAsync("access_token");

      Response response = await dioService.dio.get(
        'user-pages?limit=10',
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<Map<String, dynamic>> getPageData(postid, userid) async {
    try {
      var accessToken = getStringAsync("access_token");
      FormData form = FormData.fromMap({'page_id': postid, 'user_id': userid});
      Response response = await dioService.dio.post(
        'get-page-data',
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      print('get page data api${e.response!.data}');
      return e.response!.data;
    }
  }

  Future<dynamic> discoverPagelist({required int offset}) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      log('value of ${offset.toString()}');
      var accessToken = getStringAsync("access_token");
      String? url = "get-all-pages?offset=$offset&limit=10";
      Response response = await dioService.dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> getlikepages({userid, required int offset}) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      var accessToken = getStringAsync("access_token");
      FormData form =
          FormData.fromMap({'user_id': userid, 'offset': offset, 'limit': 10});
      Response response = await dioService.dio.post(
        'get-liked-pages',
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updateGroupDataApi(
      {groupId,
      category,
      subCategory,
      groupTitle,
      about,
      File? cover,
      privicy}) async {
    try {
      var accessToken = getStringAsync("access_token");

      String? updateGroupDataApiUrl = "update-group";

      Map<String, dynamic> map = {"group_id": groupId};
      if (category != null) {
        map["category"] = category;
      }
      if (subCategory != null) {
        map["sub_category"] = subCategory;
      }
      if (groupTitle != null) {
        map["group_title"] = groupTitle;
      }
      if (about != null) {
        map["about_group"] = about;
      }
      if (cover != null) {
        String? mimeType = mime(cover.path);
        String mimee = mimeType!.split('/')[0];
        String type = mimeType.split('/')[1];
        map["cover"] = await MultipartFile.fromFile(cover.path,
            contentType: MediaType(mimee, type));
      }
      if (privicy != null) {
        map["privacy"] = privicy;
      }
      FormData form = FormData.fromMap(map);
      Response response = await dioService.dio.post(
        updateGroupDataApiUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      print('getgroupdata  api${e.response!.data}');
      return e.response?.data;
    }
  }

  Future<dynamic> joinGroupApi({groupId}) async {
    try {
      var accessToken = getStringAsync("access_token");
      String joinGroupApiUrl = "join-group";
      FormData form = FormData.fromMap({
        "group_id": groupId,
      });
      Response response = await dioService.dio.post(
        joinGroupApiUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      // toast(response.data['message'].toString());

      return response.data;
    } on DioException catch (e) {
      print('getgroupdata  api${e.response!.data}');
      return e.response?.data;
    }
  }

  Future<dynamic> get_user_data({userId}) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      var userid = userId ?? getStringAsync("user_id");

      var accessToken = getStringAsync("access_token");
      log("get user data access token : $accessToken");

      Response response = await dioService.dio.get('get-user-profile',
          options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
          queryParameters: {'user_id': userid});
      log("get user data : ${response.statusCode}");
      log("get user data : ${response.data}");
      log("get user data : ${response.realUri}");
      log("get user data : ${response.headers}");
      log("get user data : ${response.extra}");
      log("get user data : ${response.requestOptions}");
      return response.data;
    } on SocketException {
      return {"internet": true};
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> likeComment({commentid, postId}) async {
    try {
      var accessToken = getStringAsync("access_token");
      var likeUrl = "post/comments/like";
      FormData form =
          FormData.fromMap({'comment_id': commentid, 'post_id': postId});
      Response response = await dioService.dio.post(likeUrl,
          data: form,
          options: Options(headers: {"Authorization": 'Bearer $accessToken'}));
      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> notificationApi({int? offset}) async {
    try {
      log('Response of Notification api Notification offset ${offset.toString()}');
      var accessToken = getStringAsync("access_token");
      var endPoints = 'notifications/user-old-notification';
      var notifcatonUrl = "$endPoints";
      Map<String, dynamic> map = {'limit': 10};
      if (offset != null) {
        map['offset'] = offset.toString();
      }
      FormData form = FormData.fromMap(map);
      Response response = await dioService.dio.post(
        notifcatonUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: form,
      );
      log('Response of Notification api .... ${response.data['data']}');
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> markAllNotificationAsRead() async {
    try {
      var accessToken = getStringAsync("access_token");
      var url = "notifications/mark-all-as-read";
      Response response = await dioService.dio.post(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> markNotificationAsRead(int id, BuildContext context) async {
    try {
      var accessToken = getStringAsync("access_token");
      var url = "notifications/mark-as-read";
      Map<String, dynamic> map = {'notification_id': id};
      FormData form = FormData.fromMap(map);
      Response response = await dioService.dio.post(url,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: form);
      log('Response of markNotificationAsRead ${response.data.toString()}');

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> deleteNotificationById(int id) async {
    try {
      var accessToken = getStringAsync("access_token");
      var url = "notifications/delete-notification";
      Map<String, dynamic> map = {'notification_id': id};
      FormData form = FormData.fromMap(map);
      Response response = await dioService.dio.post(url,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
          data: form);
      log('Response of Notification Deleted ${response.data.toString()}');
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<Map<String, dynamic>> save_post({postid}) async {
    try {
      var accessToken = getStringAsync("access_token");
      FormData form = FormData.fromMap({
        'action': 'save',
        'post_id': postid,
      });
      Response response = await dioService.dio.post(
        'post/action',
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> commentDisableApi({postId}) async {
    try {
      var accessToken = getStringAsync("access_token");

      String commentsDisableUrl = "post/action";
      FormData form =
          FormData.fromMap({"post_id": postId, "action": "disablecomments"});
      Response response = await dioService.dio.post(
        commentsDisableUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> getUserstoriesApi() async {
    try {
      var accessToken = getStringAsync("access_token");

      String? getUserstoriesUrl = "story/get-stories";

      Response response = await dioService.dio.post(
        getUserstoriesUrl,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> deleteStoryApi({required storyId}) async {
    try {
      var accessToken = getStringAsync("access_token");

      String? deleteStoryUrl = "story/delete-story";
      FormData form = FormData.fromMap({
        "story_id": storyId,
      });
      Response response = await dioService.dio.post(
        deleteStoryUrl,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> messagesApi({recipientId, offset}) async {
    try {
      Map<String, dynamic> mapData = {"to_id": recipientId, 'limit': 15};
      if (offset != null) {
        mapData['offset'] = offset;
      }
      // log('Offset of messages list is ${offset.toString()}');
      var accessToken = getStringAsync("access_token");
      String? messagesApiUrl = "chat/get-user-chat";
      FormData form = FormData.fromMap(mapData);
      Response response = await dioService.dio.post(
        messagesApiUrl,
        data: form,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> sendMessageApi(
      {required String userId,
      String? text,
      String? mediaType,
      File? media,
      File? thumbnail}) async {
    try {
      if ((text == null || text.isEmpty) && media == null) {
        throw ArgumentError('Either text or media must be provided');
      }

      var accessToken = getStringAsync("access_token");
      log('ToUserId.....${userId.toString()}');
      String sendMessageApiUrl = "chat/send-message";

      // Create the FormData
      FormData form = FormData.fromMap(
        {
          "to_id": userId,
          if (text != null && text.isNotEmpty) "message": text,
          if (mediaType != null && media != null) "media_type": mediaType,
          if (media != null)
            "media": await MultipartFile.fromFile(media.path,
                filename: media.path.split('/').last),
          if (media != null)
            "thumbnail": await MultipartFile.fromFile(thumbnail!.path,
                filename: thumbnail.path.split('/').last),
        },
      );

      // Send the POST request
      Response response = await dioService.dio.post(
        sendMessageApiUrl,
        data: form,
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    } on ArgumentError catch (e) {
      return {'error': e.message};
    }
  }

  Future<dynamic> deleteMessageApi({messageId}) async {
    try {
      var accessToken = getStringAsync("access_token");
      String? deleteMessageUrl = "chat/delete-message";
      FormData form = FormData.fromMap({"message_id": messageId});
      Response response = await dioService.dio.post(
        deleteMessageUrl,
        data: form,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> deleteCallHistory() async {
    try {
      var accessToken = getStringAsync("access_token");
      String? deleteMessageUrl = "delete-call-history";
      Response response = await dioService.dio.post(
        deleteMessageUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      return e.response?.data;
    }
  }

  Future<dynamic> callApiCiSocial(
      {apiPath, apiData, CancelToken? cancelToken}) async {
    try {
      log('Api Path is $apiPath');
      log('Api Data is $apiData');

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      var accessToken = getStringAsync("access_token");

      String url = AppConfig.apiUrl + apiPath;

      FormData? form;

      if (apiData != null && apiData.isNotEmpty) {
        form = FormData.fromMap(apiData);
      }
      Response response = await dioService.dio.post(
        url,
        data: form,
        options: Options(
          headers: {"Authorization": 'Bearer $accessToken'},
        ),
        cancelToken: cancelToken ?? Constants.cancelToken,
        onReceiveProgress: (count, total) {
          Constants.cancelToken.requestOptions!.onReceiveProgress;
          var upload = ((count / total) * 100);

          navigatorKey.currentContext!
              .read<CreatePostLoader>()
              .sendingProgress = upload.floor();
        },
        onSendProgress: (count, total) {
          var upload = (count / total * 100);

          navigatorKey.currentContext!
              .read<CreatePostLoader>()
              .sendingProgress = upload.floor();
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      log("error: ${e.type}");

      Map<String, dynamic> tempMap = {};
      if (e.type == DioExceptionType.unknown) {
        tempMap[Constants.noInternet] = Constants.noInternet;
        return tempMap;
      }
      if (e.type == DioExceptionType.badResponse) {
        toast("Something went wrong");
        tempMap['error'] = "Something went wrong";
        return tempMap;
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        toast("Connection time out");
        tempMap[Constants.timeOutConnection] = Constants.timeOutConnection;
        return tempMap;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        tempMap[Constants.timeOutConnection] = Constants.timeOutConnection;
        toast("Connection time out");
        return tempMap;
      }
      return e.response?.data;
    }
  }

  Future<dynamic> callApiCiSocialGetType(
      {apiPath,
      CancelToken? cancelToken,
      required BuildContext context}) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        toast("Check your internet connection"); // Show a toast message
        return null; // Return early
      }
      var accessToken = getStringAsync("access_token");
      String url = AppConfig.apiUrl + apiPath;

      Response response = await dioService.dio.get(
        url,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
        cancelToken: cancelToken ?? Constants.cancelToken,
        onReceiveProgress: (count, total) {
          Constants.cancelToken.requestOptions!.onReceiveProgress;
          var upload = ((count / total) * 100);
          navigatorKey.currentContext!
              .read<CreatePostLoader>()
              .sendingProgress = upload.floor();
        },
      );
      if (response.data.containsKey("errors")) {
        if (response.data["errors"]["error_text"] == Constants.invalidToken) {
          await removeKey("access_token");
          await removeKey("userData");
          final provider =
              Provider.of<GreetingsProvider>(context, listen: false);
          provider.setCurrentTabIndex(index: 0);
          Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
              AppRoutes.login, (Route<dynamic> route) => false);
          return;
        }
      }
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('call api status is not 200 $url');

        return null;
      }
    } on DioException catch (e) {
      Map<String, dynamic> tempMap = {};
      if (e.type == DioExceptionType.unknown) {
        tempMap[Constants.noInternet] = Constants.noInternet;
        return tempMap;
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        toast("Connection time out");
        tempMap[Constants.timeOutConnection] = Constants.timeOutConnection;
        return tempMap;
      } else if (e.type == DioExceptionType.receiveTimeout) {
        tempMap[Constants.timeOutConnection] = Constants.timeOutConnection;
        toast("Connection time out");
        return tempMap;
      }
      return e.response?.data;
    }
  }
}
