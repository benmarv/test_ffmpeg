// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/screens/create_post/live_stream_screen.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/liveStream_Provider/agora_token_model.dart';
import 'package:link_on/controllers/liveStream_Provider/live_users_model.dart';

class LiveStreamProvider extends ChangeNotifier {
  bool isCallDeclined = false;
  List<Message> liveChat = [];
  List<Message> giftsReceived = [];
  List<LiveHostRequest> liveHostRequests = [];

  void addMessageInLiveChat(Message newMessage) {
    liveChat.insert(0, newMessage);
    notifyListeners();
  }

  bool giftReceived = false;
  void addGiftReceived(Message newMessage) {
    giftsReceived = [];
    giftsReceived.insert(0, newMessage);
    giftReceived = true;
    log("gifts received : $giftsReceived");
    notifyListeners();
  }

  void removeGiftMessage() {
    giftReceived = false;
    giftsReceived = [];

    notifyListeners();
  }

  void hostLiveRequests(LiveHostRequest newMessage) {
    if (!liveHostRequests.any((post) => post.userId == newMessage.userId)) {
      liveHostRequests.insert(0, newMessage);
    }

    notifyListeners();
  }

  void removeHostLiveRequests(String userId) {
    liveHostRequests.removeWhere(
      (element) => element.userId == userId,
    );
    notifyListeners();
  }

  void emptyLiveRequests() {
    liveHostRequests.clear();
    notifyListeners();
  }

  int liveMemberCount = 0;

  void getLiveMemberCount(int memberCount) {
    liveMemberCount = memberCount - 1;
    notifyListeners();
  }

  void isCallDeclinedFunc() {
    isCallDeclined = true;
    notifyListeners();
  }

  bool liveRequestBool = false;

  void liveRequestAccepted() {
    liveRequestBool = true;
    notifyListeners();
  }

  void isCallDeclinedFalseFunc() {
    isCallDeclined = false;
    notifyListeners();
  }

  void stopLottieAnimation() {
    giftSended = false;
    notifyListeners();
  }

  // generate agora token
  Future<AgoraToken> generateAgoraToken({
    required String channelName,
  }) async {
    final bearer = getStringAsync("access_token");
    Map<String, dynamic> mapData = {
      'channel_name': channelName,
    };
    FormData form = FormData.fromMap(mapData);
    String url = 'generate-agoratoken';
    final response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );

    var decodedData = AgoraToken.fromJson(response.data);

    return decodedData;
  }

  Future<void> liveStreamRequestAccepted({
    required String userId,
  }) async {
    log('Live stream accepted api to user id : $userId');
    final bearer = getStringAsync("access_token");
    Map<String, dynamic> mapData = {
      'user_id': userId,
      'type': 'liveRequestAccepted'
    };
    FormData form = FormData.fromMap(mapData);
    String url = 'livestream-request';
    final response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );

    log('Live stream accepted api ${response.data}');
  }

  String? giftSelected;
  bool giftSended = false;

  // send gift
  Future<bool?> sendGift({
    required String hostUserId,
    required String giftId,
    required String giftUrl,
    required BuildContext context,
  }) async {
    // log('send gift api error : ${getStringAsync("user_id")}');

    log('Gift Url is : $giftUrl');

    final bearer = getStringAsync("access_token");
    Map<String, dynamic> mapData = {'user_id': hostUserId, 'gift_id': giftId};
    FormData form = FormData.fromMap(mapData);
    String url = 'send-gift';
    final response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );

    log('Response from send gift api : ${response.data}');

    if (response.data['code'] == 200) {
      // if (giftName == 'Rocket') {
      //   giftSelected = 'assets/images/rocket.json';
      // } else if (giftName == 'Diamond') {
      //   giftSelected = 'assets/images/diamond-lottie.json';
      // } else if (giftName == 'Lion') {
      //   giftSelected = 'assets/images/lion-running-lottie.json';
      // } else if (giftName == 'Whale') {
      //   giftSelected = 'assets/images/whale-lottie.json';
      // } else {
      //   giftSelected = 'assets/images/heart-lottie.json';
      // }
      toast('Gift Sent Successfully');
      giftSelected = giftUrl;
      giftSended = true;
      Navigator.pop(context);
      log('gift send is : $giftSelected');
      log('send gift api : ${response.data}');
      notifyListeners();
      return true;
    } else {
      toast(response.data["message"]);
      log('send gift api error : ${response.data}');
      return false;
    }
  }

  // go live
  Future<void> goLiveApi(
      {String? channelName,
      String? agoraAccessToken,
      String? type,
      String? toUserId}) async {
    final bearer = getStringAsync("access_token");

    log('value of channel name : $channelName');
    log('value of agora access token : $agoraAccessToken');
    log('value of type : $type');
    log('value of to user id : $toUserId');

    Map<String, dynamic> mapData = {
      'channel_name': channelName,
      "agora_access_token": agoraAccessToken,
      'type': type,
      "to_user_id": toUserId
    };

    FormData form = FormData.fromMap(mapData);

    String url = 'go-live';
    final res = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    log(res.toString());
  }

  bool isHostDataLoaded = false;
  List<LiveUsers> hostUserData = [];
  // get hosts
  Future<void> getHostsApi({
    String? channelName,
  }) async {
    hostUserData = [];
    final bearer = getStringAsync("access_token");
    isHostDataLoaded = true;
    Map<String, dynamic> mapData = {
      'channel_name': channelName,
    };

    FormData form = FormData.fromMap(mapData);

    String url = 'get-live-stream-userinfo';
    try {
      final res = await dioService.dio.post(
        url,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $bearer'}),
      );
      var data = res.data['data'];
      hostUserData = List.from(data).map((e) {
        return LiveUsers.fromJson(e);
      }).toList();
      isHostDataLoaded = false;

      log(res.toString());
      notifyListeners();
    } catch (e) {
      isHostDataLoaded = false;
      log('exception : $e');
    }
  }

  // ad member uid
  Future<void> addMemberUid(
      {String? channelName,
      int? agoraUid,
      String? userId,
      String? action}) async {
    final bearer = getStringAsync("access_token");

    Map<String, dynamic> mapData = {
      'channel_name': channelName,
      "agora_uid": agoraUid,
      "user_id": userId,
      'action': action,
    };

    print('add member user id data array : $mapData');
    FormData form = FormData.fromMap(mapData);

    String url = 'live-stream-action';
    final res = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    log('add member uid response : $res');
  }

  // ad live stream hosts uid
  Future<void> getLiveStreamHostsUid({
    String? channelName,
  }) async {
    final bearer = getStringAsync("access_token");

    Map<String, dynamic> mapData = {
      'channel_name': channelName,
    };

    FormData form = FormData.fromMap(mapData);

    String url = 'get-live-stream-multiusers';
    final res = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    log('add member uid response : $res');
  }

  // end live stream
  Future<void> endLiveStreamApi() async {
    final bearer = getStringAsync("access_token");

    String url = 'end-live-stream';
    final res = await dioService.dio.post(
      url,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    liveChat.clear();
    notifyListeners();

    log('app has live stream:  $res');
  }

  // get all live users
  List<LiveUsers> liveUserData = [];
  Future<void> getAllLiveUsers() async {
    final bearer = getStringAsync("access_token");
    String url = 'get-live-users';
    Map<String, dynamic> mapData = {
      'limit': 6,
    };

    FormData form = FormData.fromMap(mapData);

    final response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    if (response.data['status'] == 200) {
      var data = response.data['data'];
      liveUserData = List.from(data).map((e) {
        return LiveUsers.fromJson(e);
      }).toList();
    } else {
      log('something went wrong in get all live users');
    }

    notifyListeners();
  }

  // remove live user
  void removeLiveUser({required String userId}) {
    liveUserData.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}
