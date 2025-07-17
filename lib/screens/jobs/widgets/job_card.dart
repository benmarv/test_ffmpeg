import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/screens/jobs/jobs_details.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/models/searchjob_model.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class JobCard extends StatelessWidget {
  JobCard({super.key, required this.index, this.jobsData, this.myjobsdata});
  final int? index;
  final SearchJobs? jobsData;
  final MyJobModel? myjobsdata;

  @override
  Widget build(BuildContext context) {
    return myjobsdata == null
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JobDetail(
                            index: index,
                            searchJobDetails: jobsData,
                          )));
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobsData!.jobTitle.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor),
                          ),
                          Text(
                            jobsData!.companyName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            jobsData!.jobLocation.toString(),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.work_outline_outlined,
                                size: 18,
                              ),
                              3.sw,
                              Text(
                                jobsData!.experienceYears.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                          10.sh,
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${jobsData!.currency} ${jobsData!.minimumSalary}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  "-",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${jobsData!.currency} ${jobsData!.maximumSalary}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${translate(context, 'a')} ${jobsData!.salaryDate.toString()}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          5.sh,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.65),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Text(
                                      translate(context, jobsData!.jobType!)
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.paperplane,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.sw,
                                  Text(
                                    translate(context, 'easy_apply')!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  20.sw,
                                  jobsData!.isUrgentHiring == '0'
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Icons.av_timer_sharp,
                                              size: 14,
                                              color: AppColors.primaryColor,
                                            ),
                                            5.sw,
                                            Text(
                                              translate(
                                                  context, 'urgently_hiring')!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  fontSize: 11,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JobDetail(
                            index: index,
                            jobdetails: myjobsdata,
                          )));
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            myjobsdata!.jobTitle.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            myjobsdata!.companyName.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          Text(
                            myjobsdata!.jobLocation.toString(),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.work_outline_outlined,
                                  size: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              3.sw,
                              Text(
                                myjobsdata!.experienceYears.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                          10.sh,
                          Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                '${myjobsdata!.currency} ${myjobsdata!.minimumSalary} - ${myjobsdata!.currency} ${myjobsdata!.maximumSalary} ${translate(context, 'a')} ${myjobsdata!.salaryDate.toString()}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          5.sh,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.65),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    Text(
                                      translate(context, myjobsdata!.jobType!)
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          10.sh,
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.paperplane,
                                    size: 14,
                                    color: AppColors.primaryColor,
                                  ),
                                  5.sw,
                                  Text(
                                    translate(context, 'easy_apply')!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  20.sw,
                                  myjobsdata!.isUrgentHiring == '0'
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Icons.av_timer_sharp,
                                              size: 14,
                                              color: AppColors.primaryColor,
                                            ),
                                            5.sw,
                                            Text(
                                              translate(
                                                  context, 'urgently_hiring')!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.normal,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ],
                          ),
                          5.sh,
                          Row(
                            children: [
                              const Icon(
                                Icons.timelapse_rounded,
                                size: 18,
                              ),
                              10.sw,
                              FutureBuilder<String>(
                                future: convertUtcToKarachi(
                                    myjobsdata!.createdAt!.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error');
                                  } else {
                                    return Text(
                                      snapshot.data!,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Future<String> convertUtcToKarachi(String utcDateTimeString) async {
    try {
      tzdata.initializeTimeZones();
      final utcTime = DateTime.parse(utcDateTimeString + "Z").toUtc();
      final karachiTimeZone =
          tz.getLocation(await FlutterTimezone.getLocalTimezone());
      final karachiTime = tz.TZDateTime.from(utcTime, karachiTimeZone);
      final formattedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(karachiTime);
      final dateTime = DateTime.parse(formattedTime);
      return dateTime.timeAgo;
    } catch (e) {
      print('Error: $e');
      return 'Invalid Time';
    }
  }
}
