import 'package:flutter/material.dart';

import 'package:link_on/consts/colors.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class ScheduleSpaceTile extends StatelessWidget {
  const ScheduleSpaceTile({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      // height: 100,
      width: size.width,
      child: PhysicalModel(
        color: Colors.white,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
          decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0.1, 0.5), color: Colors.grey.shade300)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 19,
                      ),
                      7.sw,
                      const Text(
                        "08 Apr 5:00 AM",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
              10.sh,
              const Text(
                "i made a room for testing puppose",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              10.sh,
              const Wrap(
                spacing: 10,
                children: [
                  Text(
                    "Education",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "Education",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              10.sh,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhysicalModel(
                    color: Colors.black12,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          // image: DecorationImage(
                          //     image: NetworkImage(value
                          //         .getMemberDataList[
                          //             i]
                          //         .avatar
                          //         .toString()

                          //         ),
                          //     fit:
                          //         BoxFit.cover),
                          shape: BoxShape.circle),
                    ),
                  ),
                  10.sw,
                  const Text(
                    "Tom Dante",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  15.sw,
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Text(
                        "Host",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
