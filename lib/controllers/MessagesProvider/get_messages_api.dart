import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/MessagesProvider/call_history_model.dart';
import 'package:link_on/models/message_model.dart';
import 'package:link_on/viewModel/api_client.dart';

class GetMessagesApiprovider extends ChangeNotifier {
  bool loading = false;
  bool isGoBack = true;
  List<MessageModel> messageModelList = [];
  bool get getGoBackValue {
    notifyListeners();
    return isGoBack;
  }

  setGoBackValue(bool v) {
    isGoBack = v;
    notifyListeners();
  }

  Future<void> messages({recipientId, offset, bool? fromAgora}) async {
    loading = true;
    dynamic res =
        await apiClient.messagesApi(recipientId: recipientId, offset: offset);

    if (res["status"] == 'success') {
      if (fromAgora!) {
        // Clear the messageModelList before adding new messages
        messageModelList.clear();
      }

      List<MessageModel> tempList = List.from(res["data"]).map<MessageModel>(
        (e) {
          MessageModel modelData = MessageModel.fromJson(e);
          return modelData;
        },
      ).toList();

      messageModelList.addAll(tempList);
      loading = false;
      if (tempList.isEmpty) {
        log('No more chat to show');
      }
      notifyListeners();
    } else {
      messageModelList = [];
      loading = false;
      notifyListeners();
    }
  }

  List<CallHistory> callHistoryData = [];
  Future<void> getCallHistoryApi({offset, context}) async {
    Map<String, dynamic> mapData = {
      "limit": 15,
    };
    if (offset != null) {
      mapData['offset'] = offset.toString();
    }
    loading = true;

    try {
      var accessToken = getStringAsync("access_token");
      String? url = "get-call-history";
      FormData form = FormData.fromMap(mapData);
      Response response = await dioService.dio.post(
        url,
        data: form,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      log("call history : ${response.data}");
      if (response.data['code'] == 200) {
        List<CallHistory> tempList = List.from(response.data['data']).map((e) {
          return CallHistory.fromJson(e);
        }).toList();

        callHistoryData.addAll(tempList);
        loading = false;
      } else {
        loading = false;
      }
    } on DioException catch (e) {
      return e.response?.data;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> sendMessage(
      {userId, text, media_type, File? media, File? thumbnail}) async {
    // log('Thumnail path is 2 ${thumbnail!.path}');

    dynamic res;
    if (media_type != null) {
      res = await apiClient.sendMessageApi(
          userId: userId,
          mediaType: media_type,
          media: media,
          thumbnail: thumbnail);

      log('Response of send Message Api is ${res['data']}');
    } else {
      res = await apiClient.sendMessageApi(userId: userId, text: text);
    }

    if (res["status"] == 'success') {
      MessageModel modelDataAdd = MessageModel.fromJson(res["data"]);
      // Insert the new message at the beginning of the list

      messageModelList.insert(0, modelDataAdd);
      setMessageList(value: modelDataAdd);
      notifyListeners();
    } else {
      toast(res['message']);
    }
  }

  Future deleteMessageData({messageId, index}) async {
    dynamic res = await apiClient.deleteMessageApi(messageId: messageId);
    toast(res['message'], print: true);

    if (res["status"] == 'success') {
      toast(res['message'], print: true);
      messageModelList.removeAt(index);
      notifyListeners();
    } else {}
  }

// A list to store message models
  List<MessageModel> messageModelProviderList = [];
// Function to add a message to the list
  void setMessageList({value}) {
    // Add the provided value (message) to the list
    messageModelProviderList.add(value);
    // Notify the listeners that the data has changed
    notifyListeners();
  }

// Getter to access the list of message models
  List<MessageModel> get getMessagesList => messageModelProviderList;

  Future<void> deleteCallHistory() async {
    var res = await apiClient.deleteCallHistory();

    log('Response is ${res}');

    if (res['code'] == '200') {
      callHistoryData.clear();
      getCallHistoryApi();
      notifyListeners();
    } else {}
  }
}
