import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/screens/groups/group_details.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';

class GroupUserDetail extends StatelessWidget {
  const GroupUserDetail({
    super.key,
    this.posts,
    this.richFeelingTxt,
    this.onTab,
    this.widget,
  });
  final Posts? posts;
  final Widget? widget;
  final RichText? richFeelingTxt;
  final void Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Usr>(
        valueListenable: getUserData,
        builder: (context, userData, child) {
          return ListTile(
            minVerticalPadding: 5.0,
            dense: true,
            minLeadingWidth: 0.0,
            horizontalTitleGap: 4,
            contentPadding: EdgeInsets.zero,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsGroup(
                      joinGroupModel: posts?.group,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: posts!.group!.cover!,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        posts!.group!.cover.toString(),
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      right: -1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.amber,
                          backgroundImage: NetworkImage(
                            posts?.user?.id == userData.id
                                ? userData.avatar!
                                : posts!.user!.avatar!.toString(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsGroup(
                      joinGroupModel: posts?.group,
                    ),
                  ),
                );
              },
              child: Text(
                posts!.group!.groupTitle.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            subtitle: Row(
              children: [
                GestureDetector(
                  onTap: onTab,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (posts!.user!.avatar != null)
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: (posts!.user!.firstName != null &&
                                              posts!.user!.lastName != null &&
                                              posts!.user!.firstName!
                                                  .isNotEmpty &&
                                              posts!.user!.lastName!.isNotEmpty)
                                          ? posts?.user?.id == userData.id
                                              ? "${userData.firstName} ${userData.lastName}"
                                              : "${posts!.user!.firstName!} ${posts!.user!.lastName!}"
                                          : posts!.user!.username.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    if (posts!.user!.isVerified == "1")
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child:
                                              verified(), // Your verified icon/widget
                                        ),
                                      ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          richFeelingTxt ?? const SizedBox.shrink(),
                          if (1 != 1) ...[
                            Expanded(
                              child: Text(
                                translate(context, 'added_a_poll').toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                          if (posts?.product != null) ...[
                            Expanded(
                              child: Text(
                                translate(context, 'added_new_product')
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                          if (posts?.images != null) ...[
                            if (posts?.images.toString().contains("avatar") ==
                                true) ...[
                              Expanded(
                                child: Text(
                                  posts!.user!.gender == 'Male'
                                      ? translate(context,
                                              'updated_his_profile_picture')
                                          .toString()
                                      : translate(context,
                                              'updated_her_profile_picture')
                                          .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                            if (posts?.images != null &&
                                posts?.images.toString().contains("cover") ==
                                    true) ...[
                              Expanded(
                                child: Text(
                                  posts!.user!.gender == 'Male'
                                      ? translate(context,
                                              'updated_his_profile_cover')
                                          .toString()
                                      : translate(context,
                                              'updated_her_profile_cover')
                                          .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ]
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        posts!.createdHuman.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isDismissible:
                      true, // Set to true to allow dismissing on tap outside

                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  context: context,
                  builder: (context) => widget!,
                );
              },
              child: const Icon(
                Icons.more_vert,
              ),
            ),
          );
        });
  }
}
