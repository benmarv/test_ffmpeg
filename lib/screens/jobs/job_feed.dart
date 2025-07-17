import 'package:flutter/material.dart';
import 'package:link_on/controllers/jobsProvider/myjobs_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/jobs/widgets/jobs_data.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class AllJobs extends StatefulWidget {
  const AllJobs({super.key});
  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    MyJobList provider = Provider.of<MyJobList>(context, listen: false);
    _loadData();
    _controller.addListener(() {
      if ((_controller.position.pixels ==
              _controller.position.maxScrollExtent) &&
          provider.loading == false) {
        int afterPostId = provider.alljoblist.length;
        provider.searchjob(
            currentJobTab: "alljobs", afterPostId: afterPostId.toString());
      }
    });
  }

  Future<void> _loadData() async {
    MyJobList provider = Provider.of<MyJobList>(context, listen: false);
    provider.makeAllJobsListEmpty();
    if (provider.alljoblist.isEmpty) {
      await provider.searchjob(currentJobTab: "alljobs");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyJobList>(
        builder: (context, value, child) {
          return value.loading == true && value.alljoblist.isEmpty
              ? Center(
                  child: Loader(),
                )
              : value.loading == false && value.alljoblist.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_job_found').toString()),
                        TextButton(
                          onPressed: () {
                            context
                                .read<MyJobList>()
                                .searchjob(currentJobTab: "alljobs");
                          },
                          child:
                              Text(translate(context, 'load_again').toString()),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        children: [
                          JobsData(myjobslist: value.alljoblist),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
