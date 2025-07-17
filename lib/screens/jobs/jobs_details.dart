import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/jobsProvider/joblist_provider.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/models/searchjob_model.dart';
import 'package:link_on/screens/jobs/jobs.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/jobs/edit_job.dart';
import 'package:link_on/screens/jobs/job_apply.dart';
import 'package:link_on/screens/jobs/job_apply_list.dart';

class JobDetail extends StatefulWidget {
  final int? index;
  final MyJobModel? jobdetails;
  final SearchJobs? searchJobDetails;
  const JobDetail(
      {super.key, this.jobdetails, this.index, this.searchJobDetails});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  List categoryjob = [
    "Other",
    "Admin & Office",
    "Art & Design",
    "Business Operations",
    "Cleaning & Facilities",
    "Community & Social Services",
    "Computer & Data",
    "Construction & Mining",
    "Education",
    "Farming & Forestry",
    "Healthcare",
    "Installation, Maintenance & Repair",
    "Legal",
    "Management",
    "Manufacturing",
    "Media & Communication",
    "Personal Care",
    "Protective Services",
    "Restaurant & Hospitality",
    "Retail & Sales",
    "Science & Engineering",
    "Sports & Entertainment",
    "Transportation",
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> deletejob({id, index}) async {
    customDialogueLoader(context: context);
    Map<String, dynamic> dataArray = {
      "job_id": id,
    };
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'delete-job-post', apiData: dataArray);
    if (res["code"] == '200') {
      toast(res['message'].toString());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const JobPage(),
          ),
        );
        Provider.of<JobListProvider>(context, listen: false)
            .removeMyJob(index: index);
      }
      setState(() {});
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: SafeArea(
          child: (widget.searchJobDetails != null)
              ? Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.searchJobDetails!.jobTitle
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    5.sh,
                                    Text(
                                      widget.searchJobDetails!.companyName
                                          .toString(),
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.searchJobDetails!.jobLocation
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.payments_sharp,
                                            size: 18),
                                        10.sw,
                                        Text(
                                          translate(context, 'pay').toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, left: 20),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${widget.searchJobDetails!.currency} ${widget.searchJobDetails!.minimumSalary}  -  ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            '${widget.searchJobDetails!.currency} ${widget.searchJobDetails!.maximumSalary}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "a ${widget.searchJobDetails!.salaryDate.toString()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                    15.sh,
                                    Row(
                                      children: [
                                        const Icon(Icons.work, size: 18),
                                        10.sw,
                                        Text(
                                          translate(context, 'job_type')
                                              .toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, left: 20),
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                translate(
                                                        context,
                                                        widget.searchJobDetails!
                                                            .jobType!)
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              const Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.av_timer_rounded,
                                            size: 18),
                                        10.sw,
                                        Text(widget.searchJobDetails!.createdAt!
                                            .timeAgo),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      translate(context, 'job_description')
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    ReadMoreText(
                                      widget.searchJobDetails!.jobDescription
                                          .toString(),
                                      trimLines: 1,
                                      trimLength: 410,
                                      style: const TextStyle(
                                          textBaseline: TextBaseline.alphabetic,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                      trimCollapsedText:
                                          translate(context, 'read_more_text')
                                              .toString(),
                                      trimExpandedText:
                                          translate(context, 'show_less_text')
                                              .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              80.sh,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: widget.searchJobDetails!.userId.toString() ==
                                getStringAsync("user_id")
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: InkWell(
                                        splashColor: AppColors.primaryColor,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AppliedJobsList(
                                                        jobid: widget
                                                            .searchJobDetails!
                                                            .id
                                                            .toString(),
                                                      )));
                                        },
                                        child: PhysicalModel(
                                          color: AppColors.primaryColor,
                                          elevation: 2,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: SizedBox(
                                            height: 40,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .925,
                                            child: Center(
                                              child: Text(
                                                translate(context,
                                                        'applied_candidates')
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.sh,
                                    Center(
                                      child: InkWell(
                                        splashColor: AppColors.primaryColor,
                                        onTap: () {
                                          deletejob(
                                              id: widget.searchJobDetails!.id
                                                  .toString(),
                                              index: widget.index);
                                        },
                                        child: Container(
                                          height: 40,
                                          color: const Color.fromARGB(
                                              255, 226, 226, 226),
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .92,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.delete,
                                                  color: AppColors.primaryColor,
                                                ),
                                                2.sw,
                                                Text(
                                                  translate(context,
                                                          'delete_job_application')
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // 10.sh,
                                    // MaterialButton(

                                    //   onPressed: () {},
                                    //   child: Text(
                                    //     translate(
                                    //             context, 'edit_job_instruction')
                                    //         .toString(),
                                    //     style: const TextStyle(
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.w300),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: InkWell(
                                    onTap: widget.searchJobDetails!.isApplied
                                        ? null
                                        : () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JobApply(
                                                          jobid: widget
                                                              .searchJobDetails!
                                                              .id
                                                              .toString(),
                                                          jobtitile: widget
                                                              .searchJobDetails!
                                                              .jobTitle
                                                              .toString(),
                                                        )));
                                          },
                                    child: Container(
                                      height: 40,
                                      width: MediaQuery.sizeOf(context).width *
                                          .93,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.searchJobDetails!.isApplied
                                              ? translate(context, 'applied')
                                                  .toString()
                                              : translate(context, 'apply_now')
                                                  .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              : Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.arrow_back),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.jobdetails!.jobTitle.toString(),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    5.sh,
                                    Text(
                                      widget.jobdetails!.companyName.toString(),
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.jobdetails!.jobLocation.toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.payments_sharp,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        10.sw,
                                        Text(
                                          translate(context, 'pay').toString() +
                                              " :",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .7,
                                          child: Text(
                                            '${widget.jobdetails!.currency} ${widget.jobdetails!.minimumSalary} - ${widget.jobdetails!.currency} ${widget.jobdetails!.maximumSalary} a ${widget.jobdetails!.salaryDate.toString()}',
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    15.sh,
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.work,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        10.sw,
                                        Text(
                                          translate(context, 'job_type')
                                                  .toString() +
                                              " : ",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          widget.jobdetails!.jobType.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.av_timer_rounded,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        10.sw,
                                        Text("Created :",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(width: 5),
                                        Text(
                                          widget.jobdetails!.createdAt!.timeAgo,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        10.sw,
                                        Text(
                                          translate(context, 'job_description')
                                                  .toString() +
                                              " :",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ReadMoreText(
                                      widget.jobdetails!.jobDescription
                                          .toString(),
                                      trimLines: 1,
                                      trimLength: 720,
                                      style: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      trimCollapsedText:
                                          translate(context, 'read_more_text')
                                              .toString(),
                                      trimExpandedText:
                                          translate(context, 'show_less_text')
                                              .toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              widget.jobdetails!.userId.toString() ==
                                      getStringAsync("user_id")
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Center(
                                                child: InkWell(
                                                  splashColor:
                                                      AppColors.primaryColor,
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AppliedJobsList(
                                                                  jobid: widget
                                                                      .jobdetails!
                                                                      .id
                                                                      .toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            translate(context,
                                                                    'applied_candidates')
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: InkWell(
                                                  splashColor:
                                                      AppColors.primaryColor,
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditJob(
                                                                jobDetail: widget
                                                                    .jobdetails),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "Edit job",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          10.sh,
                                          Center(
                                            child: InkWell(
                                              splashColor:
                                                  AppColors.primaryColor,
                                              onTap: () {
                                                deletejob(
                                                    id: widget.jobdetails!.id
                                                        .toString(),
                                                    index: widget.index);
                                              },
                                              child: PhysicalModel(
                                                color: AppColors.gradientColor1,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                    2.sw,
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        translate(context,
                                                                'delete_job_application')
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Center(
                                        child: InkWell(
                                          onTap: widget.jobdetails!.isApplied
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobApply(
                                                        jobid: widget
                                                            .jobdetails!.id
                                                            .toString(),
                                                        jobtitile: widget
                                                            .jobdetails!
                                                            .jobTitle
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .93,
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                widget.jobdetails!.isApplied
                                                    ? translate(
                                                            context, 'applied')
                                                        .toString()
                                                    : translate(context,
                                                            'apply_now')
                                                        .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
