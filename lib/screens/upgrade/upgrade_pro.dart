// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/viewModel/api_client.dart';

class UpgradePro extends StatefulWidget {
  const UpgradePro({super.key});

  @override
  State<UpgradePro> createState() => _UpgradeProState();
}

class _UpgradeProState extends State<UpgradePro> {
  SiteSetting? site;
  UserLevel? userLevel;
  @override
  void initState() {
    userLevel = UserLevel.fromJson(
      jsonDecode(
        getStringAsync('userLevel'),
      ),
    );
    log('UserLevel........${userLevel?.id}');
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
  }

  // upgrade api
  Future<void> upgradePro({type}) async {
    customDialogueLoader(context: context);
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'upgrade-to-pro', apiData: {"package_id": type});
    log('Upgrade to pro ${res}');
    if (res["code"] == '200') {
      toast("${res['message']}");
      Navigator.pop(context);
      setState(() {
        userLevel?.id = type.toString();
        setValue('userLevel', res["data"]);
      });
    } else {
      Navigator.pop(context);
      toast("${res['message']}");

      print('Error: ${res['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData getIconForIndex(int index) {
      switch (index) {
        case 0:
          return Icons.star;
        case 1:
          return CupertinoIcons.bolt_fill;

        case 2:
          return CupertinoIcons.flame_fill;
        default:
          return CupertinoIcons.airplane;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
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
            //   translate(context, AppString.packages).toString(),
            //   style: TextStyle(
            //       fontStyle: FontStyle.italic,
            //       fontSize: 14,
            //       fontWeight: FontWeight.w400),
            // ),
          ],
        ),
      ),
      body: PageView.builder(
          itemCount: site!.packages.length,
          itemBuilder: (context, index) {
            var iconData = getIconForIndex(index);
            Color parsedColor = Color(
              int.parse(
                site!.packages[index].color!.replaceAll('#', '0xff'),
              ),
            );
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        index == site!.packages.length - 1
                            ? const Icon(
                                Icons.keyboard_double_arrow_left_sharp,
                              )
                            : const SizedBox.shrink(),
                        Text(
                          index != site!.packages.length - 1
                              ? translate(context, AppString.swipe_right)
                                  .toString()
                              : translate(context, AppString.swipe_left)
                                  .toString(),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        index != site!.packages.length - 1
                            ? const Icon(
                                Icons.keyboard_double_arrow_right_sharp,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // const Spacer(),
                    Column(
                      children: [
                        Icon(
                          iconData,
                          size: 80,
                          color: parsedColor,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          site!.packages[index].name.toString(),
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          site!.packages[index].description.toString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '\$${site!.packages[index].packagePrice}/${site!.packages[index].duration}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // const Spacer(),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * .8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          HeaderText(
                                              text: site!.appName!.toString()),
                                          10.sw,
                                          Container(
                                            decoration: BoxDecoration(
                                                color: parsedColor,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                site!.packages[index].name
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      10.sh,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: parsedColor,
                                            size: 18,
                                          ),
                                          10.sw,
                                          Expanded(
                                            child: HeaderText(
                                              text: translate(
                                                      context,
                                                      AppString
                                                          .complete_control_over_your_profile)
                                                  .toString(),
                                              isBig: false,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      6.sh,
                                      site!.packages[index].featuredMember ==
                                              '1'
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: parsedColor,
                                                  size: 18,
                                                ),
                                                10.sw,
                                                HeaderText(
                                                  text: translate(
                                                          context,
                                                          AppString
                                                              .featured_member)
                                                      .toString(),
                                                  isBig: false,
                                                  fontSize: 14,
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      6.sh,
                                      site!.packages[index].verifiedBadge == '1'
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: parsedColor,
                                                  size: 18,
                                                ),
                                                10.sw,
                                                HeaderText(
                                                  text: translate(
                                                          context,
                                                          AppString
                                                              .verified_badge)
                                                      .toString(),
                                                  isBig: false,
                                                  fontSize: 14,
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      6.sh,
                                      site!.packages[index].postPromo == '1'
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: parsedColor,
                                                  size: 18,
                                                ),
                                                10.sw,
                                                HeaderText(
                                                  text: translate(
                                                          context,
                                                          AppString
                                                              .posts_promotion)
                                                      .toString(),
                                                  isBig: false,
                                                  fontSize: 14,
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                      6.sh,
                                      site!.packages[index].pagePromo == '1'
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: parsedColor,
                                                  size: 18,
                                                ),
                                                10.sw,
                                                HeaderText(
                                                  text: translate(
                                                          context,
                                                          AppString
                                                              .page_promotion)
                                                      .toString(),
                                                  isBig: false,
                                                  fontSize: 14,
                                                )
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.sh,
                        InkWell(
                          onTap: userLevel!.id! == site!.packages[index].id
                              ? null
                              : () {
                                  upgradePro(type: index + 1);
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: userLevel!.id! == site!.packages[index].id
                                  ? Colors.grey
                                  : AppColors.primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userLevel!.id! == site!.packages[index].id
                                    ? translate(context, AppString.subscribed)
                                        .toString()
                                    : translate(context, AppString.subscribe)
                                        .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        // 20.sh,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
