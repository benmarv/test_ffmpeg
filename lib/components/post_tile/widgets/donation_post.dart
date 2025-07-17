// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart' as post_model;

class DonationPost extends StatefulWidget {
  const DonationPost(
      {super.key, this.posts, this.index, this.onTab, this.pollWidget});
  final post_model.Posts? posts;
  final int? index;
  final Widget? pollWidget;
  final void Function()? onTab;

  @override
  State<DonationPost> createState() => _DonationPostState();
}

class _DonationPostState extends State<DonationPost> {
  int numberOfDonner = 0;
  @override
  Widget build(BuildContext context) {
    return widget.posts!.sharedPost != null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
              ),
            ),
            child: InkWell(
              onTap: widget.onTab,
              child: Column(
                children: [
                  widget.pollWidget!,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(widget
                                      .posts!.sharedPost!.donation!.image!),
                                  fit: BoxFit.cover)),
                        ),
                        Baseline(
                          baseline: 20,
                          baselineType: TextBaseline.alphabetic,
                          child: PhysicalModel(
                            color: Colors.grey.shade300,
                            elevation: 1,
                            borderRadius: BorderRadius.circular(100),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.primaryColor,
                                  child: Image(
                                    image:
                                        AssetImage('assets/images/donate.png'),
                                    width: 25,
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.posts!.sharedPost!.donation!.title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.posts!.sharedPost!.donation!.description!,
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DonationProgressBar(
                          totalDonations: double.parse(widget
                              .posts!.sharedPost!.donation!.collectedAmount!),
                          totalGoal: double.parse(
                              widget.posts!.sharedPost!.donation!.amount!),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.posts!.sharedPost!.donation!
                                  .collectedAmount!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              translate(context, 'collected').toString(),
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.primaryColor),
                              child: Text(
                                translate(context, 'donate').toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: widget.onTab,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(widget.posts!.donation!.image!),
                            fit: BoxFit.cover)),
                  ),
                  Baseline(
                    baseline: 20,
                    baselineType: TextBaseline.alphabetic,
                    child: PhysicalModel(
                      color: Colors.grey.shade300,
                      elevation: 1,
                      borderRadius: BorderRadius.circular(100),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primaryColor,
                            child: Image(
                              image: AssetImage('assets/images/donate.png'),
                              width: 25,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.posts!.donation!.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.posts!.donation!.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DonationProgressBar(
                    totalDonations:
                        double.parse(widget.posts!.donation!.collectedAmount!),
                    totalGoal: double.parse(widget.posts!.donation!.amount!),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    // color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.posts!.donation!.collectedAmount!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              translate(context, 'collected').toString(),
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // MaterialButton(
                            //   padding: EdgeInsets.zero,
                            //   onPressed: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => DonersPage(
                            //                   posts: widget.posts,
                            //                 )));
                            //   },
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         "Doners",
                            //         style: TextStyle(
                            //           color: AppColors.primaryLightColor,
                            //         ),
                            //       ),
                            //       SizedBox(width: 5),
                            //       Icon(
                            //         Icons.volunteer_activism,
                            //         color: AppColors.primaryLightColor,
                            //         size: 20,
                            //       ),
                            //     ],
                            //   ),
                            //   color: AppColors.gradientColor2,
                            //   height: 25,
                            // ),
                            // SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.primaryColor),
                              child: Text(
                                translate(context, 'donate').toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class DonationProgressBar extends StatefulWidget {
  final double totalDonations;
  final double totalGoal;

  const DonationProgressBar(
      {super.key, required this.totalDonations, required this.totalGoal});

  @override
  _DonationProgressBarState createState() => _DonationProgressBarState();
}

class _DonationProgressBarState extends State<DonationProgressBar> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.totalDonations / widget.totalGoal;

    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(10),
      minHeight: 10,
      value: progress,
      backgroundColor: AppColors.primaryColor.withOpacity(0.3),
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
    );
  }
}
