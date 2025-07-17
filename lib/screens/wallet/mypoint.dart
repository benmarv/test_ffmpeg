import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/wallet/deposit.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/components/header_text.dart';

class MyPoint extends StatefulWidget {
  final dynamic point;

  const MyPoint({super.key, this.point});

  @override
  State<MyPoint> createState() => _MyPointState();
}

class _MyPointState extends State<MyPoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                getStringAsync("appLogo"),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: translate(context, 'total_points'),
            ),
            15.sh,
            PhysicalModel(
              elevation: 2,
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.primaryColor.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate(context, 'current_points')!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${widget.point}",
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          translate(context, 'points_conversion_rate')!,
                          style: const TextStyle(
                              color: AppColors.primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const ColoredBox(
                            color: AppColors.primaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.star_border,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ))),
                  ],
                ),
              ),
            ),
            25.sh,
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.black87,
                    size: 25,
                  ),
                  10.sh,
                  Text(
                    translate(context, 'earned_points_message')!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  5.sh,
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddFunds()));
                    },
                    child: Text(
                      translate(context, 'my_balance')!,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
