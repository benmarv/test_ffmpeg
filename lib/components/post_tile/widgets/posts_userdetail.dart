import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/post_tile/widgets/tagged_people_details.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/screens/settings/widgets/icon_tile.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PostUserDetail extends StatefulWidget {
  const PostUserDetail({
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
  State<PostUserDetail> createState() => _PostUserDetailState();
}

class _PostUserDetailState extends State<PostUserDetail> {
  String? selectedPrivacy;
  Icon? selectedIcon;
  List<String> data = [
    "Public",
    "Friends",
    "Only me",
    "Family",
    "Business",
  ];

  List<Icon> icondata = [
    const Icon(
      Icons.public,
      color: Colors.grey,
      size: 15,
    ),
    const Icon(
      Icons.people,
      color: Colors.grey,
      size: 15,
    ),
    const Icon(
      color: Colors.grey,
      Icons.lock,
      size: 15,
    ),
    const Icon(
      Icons.family_restroom,
      color: Colors.grey,
      size: 15,
    ),
    const Icon(
      Icons.work,
      color: Colors.grey,
      size: 15,
    ),
  ];

  changePostPrivacy({postId, privacy, index}) async {
    log('Privacy ${privacy.toString()}');
    Map<String, dynamic> apiData = {
      'post_id': postId,
      'privacy': data.indexOf(privacy) + 1
    };
    final res = await apiClient.callApiCiSocial(
        apiPath: 'post/change-privacy', apiData: apiData);
    log('Privacy Response ${res.toString()}');
    if (res['status'] == '200') {
      setState(() {
        selectedPrivacy = data[index];
        selectedIcon = icondata[index];
      });
      toast(translate(context, 'privacy_updated'));
    } else {
      toast(translate(context, 'something_went_wrong'));
    }
  }

  bottomSheet() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 320,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: ((context, index) => Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 0.5,
                  )),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await changePostPrivacy(
                        postId: widget.posts!.id,
                        privacy: data[index],
                        index: index,
                      );
                    },
                    child: IconTile(
                      icon: icondata[index],
                      title: translate(context,
                              data[index].toLowerCase().replaceAll(" ", "_"))
                          .toString(),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> openMap(String location) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunchUrl(
      Uri.parse(googleUrl),
    )) {
      await launchUrl(
        Uri.parse(googleUrl),
      );
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayNames() {
      if (widget.posts!.taggedUsers != null) {
        if (widget.posts!.taggedUsers!.length > 2) {
          return "${widget.posts!.taggedUsers![0].username} ${translate(context, 'and')} ${widget.posts!.taggedUsers!.length - 1} ${translate(context, 'others')}";
        } else if (widget.posts!.taggedUsers!.length < 2) {
          return widget.posts!.taggedUsers![0].username!;
        } else if (widget.posts!.taggedUsers!.length == 2) {
          return "${widget.posts!.taggedUsers![0].username!} ${translate(context, 'and')} ${widget.posts!.taggedUsers![1].username!}";
        }
        return widget.posts!.taggedUsers![0].username!;
      } else {
        return '';
      }
    }

    return ValueListenableBuilder<Usr>(
      valueListenable: getUserData,
      builder: (context, userData, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            minVerticalPadding: 5.0,
            dense: true,
            minLeadingWidth: 0.0,
            horizontalTitleGap: 4,
            contentPadding: EdgeInsets.zero,
            leading: widget.posts?.user?.avatar != null
                ? GestureDetector(
                    onTap: widget.onTab,
                    child: CircularImageNetwork(
                      image: widget.posts?.user?.id == userData.id
                          ? userData.avatar!
                          : widget.posts!.user!.avatar!,
                      size: 50.0,
                    ),
                  )
                : const SizedBox.shrink(),
            title: SizedBox(
              width: MediaQuery.sizeOf(context).width * .5,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context)
                          .style, // Default text style
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTab,
                          text: (widget.posts!.user!.firstName != null &&
                                      widget.posts!.user!.lastName != null) &&
                                  (widget.posts!.user!.firstName != "" &&
                                      widget.posts!.user!.lastName != "")
                              ? widget.posts?.user?.id == userData.id
                                  ? "${userData.firstName} ${userData.lastName}"
                                  : "${widget.posts!.user!.firstName!} ${widget.posts!.user!.lastName!}"
                              : widget.posts!.user!.username.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        WidgetSpan(
                          child: 3.sw, // Empty box for non-verified users
                        ),
                        if (widget.posts!.user!.isVerified == "1")
                          WidgetSpan(child: verified()),
                        if (widget.richFeelingTxt != null)
                          WidgetSpan(
                            child: widget.richFeelingTxt!,
                          ),
                        if (widget.posts?.taggedUsers != null)
                          TextSpan(
                            text: " ${translate(context, 'is_with')} ",
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        if (widget.posts?.taggedUsers != null)
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PostTaggedPeoples(
                                      taggedUsers: widget.posts!.taggedUsers!,
                                    );
                                  },
                                );
                              },
                            text: displayNames(),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        if (widget.posts?.postLocation != '' &&
                            widget.posts?.taggedUsers != null)
                          TextSpan(
                            text: " ${translate(context, 'in')} ",
                            style: const TextStyle(fontSize: 13),
                          ),
                        if (widget.posts?.postLocation != '' &&
                            widget.posts?.taggedUsers == null)
                          TextSpan(
                            text: " ${translate(context, 'is_in')} ",
                            style: const TextStyle(fontSize: 13),
                          ),
                        if (widget.posts?.postLocation != '' ||
                            (widget.posts?.taggedUsers != null &&
                                widget.posts?.postLocation != ''))
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                openMap(widget.posts!.postLocation!);
                              },
                            text: "${widget.posts?.postLocation}",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  if (widget.posts!.postType == 'poll') ...[
                    Text(
                      translate(context, 'added_new_poll').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                  if (widget.posts?.sharedPost != null) ...[
                    Text(
                      translate(context, 'shared_post').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                  if (widget.posts?.product != null) ...[
                    widget.posts?.sharedPost != null
                        ? const SizedBox.shrink()
                        : Text(
                            translate(context, 'added_new_product').toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                  ],
                  if (widget.posts?.event != null) ...[
                    widget.posts?.sharedPost != null
                        ? const SizedBox.shrink()
                        : Text(
                            translate(context, 'created_new_event').toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                  ],
                  if (widget.posts!.postType.toString() == "offer") ...[
                    widget.posts?.sharedPost != null
                        ? const SizedBox.shrink()
                        : Text(
                            translate(context, 'created_new_offer').toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                  ],
                  if (widget.posts?.images != null &&
                      widget.posts?.images![0].mediaPath
                              .toString()
                              .contains("avatar") ==
                          true) ...[
                    widget.posts?.sharedPost != null
                        ? const SizedBox.shrink()
                        : Text(
                            widget.posts!.user!.gender == 'Male'
                                ? translate(
                                        context, 'updated_his_profile_picture')
                                    .toString()
                                : translate(
                                        context, 'updated_her_profile_picture')
                                    .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                  ],
                  if (widget.posts?.images != null &&
                      widget.posts?.images![0].mediaPath
                              .toString()
                              .contains("cover") ==
                          true) ...[
                    widget.posts?.sharedPost != null
                        ? const SizedBox.shrink()
                        : Text(
                            widget.posts!.user!.gender == 'Male'
                                ? translate(
                                        context, 'updated_his_profile_cover')
                                    .toString()
                                : translate(
                                        context, 'updated_her_profile_cover')
                                    .toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                  ],
                ],
              ),
            ),
            subtitle: widget.posts?.user?.avatar != null
                ? Row(
                    children: [
                      Text(
                        "${widget.posts?.createdHuman!}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      if (widget.posts!.user!.id == getUserData.value.id)
                        const Text(' . '),
                      if (widget.posts!.user!.id == getUserData.value.id)
                        InkWell(
                          onTap: () {
                            bottomSheet();
                          },
                          child: selectedIcon ??
                              icondata[widget.posts!.privacy.toInt() - 1],
                        )
                    ],
                  )
                : const SizedBox.shrink(),
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
                      topRight: Radius.circular(10),
                    ),
                  ),
                  context: context,
                  builder: (context) => widget.widget!,
                );
              },
              child: const Icon(Icons.more_vert),
            ),
          ),
        );
      },
    );
  }
}
