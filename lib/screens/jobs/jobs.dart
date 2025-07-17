import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/jobs/search_jobs.dart';
import 'create_job.dart';
import 'job_feed.dart';
import 'yours_jobs.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
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
            title: Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 100,
                  child: Image(
                      image: NetworkImage(
                    getStringAsync("appLogo"),
                  )),
                ),
                // Text(
                //   translate(context, 'jobs').toString(),
                //   style: const TextStyle(
                //       fontStyle: FontStyle.italic,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400),
                // ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchJob(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
            bottom: TabBar(
              dividerHeight: 0,
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.primaryColor,
              tabs: [
                Tab(
                  text: translate(context, 'jobs_feed').toString(),
                ),
                Tab(
                  text: translate(context, 'your_jobs').toString(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateJob()));
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
          body: TabBarView(
            controller: _tabController,
            children: const [
              AllJobs(),
              YoursJobs(),
            ],
          )),
    );
  }
}
