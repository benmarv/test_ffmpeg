import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class GetAllChatProvider extends ChangeNotifier {
  List<UserModelFriendandFollow> chatList = [];
  bool isLoading = false;

  // get all user chat list
  Future<void> getAllChat({offset}) async {
    chatList = [];
    isLoading = true;

    Map<String, dynamic> mapData = {
      'limit': 10,
    };
    if (offset != null) {
      mapData['offset'] = offset;
    }
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'chat/get-all-chats', apiData: mapData);
    if (res["status"] == '200') {
      List<UserModelFriendandFollow> tempChatList = [];
      tempChatList = List.from(res["data"]).map<UserModelFriendandFollow>((e) {
        return UserModelFriendandFollow.fromJson(e);
      }).toList();

      for (int i = 0; i < tempChatList.length; i++) {
        if (!chatList.any((user) => user.id == tempChatList[i].id)) {
          chatList.add(tempChatList[i]);
        }
      }
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      toast("Error: ${res['errors']['error_text']}");
    }
  }
}
