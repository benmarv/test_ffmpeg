// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/notifcation_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:provider/provider.dart';

class NotificationProvier extends ChangeNotifier {
  List<NotificationModel> notificationList = [];
  bool isLoading = false;
  deleteNotificationByIndex(int i) {
    notificationList.removeAt(i);
    notifyListeners();
  }

  Future<void> notficationDetailApi({int? offset, bool? isMarkAsRead}) async {
    isLoading = false;
    if (isMarkAsRead == true) {
      notificationList.clear();
    }
    dynamic res = await apiClient.notificationApi(offset: offset);
    if (res['code'] == "200") {
      log('Data...........${res['data']}');
      var decodedData = res;
      List productsData = decodedData["data"];
      List<NotificationModel> tempList =
          List.from(productsData).map<NotificationModel>((post) {
        return NotificationModel.fromJson(post);
      }).toList();
      notificationList.addAll(tempList);
      notifyListeners();
      if (tempList.isEmpty) {
        toast('No notifications to show');
      }
      if (notificationList.isNotEmpty) {
        await setValue("notificationId", int.parse(notificationList[0].id!));
      }
      isLoading = true;
    } else {}
    notifyListeners();
  }

  Future<void> updateNotificationStatus(BuildContext context) async {
    dynamic res = await apiClient.markAllNotificationAsRead();
    if (res['code'] == "200") {
      log(res['message']);
      toast(res['message']);
      Provider.of<PostProvider>(context, listen: false).markAllAsRead();
    } else {
      toast(res['message']);
    }
    notifyListeners();
  }
}
