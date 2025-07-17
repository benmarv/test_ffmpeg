import 'package:flutter/material.dart';
import 'package:link_on/controllers/jobsProvider/myjobs_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/jobs/widgets/jobs_data.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class YoursJobs extends StatefulWidget {
  const YoursJobs({super.key});
  @override
  State<YoursJobs> createState() => _YoursJobsState();
}

class _YoursJobsState extends State<YoursJobs> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    MyJobList provider = Provider.of<MyJobList>(context, listen: false);
    _loadData();
    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        int afterPostId = provider.myjoblist.length;
        provider.searchjob(
            currentJobTab: "myjobs", afterPostId: afterPostId.toString());
      }
    });
  }

  Future<void> _loadData() async {
    MyJobList provider = Provider.of<MyJobList>(context, listen: false);
    provider.makeMyJobsListEmpty();
    if (provider.myjoblist.isEmpty) {
      await provider.searchjob(currentJobTab: "myjobs");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<MyJobList>(
          builder: (context, value, child) {
            return value.loading == true && value.myjoblist.isEmpty
                ? Center(
                    child: Loader(),
                  )
                : value.loading == false && value.myjoblist.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          loading(),
                          Text(translate(context, 'no_job_found').toString()),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<MyJobList>()
                                  .searchjob(currentJobTab: "myjobs");
                            },
                            child: Text(
                                translate(context, 'load_again').toString()),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        controller: _controller,
                        child: Column(
                          children: [
                            JobsData(myjobslist: value.myjoblist),
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}
