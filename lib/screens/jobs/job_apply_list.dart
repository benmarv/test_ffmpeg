import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/job_mdel/Apply_JobList_Model.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'candidate_details.dart';

class AppliedJobsList extends StatefulWidget {
  final String? jobid;
  const AppliedJobsList({super.key, this.jobid});

  @override
  State<AppliedJobsList> createState() => _AppliedJobsListState();
}

class _AppliedJobsListState extends State<AppliedJobsList> {
  List<AppliedJobList> candidateslist = [];

  bool isdata = false;

  Future<void> candidatesJobList(jodid) async {
    log('Job....Id.....${jodid.toString()}');
    Map<String, dynamic> dataArray = {
      "job_id": jodid,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'applied-candidates', apiData: dataArray);
    if (res["code"] == '200') {
      var data = res['data'];
      candidateslist = List.from(data).map<AppliedJobList>((data) {
        return AppliedJobList.fromJson(data);
      }).toList();
      setState(() {});
      isdata = true;
    } else {}
  }

  @override
  void initState() {
    super.initState();
    candidatesJobList(widget.jobid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          translate(context, 'applied_candidates')!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: candidateslist.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, 'applied_candidates')!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: candidateslist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  PhysicalModel(
                                    color: Colors.white,
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: Colors.grey.shade400)),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: NetworkImage(
                                          candidateslist[index]
                                              .avatar
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        candidateslist[index]
                                            .username
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        candidateslist[index].phone.toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: Text(
                                          candidateslist[index]
                                              .location
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ApplyJobDetails(
                                          candidatedata: candidateslist[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    translate(context, 'view')!,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          const Divider(
                            thickness: 0.5,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            : SizedBox(
                height: MediaQuery.sizeOf(context).height,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    (isdata == true && candidateslist.isEmpty)
                        ? Text(
                            translate(context, 'no_data')!,
                          )
                        : Text(
                            translate(context, 'searching')!,
                          ),
                  ],
                ),
              ),
      ),
    ));
  }
}
