import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';

class ExplorePeopleProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Usr> allAvailableHangoutUsers = [];

  // get all available hangout user's
  Future getAllAvailableHangoutUsers() async {
    try {
      isLoading = true;
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
      isLoading = false;

      if (response.data['code'] == 200) {
        allAvailableHangoutUsers = List.from(response.data['data'])
            .map((e) => Usr.fromJson(e))
            .toList();
      } else {
        log('Error : ${response.data['message']}');
      }
    } catch (e) {
      log('Error : $e');
    }
    notifyListeners();
  }

  // action on user's profile
  Future swipeAction({required String userId}) async {
    try {
      final bearer = getStringAsync("access_token");
      Map<String, dynamic> mapData = {
        'user_id': userId,
        'channel_name': channelName,
      };
      FormData form = FormData.fromMap(mapData);
      String url = 'generate-agoratoken';
      final response = await dioService.dio.post(
        url,
        data: form,
        options: Options(headers: {"Authorization": 'Bearer $bearer'}),
      );

      log('swipe action response : ${response.data}');
    } catch (e) {
      log('Error : $e');
    }
  }
}
