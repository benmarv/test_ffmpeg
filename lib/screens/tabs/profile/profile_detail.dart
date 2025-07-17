import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key, required this.data});
  final Usr data;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  List<String> monthNames = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  List relation = ["none", "single", "in_a_relationship", "married", "engaged"];

  bool isVisible(String? privacy) {
    bool isUserOwnData = widget.data.id == getUserData.value.id;
    bool isEmailVisibleToFriends =
        widget.data.isFriend == '1' && privacy == '1';
    bool isVisibleToEveryone = privacy == '0';
    return isUserOwnData || isEmailVisibleToFriends || isVisibleToEveryone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate(context, 'profile_details')!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.data.firstName.toString() != "" &&
                          widget.data.firstName != null)
                        Row(
                          children: [
                            const Icon(Icons.account_circle_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "${widget.data.firstName} ${widget.data.lastName}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      if (isVisible(widget.data.privacyEmail) &&
                          (widget.data.email.toString() != "" &&
                              widget.data.email != null))
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.email),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    widget.data.email!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      if (isVisible(widget.data.privacyPhone) &&
                          (widget.data.phone.toString() != "" &&
                              widget.data.phone != null))
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.phone),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    widget.data.phone,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      if (isVisible(widget.data.privacyBirthday) &&
                          (widget.data.dateOfBirth != null))
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.cake,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${widget.data.dateOfBirth!.day} ${translate(context, monthNames[widget.data.dateOfBirth!.month - 1])} ${widget.data.dateOfBirth!.year} ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.data.gender.toString() != "" &&
                          widget.data.gender != null)
                        Row(
                          children: [
                            widget.data.gender.toString() == "Male"
                                ? const Icon(
                                    Icons.male,
                                  )
                                : widget.data.gender.toString() == "Female"
                                    ? const Icon(
                                        Icons.female,
                                      )
                                    : const SizedBox.shrink(),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.data.gender.toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (widget.data.relationId.toString() != "" &&
                          widget.data.relationId != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              translate(
                                context,
                                relation[int.parse(widget.data.relationId!)],
                              )!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      if (widget.data.working.toString() != "" &&
                          widget.data.working != null)
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.work),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.data.working.toString(),
                                )
                              ],
                            )
                          ],
                        ),
                      if ((widget.data.id == getUserData.value.id ||
                              widget.data.shareMyLocation != '0') &&
                          (widget.data.city != null && widget.data.city != ''))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              translate(context, 'location_info')!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_sharp,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    widget.data.city.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      if (widget.data.aboutYou.toString() != "" &&
                          widget.data.aboutYou != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            Text(
                              translate(context, 'about')!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.info_sharp,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  child: Text(
                                    widget.data.aboutYou.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        translate(context, 'socials')!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(LineIcons.facebook),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (getUserData.value.id == widget.data.id) {
                                    if (getUserData.value.facebook == '' ||
                                        getUserData.value.facebook == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      getUserData.value.facebook,
                                    )) {
                                      launchUrlString(
                                        getUserData.value.facebook,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  } else {
                                    if (widget.data.facebook == '' ||
                                        widget.data.facebook == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      widget.data.facebook,
                                    )) {
                                      launchUrlString(
                                        widget.data.facebook,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  }
                                },
                                child: Text(
                                  translate(context, 'facebook')!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(LineIcons.instagram),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (getUserData.value.id == widget.data.id) {
                                    if (getUserData.value.instagram == '' ||
                                        getUserData.value.instagram == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      getUserData.value.instagram,
                                    )) {
                                      launchUrlString(
                                        getUserData.value.instagram,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  } else {
                                    if (widget.data.instagram == '' ||
                                        widget.data.instagram == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      widget.data.instagram,
                                    )) {
                                      launchUrlString(
                                        widget.data.instagram,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  }
                                },
                                child: Text(
                                  translate(context, 'instagram')!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(LineIcons.youtube),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (getUserData.value.id == widget.data.id) {
                                    if (getUserData.value.youtube == '' ||
                                        getUserData.value.youtube == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      getUserData.value.youtube,
                                    )) {
                                      launchUrlString(
                                        getUserData.value.youtube,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  } else {
                                    if (widget.data.youtube == '' ||
                                        widget.data.youtube == null) {
                                      toast(translate(
                                          context, 'no_social_link')!);
                                    } else if (await canLaunchUrlString(
                                      widget.data.youtube,
                                    )) {
                                      launchUrlString(
                                        widget.data.youtube,
                                      );
                                    } else {
                                      toast(translate(
                                          context, 'url_not_launch')!);
                                    }
                                  }
                                },
                                child: Text(
                                  translate(context, 'youtube')!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      // Text(
                      //   "Common Interests",
                      //   style: const TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.w500),
                      // ),
                      // CommonInteresetListBuilder(title: "Groups", names: names),
                      // CommonInteresetListBuilder(title: "Pages", names: color),
                      // CommonInteresetListBuilder(title: "Citys", names: city),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommonInteresetListBuilder extends StatelessWidget {
  final String? title;
  const CommonInteresetListBuilder({
    super.key,
    this.title,
    required this.names,
  });

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${title!} :",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: AppColors.primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              names[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
