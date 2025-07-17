// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/screens/jobs/jobs_details.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class JobSearch extends StatefulWidget {
  final TextEditingController searchController;

  const JobSearch({super.key, required this.searchController});

  @override
  State<JobSearch> createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (widget.searchController.text.isEmpty) {
      searchProvider.search(query: '', type: 'job');
    } else {
      searchProvider.search(query: widget.searchController.text, type: 'job');
    }
    searchProvider.currentIndex = 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, value, child) {
      return value.data == false
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : value.jobMessage ==
                      translate(context, 'enter_something_to_search') ||
                  value.jobMessage == translate(context, 'job_not_found')
              ? Center(
                  child: Text(
                    value.jobMessage.toString(),
                  ),
                )
              : value.jobs.isNotEmpty && value.data == true
                  ? ListView.separated(
                      itemCount: value.jobs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobSeachTile(
                          job: value.jobs[index],
                          index: index,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        translate(context, 'job_not_found').toString(),
                      ),
                    );
    });
  }
}

class JobSeachTile extends StatefulWidget {
  final MyJobModel? job;
  final int? index;

  const JobSeachTile({Key? key, this.job, this.index}) : super(key: key);

  @override
  _JobSeachTileState createState() => _JobSeachTileState();
}

class _JobSeachTileState extends State<JobSeachTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: ((context, value, child) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobDetail(
                  index: widget.index,
                  jobdetails: widget.job,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 3,
          ),
          title: Text(
            "${widget.job!.jobTitle}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    translate(context, 'location_label').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.job!.jobLocation!),
                ],
              ),
              Row(
                children: [
                  Text(
                    translate(context, 'company_label').toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.job!.companyName ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primaryColor,
          ),
        );
      }),
    );
  }
}
