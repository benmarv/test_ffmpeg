// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/CourseModel/course_data_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:http_parser/http_parser.dart';

class GetCourseApiProvider extends ChangeNotifier {
  bool loading = false;
  String currentCourseName = '';
  List<CourseModel> allCourses = [];
  List<CourseModel> searchedCourses = [];
  List<CourseModel> fetchedCourses = [];

  // Create an event using API
  Future createCourseApi(
      {required BuildContext context,
      courseimage,
      courseTitle,
      courseStartDate,
      courseEndDate,
      courseDescription,
      courseCategory,
      courseCountry,
      courseLevel,
      courseLanguage,
      courseAddress,
      amount,
      isPaid}) async {
    // Show a custom loading dialog while the event is being created
    try {
      customDialogueLoader(context: context);

      // Prepare the data to be sent in the API request
      Map<String, dynamic> mapData = {
        "cover": courseimage,
        "title": courseTitle,
        "start_date": courseStartDate,
        "end_date": courseEndDate,
        "description": courseDescription,
        "country": courseCountry,
        "category": courseCategory,
        "level": courseLevel,
        "language": courseLanguage,
        "address": courseAddress,
        "amount": amount,
        "is_paid": isPaid
      };

      // If a cover image is provided, attach it to the request
      if (courseimage != null) {
        String? mimeType1 = mime(courseimage);
        String mimee1 = mimeType1!.split('/')[0];
        String type1 = mimeType1.split('/')[1];
        log(mimee1);
        log(type1);
        mapData['cover'] = await MultipartFile.fromFile(courseimage,
            contentType: MediaType(mimee1, type1));
      }

      // Call the API to create the event
      dynamic res = await apiClient.callApiCiSocial(
          apiData: mapData, apiPath: "course/add");
      log("create event : ${res}");

      // Check if the response is valid and contains data
      if (res != null && res is Map && res.containsKey("code")) {
        if (res["code"] == "200") {
          // Show a success message
          toast(res['message'].toString(),
              bgColor: Colors.green, textColor: Colors.white);

          // Close the loading dialog
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (res["code"] == "400") {
          Navigator.pop(context);
          toast(res['message'].toString(),
              bgColor: Colors.red, textColor: Colors.white);
        } else {
          // Close the loading dialog and show an error message
          Navigator.pop(context);
        }
      } else {
        print("Invalid response format: $res");
      }
    } catch (e) {
      log("Error creating COurse: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCoursesList({
    required BuildContext context,
    String searchText = '',
    String? screenName,
    int? userId,
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      loading = true;
      notifyListeners();

      dynamic res = await apiClient.callApiCiSocial(
        apiPath: "course/all-courses",
        apiData: userId == null
            ? {
                'search_string': searchText,
                'offset': offset,
                'limit': limit,
              }
            : {
                'search_string': searchText,
                'user_id': userId,
                'offset': offset,
                'limit': limit,
              },
      );

      if (res["code"] == "200") {
        fetchedCourses = (res['data'] as List)
            .map((course) =>
                CourseModel.fromJson(course as Map<String, dynamic>))
            .toList();
        if (searchedCourses.isNotEmpty && fetchedCourses.isEmpty) {
          toast(
            'No more courses to fetch',
            bgColor: Colors.red,
            textColor: Colors.white,
          );
        }
        if (screenName == "allCourses") {
          if (offset == 0) {
            allCourses = fetchedCourses;
          } else {
            allCourses.addAll(fetchedCourses);
          }
        } else {
          if (offset == 0) {
            searchedCourses = fetchedCourses;
          } else {
            searchedCourses.addAll(fetchedCourses);
          }
        }
      } else if (res["code"] == "400") {
        toast(
          res['message'].toString(),
          bgColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        log("Unexpected response code: ${res["code"]}");
      }
    } catch (error) {
      print("Errorrr: $error");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future updateCourseApi(
      {required BuildContext context,
      courseId,
      courseimage,
      courseTitle,
      courseStartDate,
      courseEndDate,
      courseDescription,
      courseCategory,
      courseCountry,
      courseLevel,
      courseLanguage,
      courseAddress,
      amount,
      isPaid}) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> mapData = {
      "course_id": courseId,
      "cover": courseimage,
      "title": courseTitle,
      "start_date": courseStartDate,
      "end_date": courseEndDate,
      "description": courseDescription,
      "country": courseCountry,
      "category_id": courseCategory,
      "level": courseLevel,
      "language": courseLanguage,
      "address": courseAddress,
      "amount": amount,
      "is_paid": isPaid
    };

    if (courseimage != null) {
      String? mimeType1 = mime(courseimage);
      String mimee1 = mimeType1!.split('/')[0];
      String type1 = mimeType1.split('/')[1];
      log(mimee1);
      log(type1);
      mapData['cover'] = await MultipartFile.fromFile(courseimage,
          contentType: MediaType(mimee1, type1));
    }

    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "course/update");
    log("create event : ${res}");

    if (res["code"] == "200") {
      toast(res['message'].toString(),
          bgColor: Colors.green, textColor: Colors.white);

      Navigator.pop(context);
      Navigator.pop(context);
    } else if (res["code"] == "400") {
      Navigator.pop(context);

      Navigator.pop(context);
      toast(res['message'].toString(),
          bgColor: Colors.red, textColor: Colors.white);
    } else {
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<void> deletCourse(
      {required BuildContext context, required String id}) async {
    customDialogueLoader(context: context);
    Map<String, dynamic> data = {"course_id": id};
    var res = await apiClient.callApiCiSocial(
        apiData: data, apiPath: "course/delete");

    if (res["code"] == "200") {
      toast(res['message'].toString(),
          bgColor: Colors.green, textColor: Colors.white);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      fetchCoursesList(context: context, userId: id.toInt());
    } else if (res["code"] == "400") {
      toast(res['message'].toString(),
          bgColor: Colors.red, textColor: Colors.white);
    } else {
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<bool?> enrolledInCourse(
      {required BuildContext context, required String id}) async {
    Map<String, dynamic> data = {"course_id": id};
    var res =
        await apiClient.callApiCiSocial(apiData: data, apiPath: "course/apply");

    if (res["code"] == "200") {
      // isEnroled = true;
      toast(res['message'].toString());
    } else if (res['code'] == '400') {
      toast(res['message'].toString(),
          bgColor: const Color.fromARGB(255, 23, 131, 2),
          textColor: Colors.white);
      return true;
    } else {
      Navigator.pop(context);
    }
    notifyListeners();
    return null;
  }
}
