// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/constants.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/models/jobs.dart';
import 'package:link_on/models/searchjob_model.dart';
import 'package:link_on/screens/jobs/jobs.dart';
import 'dart:developer' as dev;

class JobListProvider extends ChangeNotifier {
  String currentJobTab = ""; // Variable to store the current job tab
  bool loading = false; // Flag indicating whether data is being loaded
  String pageid = ""; // Variable to store a page identifier

  final List<Jobs> _joblist = []; // List of all jobs
  final List<Jobs> _myjoblist =
      []; // List of jobs specific to the "My Jobs" tab
  final List<SearchJobs> serchlist = []; // List of jobs for searching

  set setScreenName(String value) {
    // Setter to change the current job tab
    currentJobTab = value; // Update the current job tab with the new value
    notifyListeners(); // Notify listeners that the tab has changed
  }

  Future<void> searchjob({
    String? afterPostId,
    String? keyword,
    String? jobType,
    // String? pageid,
  }) async {
    print("jobTypeeee :$jobType and keyword id :$keyword");
    // Cancel any ongoing requests and create a new cancel token
    Constants.cancelToken.cancel();
    Constants.cancelToken = CancelToken();

    // Indicates that data loading is in progress
    loadData(true);

    // Create a map to store the request data
    Map<String, dynamic> mapData = {
      // "server_key": Constants.serverKey,
      "limit": 10,
    };

    if (afterPostId != null) {
      mapData["offset"] = afterPostId;
    } else {
      makeListEmpty();
    }

    if (keyword != null) {
      mapData['title'] = keyword;
    }
    if (jobType != null) {
      mapData['type'] = jobType == 'full_time'
          ? 'full_time'
          : jobType == 'part_time'
              ? 'part_time'
              : jobType == 'contract'
                  ? 'contract'
                  : jobType == 'internship'
                      ? 'internship'
                      : 'volunteer';
    }
    // }

    // Make an API call to fetch job data
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'search-job', apiData: mapData);

    if (res["code"] == '200') {
      var data = res['data'];
      loadData(false);
      notifyListeners();
      List<SearchJobs> temList = List.from(data).map<SearchJobs>((data) {
        return SearchJobs.fromJson(data);
      }).toList();
      serchlist.addAll(temList);

      // Data loading is complete
      loadData(false);
      notifyListeners();
    } else {
      // Data loading failed, display an error message
      loadData(false);
      notifyListeners();
    }
  }

// Create a job or update an existing job
  Future<void> createjob(
      {required BuildContext context,
      required Map<String, dynamic> mapData}) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    // Make an API call to create or update a job
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: 'post-job', apiData: mapData);

    if (res["code"] == '200') {
      var data = res['data'];

      var jobData = Jobs.fromJson(data);

      _myjoblist.add(jobData);
      // _myjoblist.insert(0, jobData);

      // Display a success message for job creation
      toast("Job created successfully");
      notifyListeners();
      // Close the loading dialog and navigate back
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const JobPage(),
          ));
    } else {
      // Close the loading dialog and display an error message
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  /// update job application
  Future<void> updatejob(
      {required BuildContext context,
      required Map<String, dynamic> mapData}) async {
    // Show a custom loading dialog
    customDialogueLoader(context: context);

    // Make an API call to create or update a job
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-job-post', apiData: mapData);
    dev.log("update job ");

    if (res["code"] == '200') {
      toast(res["message"].toString());

      // Close the loading dialog and navigate back
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobPage()),
      );
    } else {
      // Close the loading dialog and display an error message
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  removeMyJob({required int index}) {
    _myjoblist.removeAt(index);
    notifyListeners();
  }

// Remove a job from the job list
  removeAtJobList({required int index}) {
    switch (currentJobTab) {
      case "myjobs":
        {
          _myjoblist.removeAt(index);
          break;
        }
      case 'getall':
        {
          _joblist.removeAt(index);
          break;
        }
      default:
        {
          serchlist.removeAt(index);
        }
    }
    notifyListeners();
  }

// Clear the job list based on the current job tab
  void makeListEmpty() {
    switch (currentJobTab) {
      case "myjobs":
        {
          _myjoblist.clear();
          break;
        }
      case 'getall':
        {
          _joblist.clear();
          break;
        }
      default:
        {
          serchlist.clear();
        }
    }
    notifyListeners();
  }

// Load data with the specified boolean value for 'loading'
  void loadData(bool value) {
    loading = value;
    notifyListeners();
  }
}
