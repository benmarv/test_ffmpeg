import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/filters_model.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';

class FiltersProvider extends ChangeNotifier {
  bool isLoading = false;

  List<DeepFilters> allFilters = [];
  // get AR Filters
  Future<void> getDeepArFilters({int? offset}) async {
    final bearer = getStringAsync("access_token");
    Map<String, dynamic> mapData = {
      "limit": 25,
    };
    if (offset != null) {
      mapData['offset'] = offset.toString();
    }
    List<DeepFilters> tempList = [];

    isLoading = true;

    FormData form = FormData.fromMap(mapData);
    String url = 'get-filters';
    final response = await dioService.dio.post(
      url,
      data: form,
      options: Options(headers: {"Authorization": 'Bearer $bearer'}),
    );
    log('filters response : ${response.data}');
    if (response.data['code'] == '200') {
      tempList = List.from(response.data['data']).map(
        (e) {
          return DeepFilters.fromJson(e);
        },
      ).toList();
      for (int i = 0; i < tempList.length; i++) {
        if (!allFilters.any((element) => element.id == tempList[i].id)) {
          allFilters.add(tempList[i]);
        }
      }
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      log('Error : ${response.data}');
      notifyListeners();
    }
  }
}
