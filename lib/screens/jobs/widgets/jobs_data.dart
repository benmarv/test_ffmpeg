import 'package:flutter/material.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/models/searchjob_model.dart';
import 'job_card.dart';

class JobsData extends StatelessWidget {
  const JobsData({super.key, this.jobs, this.myjobslist});
  final List<SearchJobs>? jobs;
  final List<MyJobModel>? myjobslist;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: myjobslist != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myjobslist!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: JobCard(
                    myjobsdata: myjobslist![index],
                    index: index,
                  ),
                );
              })
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: jobs!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: JobCard(
                    jobsData: jobs![index],
                    index: index,
                  ),
                );
              }),
    );
  }
}
