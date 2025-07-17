import 'package:flutter/material.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../viewModel/api_client.dart';

class PokeProvider extends ChangeNotifier {
  List<Usr> getPokeList = [];
  bool isLoading = false;

  Future<void> getPokeUser({
    required context,
    String? userId, // Your user ID
    int? pokeBack,
    int offset = 0,
    int limit = 5,
  }) async {
    try {
      isLoading = true;
      Map<String, dynamic> data = {
        "user_id": userId,
        "poke_back": pokeBack,
        'offset': offset,
        'limit': limit,
      };
      var res =
          await apiClient.callApiCiSocial(apiData: data, apiPath: "get-pokes");
      if (res["code"] == 200) {
        List<Usr> newPokeList = (res['data'] as List)
            .map((poke) => Usr.fromJson(poke as Map<String, dynamic>))
            .where((poke) {
          return poke.id != userId;
        }).toList();
        getPokeList.addAll(
          newPokeList.where((newItem) => !getPokeList
              .any((existingItem) => existingItem.id == newItem.id)),
        );
        toast(res['message']);
      } else if (res["code"] == 400) {
        toast(
          res['message'].toString(),
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      log("Error is $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> pokeUser({
    required context,
    String? userId,
    int? pokeBack,
  }) async {
    bool isPokeSuccess = false;
    try {
      isLoading = true;
      Map<String, dynamic> data = {
        "user_id": userId,
        "poke_back": pokeBack,
      };
      var res =
          await apiClient.callApiCiSocial(apiData: data, apiPath: "poke-user");
      if (res["code"] == "200") {
        removePokeFromList(userId);
        toast(res['message']);
        isPokeSuccess = true;
      } else if (res["code"] == "400") {
        toast(
          res['message'].toString(),
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      log("Error is $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return isPokeSuccess;
  }

  void removePokeFromList(String? userId) {
    getPokeList.removeWhere((poke) {
      return poke.id == userId;
    });
    notifyListeners();
  }

  
}
