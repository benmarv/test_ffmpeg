import 'package:flutter/material.dart';
import 'package:link_on/controllers/withdraw/user_wallet_model.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/models/withdraw_history_model.dart';
import 'package:link_on/screens/wallet/wallet.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';


class WithdrawHistoryProvider extends ChangeNotifier {
  List<WithdrawHistory> withdrawhistory = [];
  bool checkData = false;
  bool isLoading = false;
  bool? checkUserData;
  Usr? getUserData;
  bool? isUserWalletDataLoaded;
  UserWallet? userWalletData;

  // Function to get user data.
  Future<void> getUserDataFunc(userid) async {
    dynamic res = await apiClient.get_user_data(userId: userid);
    if (res["code"] == '200') {
      getUserData = Usr.fromJson((res["data"]));
      checkUserData = true;
      notifyListeners();
    } else {
      toast('Error: ${res['message']}');
    }
  }

  // Function to get transaction history of user wallet.
  Future getHistory() async {
    withdrawhistory = [];
    checkData = false;
    isLoading = true;

    Map<String, dynamic> mapData = {
      "limit": 10,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: "withdraw-requset/list", apiData: mapData);
    if (res["code"] == '200') {
      withdrawhistory = List.from(res["data"]).map((item) {
        WithdrawHistory productsModle = WithdrawHistory.fromJson(item);
        return productsModle;
      }).toList();

      checkData = true;
      isLoading = false;
      notifyListeners();
    } else {
      checkData = true;
      notifyListeners();
      log("${res['message']}");
    }
  }

  // Function to get balance.
  Future getUserBlance({required BuildContext context}) async {
    isUserWalletDataLoaded = false;
    dynamic res = await apiClient.callApiCiSocialGetType(
        apiPath: "user-wallet", context: context);
    if (res["status"] == '200') {
      userWalletData = UserWallet.fromJson(res);
      isUserWalletDataLoaded = true;
      notifyListeners();
    } else {
      notifyListeners();
      log("${res['message']}");
    }
  }

  // Function to add withdraw request.
  Future requestWithdraw(context, mapData) async {
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: "withdraw-requset/create", apiData: mapData);

    if (res["status"] == '200') {
      getUserBlance(context: context);
      getHistory();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Wallet(),
        ),
      );
      toast('Withdrawal completed successfully.');
      // toast(res["message"]);
      notifyListeners();
    } else {
      notifyListeners();
      Navigator.pop(context);
      toast(res["message"]);
    }
  }
}
