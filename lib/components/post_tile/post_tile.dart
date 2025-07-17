// ignore_for_file: library_private_types_in_public_api, unrelated_type_equality_checks
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/flutter_feed_reaction/flutter_feed_reaction.dart';
import 'package:link_on/components/post_content.dart';
import 'package:link_on/components/post_tile/widgets/advertisement_form.dart';
import 'package:link_on/components/post_tile/widgets/donation_post.dart';
import 'package:link_on/components/post_tile/widgets/dontaion_detail.dart';
import 'package:link_on/components/post_tile/widgets/poll_post.dart';
import 'package:link_on/components/post_tile/widgets/tagged_people_details.dart';
import 'package:link_on/components/save_post/global_save_post_id.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/pages/detail_page.dart';
import 'package:link_on/screens/post_details/post_details.page.dart';
import 'package:link_on/screens/products/product_detail.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/screens/tabs/home/widgets/post_events.dart';
import 'package:link_on/screens/tabs/profile/report_user.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/components/post_tile/widgets/page_userdetail.dart';
import 'package:link_on/components/post_tile/widgets/posts_userdetail.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/initialize_video_data/initialize_post_video_data.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../controllers/profile_post_provider.dart/profile_post_provider.dart';
import '../../screens/tabs/profile/profile.dart';
import 'widgets/group_userdetail.dart';
import 'widgets/post_data.dart';
import 'widgets/post_gridview.dart';
import 'widgets/posts_action.dart';
import 'widgets/product_display.dart';

class PostTile extends StatefulWidget {
  final Posts? posts;
  final bool? isMainPosts;
  final bool? detailPost;
  final int? index;
  final bool? tempPost;
  final bool? isgroup;
  final bool? isProfilePosts;
  const PostTile({
    super.key,
    required this.posts,
    this.isMainPosts,
    this.isProfilePosts,
    this.tempPost,
    this.isgroup,
    this.detailPost,
    this.index,
  });

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile>
    with SingleTickerProviderStateMixin {
  RichText? richFeelingTxt;
  final primaryColor = AppColors.primaryColor;
  late TextEditingController _captionController;
  SiteSetting? site;

  @override
  void initState() {
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    Future.delayed(const Duration(seconds: 2), () {
      _captionController = TextEditingController(text: widget.posts?.postText);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        var initalizeVideo =
            Provider.of<InitializePostVideoProvider>(context, listen: false);

        if (!initalizeVideo.initializePostVideoDataList
            .asMap()
            .containsKey(widget.index)) {
          initalizeVideo.addDataDataToList(index: widget.index);
        }
      }
    });
  }

  // void disableTileFor10Minutes() {
  //   setState(() {
  //     isTileEnable = false;
  //     lastPokeTime = DateTime.now();
  //   });

  //   // Re-enable the tile after 10 minutes
  //   Future.delayed(const Duration(seconds: 20), () {
  //     if (mounted) {
  //       setState(() {
  //         isTileEnable = true;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    if (widget.posts?.video != null) {
      var provider = Provider.of<InitializePostVideoProvider>(
        context,
        listen: false,
      );

      if (provider.flickManager != null) {
        provider.flickManager!.dispose();
      }
    }

    if (widget.posts?.sharedPost?.video != null) {
      var provider = Provider.of<InitializePostVideoProvider>(
        context,
        listen: false,
      );

      if (provider.flickManager != null) {
        provider.flickManager!.dispose();
      }
    }

    super.dispose();
  }

  Future<void> savepost({postid}) async {
    dynamic res = await apiClient.save_post(postid: postid);

    if (res['code'] == '200') {
      if (res["type"] == 0) {
        widget.posts!.isSaved = false;
        savePostMap[postid] = "unsave";
        toast(res["message"]);
        setState(() {});
      } else if (res["type"] == 1) {
        widget.posts!.isSaved = true;
        savePostMap[postid] = "save";
        toast(res["message"]);
        setState(() {});
      }
    } else {
      toast('Error: ${res['message']}');
    }
  }

  customCupOfCoffeeDialogue({data, id}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(context, 'cup_of_coffee').toString(),
          ),
          content: Text(data.toString()),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text(
                translate(context, 'give').toString(),
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                cupOfCofee(id);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                translate(context, 'cancel').toString(),
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  customGreatJobDialogue({data, id}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(context, 'great_job').toString(),
          ),
          content: Text(data.toString()),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text(
                translate(context, 'give').toString(),
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                greatJob(id);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                translate(context, 'cancel').toString(),
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future greatJob(id) async {
    String url = "post/great-job";
    Map<String, dynamic> mapData = {"post_id": id};
    dynamic res = await apiClient.callApiCiSocial(
      apiPath: url,
      apiData: mapData,
    );
    if (res["status"] == "200") {
      log(
        'Response of 200 ${res['message'].toString()}',
      );
      toast(res['message']);
    } else {
      log(
        'Response of Error ${res['message'].toString()}',
      );
      toast(res['message']);
    }
  }

  Future cupOfCofee(id) async {
    String url = "post/cup-of-coffee";
    Map<String, dynamic> mapData = {
      "post_id": id,
    };
    dynamic res = await apiClient.callApiCiSocial(
      apiPath: url,
      apiData: mapData,
    );
    if (res["status"] == "200") {
      log(
        'Response of 200 ${res['message'].toString()}',
      );
      toast(
        res['message'].toString(),
      );
    } else {
      log(
        'Response of Error ${res['message'].toString()}',
      );
      toast(
        res['message'].toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final actionsData = PostsAction(
      posts: widget.posts,
      isDetailPost: widget.detailPost,
    );
    final content = PostContent(
      data: widget.posts!.postText,
      postData: widget.posts,
    );
    final bottom = FlutterFeedReaction(
        dragSpace: 40,
        posts: widget.posts!,
        index: widget.index,
        isMainPosts: widget.isMainPosts,
        isProfilePost: widget.isProfilePosts,
        isPostDetail: widget.detailPost,
        tempPost: widget.tempPost);
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.posts!.page != null) ...[
              widget.posts!.pageId != '0'
                  ? widget.posts!.sharedPost != null
                      ? pageUserDetail()
                      : pageUserDetail(richFeelingTxt: richFeelingTxt)
                  : widget.posts!.sharedPost != null
                      ? userDetail()
                      : userDetail(richFeelingTxt: richFeelingTxt),
            ] else if (widget.isgroup != true) ...[
              widget.posts!.groupId != '0'
                  ? widget.posts!.sharedPost != null
                      ? groupUserDetail()
                      : groupUserDetail(richFeelingTxt: richFeelingTxt)
                  : widget.posts!.sharedPost != null
                      ? userDetail()
                      : userDetail(richFeelingTxt: richFeelingTxt),
            ],
            if (widget.isgroup == true) ...[
              widget.posts!.sharedPost != null
                  ? userDetail()
                  : userDetail(richFeelingTxt: richFeelingTxt),
            ],
            if (widget.posts!.postText != null &&
                widget.posts!.postText != '' &&
                widget.posts!.postType != 'donation' &&
                widget.posts!.postType != 'poll') ...[content],
            if (widget.posts!.sharedPost == null &&
                widget.posts!.parentId != '0' &&
                widget.posts!.postType != 'poll') ...[
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!.withOpacity(0.8),
                  ),
                ),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: screenWidth * 0.75,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(),
                            children: [
                              TextSpan(
                                text:
                                    translate(context, 'content_not_available'),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: translate(
                                    context, 'content_not_available_detail'),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.posts!.postType == 'poll' ||
                widget.posts!.poll != null ||
                (widget.posts!.sharedPost != null &&
                    widget.posts!.sharedPost!.poll != null)) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PollPost(
                  posts: widget.posts,
                  pollWidget: widget.posts?.sharedPost != null
                      ? sharePostDetail(richFeelingTxt)
                      : const SizedBox.shrink(),
                ),
              ),
            ]
            // else if (widget.posts!.postType == 'post' &&
            //     widget.posts!.postLocation != null) ...[
            //   Container(
            //     height: 200,
            //     child: LocationPost(
            //       posts: widget.posts,
            //       widget: widget.posts!.sharedPost != null
            //           ? sharePostDetail(richFeelingTxt)
            //           : const SizedBox(),
            //     ),
            //   ),
            // ]
            else if (widget.posts!.postType == 'donation' ||
                (widget.posts!.sharedPost != null &&
                    widget.posts!.sharedPost!.postType == 'donation')) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DonationPost(
                  posts: widget.posts,
                  onTab: _donationRoute,
                  pollWidget: widget.posts?.sharedPost != null
                      ? sharePostDetail(richFeelingTxt)
                      : const SizedBox.shrink(),
                ),
              ),
            ] else if (widget.posts?.product != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductDisplay(
                  posts: widget.posts,
                  onTab: _productRout,
                  widget: widget.posts?.sharedPost != null
                      ? sharePostDetail(richFeelingTxt)
                      : const SizedBox.shrink(),
                ),
              ),
            ] else if ((widget.posts!.sharedPost != null &&
                    widget.posts!.sharedPost!.event == null &&
                    widget.posts!.sharedPost!.product == null &&
                    widget.posts!.group != null) ||
                (widget.posts!.sharedPost != null &&
                    widget.posts!.sharedPost!.event == null &&
                    widget.posts!.sharedPost!.product == null &&
                    widget.posts!.page != null)) ...[
              PostData(
                posts: widget.posts,
                index: widget.index,
                shareInfo: sharePostDetail(richFeelingTxt),
                postDetailRoute: () {
                  if (widget.detailPost == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          image: widget.posts!.sharedPost!.images![0].mediaPath,
                        ),
                      ),
                    );
                  } else {
                    _postDetailRoute();
                  }
                },
              ),
            ] else if (widget.posts!.postText != '' &&
                widget.posts!.sharedPost != null &&
                widget.posts!.sharedPost!.event == null &&
                widget.posts!.sharedPost!.product == null) ...[
              PostData(
                posts: widget.posts,
                index: widget.index,
                shareInfo: sharePostDetail(richFeelingTxt),
                postDetailRoute: () {
                  if (widget.detailPost == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          image: widget.posts!.sharedPost!.images![0].mediaPath,
                        ),
                      ),
                    );
                  } else {
                    _postDetailRoute();
                  }
                },
              ),
            ] else if (widget.posts!.sharedPost != null) ...[
              if (widget.posts!.sharedPost!.event != null &&
                  widget.posts!.sharedPost!.audio == null &&
                  widget.posts!.sharedPost!.video == null &&
                  widget.posts!.sharedPost!.images == null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sharePostDetail(richFeelingTxt),
                        widget.posts!.sharedPost!.postText!.isNotEmpty &&
                                widget.posts!.sharedPost!.postText != null
                            ? PostContent(
                                data: widget.posts!.sharedPost!.postText,
                              )
                            : const SizedBox.shrink(),
                        PostEvents(
                          index: widget.index,
                          isMainPost: widget.isMainPosts,
                          isProfilePost: widget.isProfilePosts,
                          eventModel: widget.posts?.sharedPost!.event,
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (widget.posts!.sharedPost!.product != null &&
                  widget.posts!.sharedPost!.audio == null &&
                  widget.posts!.sharedPost!.video == null &&
                  widget.posts!.sharedPost!.images == null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: ProductDisplay(
                      posts: widget.posts,
                      onTab: _productRout,
                      widget: widget.posts?.sharedPost != null
                          ? sharePostDetail(richFeelingTxt)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ] else if ((widget.posts!.images != null &&
                    widget.posts!.images!.length == 1) ||
                widget.posts!.audio != null ||
                widget.posts!.video != null) ...[
              PostData(
                posts: widget.posts,
                index: widget.index,
                shareInfo: widget.posts?.sharedPost != null
                    ? sharePostDetail(richFeelingTxt)
                    : const SizedBox.shrink(),
                postDetailRoute: () {
                  if (widget.detailPost == true) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          image: widget.posts!.images![0].mediaPath,
                        ),
                      ),
                    );
                  } else {
                    _postDetailRoute();
                  }
                },
              ),
            ] else if (widget.posts?.images != "" &&
                widget.posts!.images != null) ...[
              _multiPostsView(richFeelingTxt),
            ] else if (widget.posts!.event != null) ...[
              widget.posts!.sharedPost != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sharePostDetail(richFeelingTxt),
                            widget.posts!.sharedPost!.postText!.isNotEmpty &&
                                    widget.posts!.sharedPost!.postText != null
                                ? PostContent(
                                    data: widget.posts!.sharedPost!.postText,
                                  )
                                : const SizedBox.shrink(),
                            PostEvents(
                              index: widget.index,
                              isMainPost: widget.isMainPosts,
                              isProfilePost: widget.isProfilePosts,
                              eventModel: widget.posts?.sharedPost!.event,
                            ),
                          ],
                        ),
                      ),
                    )
                  : PostEvents(
                      index: widget.index,
                      isMainPost: widget.isMainPosts,
                      isProfilePost: widget.isProfilePosts,
                      eventModel: widget.posts?.event,
                    ),
            ],
            const SizedBox(
              height: 5,
            ),
            actionsData,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Theme.of(context).colorScheme.secondary,
                thickness: 0.7,
              ),
            ),
            bottom,
            (site!.enableDisableGreatJob == '0' &&
                    site!.enableDisableCupOfCoffee == '0')
                ? const SizedBox.shrink()
                : Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            (site!.enableDisableGreatJob == '1' &&
                    site!.enableDisableCupOfCoffee == '1' &&
                    widget.posts!.userId != getStringAsync('user_id'))
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              site!.enableDisableCupOfCoffee == '0'
                                  ? const SizedBox.shrink()
                                  : MaterialButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      color: AppColors.postBottomColor,
                                      onPressed: () {
                                        log('Id...........${widget.posts!.id.toString()}');
                                        customCupOfCoffeeDialogue(
                                          data: translate(context,
                                              'great_job_confirmation_text'),
                                          id: int.parse(
                                            widget.posts!.id!,
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.coffee_outlined,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            translate(context, 'cup_of_coffee')
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                              SizedBox(width: 5),
                              MaterialButton(
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                color: AppColors.primaryColor,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AdvertisementCard(
                                      postId: widget.posts!.id,
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.ad_units,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      'Advertise',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              site!.enableDisableGreatJob == '0'
                                  ? const SizedBox.shrink()
                                  : MaterialButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      color: AppColors.gradientColor1,
                                      onPressed: () {
                                        customGreatJobDialogue(
                                          data: translate(context,
                                              'great_job_confirmation_text'),
                                          id: int.parse(
                                            widget.posts!.id.toString(),
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_up_outlined,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            translate(context, 'great_job')
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            const SizedBox(
              height: 5,
            ),
            if (widget.posts!.advertisement != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 0.5,
                ),
              ),
            if (widget.posts!.advertisement != null)
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(widget.posts!.advertisement!.link!);
                  await launchUrl(url);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                widget.posts!.advertisement!.image!,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Text(
                                    widget.posts!.advertisement!.link!,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.blue),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Text(
                                    widget.posts!.advertisement!.title!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Text(
                                    widget.posts!.advertisement!.body!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Center(
                              child: Text(
                                translate(context, 'learn_more').toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          height: 8,
        )
      ],
    );
  }

  checkDisability({postId, userId, List<Posts>? list}) {
    final isCommentsEnabled = widget.posts?.commentsStatus == "1";

    return ListTile(
      onTap: () {
        context.read<PostProvider>().setCommentDisable(
              index: widget.index!,
              context: context,
              eventScreen: widget.isMainPosts == true
                  ? "home"
                  : widget.isProfilePosts == true
                      ? "profile"
                      : widget.tempPost == true
                          ? "tempData"
                          : null,
              posts: widget.posts,
              flag: widget.detailPost,
            );
        Navigator.pop(context);
      },
      leading: Icon(
        isCommentsEnabled
            ? Icons.comments_disabled_outlined
            : Icons.comment_outlined,
        size: 24,
      ),
      title: Text(
        isCommentsEnabled
            ? translate(context, 'disable_comments').toString()
            : translate(context, 'enable_comments').toString(),
      ),
    );
  }

  Widget sharePostDetail(richFeelingTxt) {
    String displayNames() {
      if (widget.posts!.sharedPost!.taggedUsers != null) {
        if (widget.posts!.sharedPost!.taggedUsers!.length > 2) {
          return "${widget.posts!.sharedPost!.taggedUsers![0].username} ${translate(context, 'and').toString()} ${widget.posts!.sharedPost!.taggedUsers!.length - 1} ${translate(context, 'others').toString()}";
        } else if (widget.posts!.sharedPost!.taggedUsers!.length < 2) {
          return widget.posts!.sharedPost!.taggedUsers![0].username!;
        } else if (widget.posts!.sharedPost!.taggedUsers!.length == 2) {
          return "${widget.posts!.sharedPost!.taggedUsers![0].username!} ${translate(context, 'and').toString()} ${widget.posts!.sharedPost!.taggedUsers![1].username!}";
        }
        return widget.posts!.sharedPost!.taggedUsers![0].username!;
      } else {
        return '';
      }
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

    return GestureDetector(
      child: ValueListenableBuilder<Usr>(
        valueListenable: getUserData,
        builder: (context, userData, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
              minVerticalPadding: 0.0,
              dense: true,
              minLeadingWidth: 0.0,
              horizontalTitleGap: 4,
              contentPadding: EdgeInsets.zero,
              leading: widget.posts?.user?.avatar != null
                  ? GestureDetector(
                      onTap: () {
                        if (widget.isProfilePosts == true) {
                          return;
                        }
                        widget.posts!.pageId != "0"
                            ? const SizedBox.shrink()
                            : Navigator.of(context).pushNamed(
                                AppRoutes.profile,
                                arguments: widget.posts!.sharedPost!.user!.id,
                              );
                      },
                      child: CircularImageNetwork(
                        image: widget.posts?.sharedPost?.user?.id == userData.id
                            ? userData.avatar!
                            : widget.posts!.sharedPost!.user!.avatar!,
                        size: 30.0,
                      ),
                    )
                  : const SizedBox.shrink(),
              title: InkWell(
                onTap: widget.posts!.sharedPost!.pageId != "0"
                    ? () {
                        if (widget.isMainPosts != true) {
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                      pageid: widget.posts!.sharedPost!.pageId,
                                    )));
                      }
                    : () {
                        if (widget.isProfilePosts == true) {
                          return;
                        }
                        Navigator.of(context).pushNamed(
                          AppRoutes.profile,
                          arguments: widget.posts!.sharedPost!.user!.id,
                        );
                      },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: Wrap(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text:
                                  "${widget.posts!.sharedPost!.user!.firstName} ${widget.posts!.sharedPost!.user!.lastName}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              child: 3.sw,
                            ),
                            if (widget.posts!.sharedPost!.user!.isVerified ==
                                "1")
                              WidgetSpan(child: verified()),
                            WidgetSpan(
                              child: richFeelingTxt ?? const SizedBox.shrink(),
                            ),
                            if (widget.posts!.sharedPost!.taggedUsers != null)
                              TextSpan(
                                text:
                                    "${translate(context, 'is_with').toString()} ",
                                style: const TextStyle(fontSize: 13),
                              ),
                            if (widget.posts!.sharedPost!.taggedUsers != null)
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PostTaggedPeoples(
                                          taggedUsers: widget
                                              .posts!.sharedPost!.taggedUsers!,
                                        );
                                      },
                                    );
                                  },
                                text: displayNames(),
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            if (widget.posts!.sharedPost!.postLocation != '' &&
                                widget.posts!.sharedPost!.taggedUsers != null)
                              TextSpan(
                                text:
                                    " ${translate(context, 'in').toString()} ",
                                style: const TextStyle(fontSize: 13),
                              ),
                            if (widget.posts!.sharedPost!.postLocation != '' &&
                                widget.posts!.sharedPost!.taggedUsers == null)
                              TextSpan(
                                text:
                                    " ${translate(context, 'is_in').toString()} ",
                                style: const TextStyle(fontSize: 13),
                              ),
                            if (widget.posts!.sharedPost!.postLocation != '' ||
                                (widget.posts!.sharedPost!.taggedUsers !=
                                        null &&
                                    widget.posts!.sharedPost!.postLocation !=
                                        ''))
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openMap(widget
                                        .posts!.sharedPost!.postLocation!);
                                  },
                                text: widget.posts!.sharedPost!.postLocation!,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                      if (widget.posts!.sharedPost!.postType == 'poll') ...[
                        Text(
                          translate(context, 'added_new_poll').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                      if (widget.posts?.sharedPost!.product != null) ...[
                        Text(
                          translate(context, 'added_new_product').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                      if (widget.posts?.sharedPost!.event != null) ...[
                        Text(
                          translate(context, 'created_new_event').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (widget.posts?.sharedPost!.postType.toString() ==
                          "offer") ...[
                        Text(
                          translate(context, 'created_new_offer').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (widget.posts!.sharedPost!.images != null &&
                          widget.posts?.sharedPost!.images![0].mediaPath
                                  .toString()
                                  .contains("avatar") ==
                              true) ...[
                        Text(
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
                      if (widget.posts!.sharedPost!.images != null &&
                          widget.posts?.sharedPost!.images![0].mediaPath
                                  .toString()
                                  .contains("cover") ==
                              true) ...[
                        Text(
                          widget.posts!.user!.gender == 'Male'
                              ? translate(context, 'updated_his_profile_cover')
                                  .toString()
                              : translate(context, 'updated_her_profile_cover')
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
              ),
              subtitle: widget.posts?.sharedPost!.user?.avatar != null
                  ? Text(
                      "${widget.posts?.sharedPost!.createdHuman!}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }

  Widget userDetail({richFeelingTxt, data}) {
    return PostUserDetail(
      richFeelingTxt: richFeelingTxt,
      posts: widget.posts,
      widget: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bottomSheetTopDivider(color: primaryColor),
            const SizedBox(
              height: 20,
            ),
            if (widget.posts!.user!.id != getStringAsync('user_id')
                // && widget.posts.user.isFriend,
                )
              Consumer<ProfilePostsProvider>(
                  builder: (context, profileProvider, child) {
                return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      // Future.delayed(const Duration(milliseconds: 200), () {
                      //   showLottiePopup(context);
                      profileProvider.pokeUser(widget.posts!.userId);
                      // profileProvider.disableTileFor10Minutes();
                      // });
                    },
                    leading: Icon(Icons.pan_tool_alt),
                    title:
                        //  profileProvider.isPokeTileEnable
                        //     ?
                        Text(
                      translate(context, 'poke')!,
                    )
                    // : Text(translate(context, "already_poked").toString()),
                    );
              }),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AdvertisementCard(
                    postId: widget.posts!.id,
                  ),
                );
              },
              leading: const Icon(
                Icons.ads_click_sharp,
                size: 24,
              ),
              title: Text(
                translate(context, 'advertise_here').toString(),
              ),
            ),
            ListTile(
              onTap: () {
                savepost(postid: widget.posts!.id);
                Navigator.pop(context);
              },
              leading: Icon(
                widget.posts!.isSaved == false
                    ? Icons.bookmark_add_outlined
                    : Icons.bookmark_outlined,
                size: 24,
              ),
              title: widget.posts!.isSaved == false
                  ? Text(
                      translate(context, 'save_post').toString(),
                    )
                  : Text(
                      translate(context, 'unsave_post').toString(),
                    ),
            ),
            widget.posts?.userId != getStringAsync("user_id")
                ? const PopupMenuItem(height: 0.0, child: SizedBox.shrink())
                : checkDisability(
                    postId: widget.posts?.id,
                    userId: getStringAsync("user_id"),
                  ),
            if (widget.posts?.userId == getStringAsync("user_id") &&
                getUserData.value.userLevel!.editPost == '1' &&
                widget.posts!.postType != 'poll')
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showPostUpdateDialog(context);
                    },
                  );
                },
                leading: const Icon(
                  Icons.edit,
                  size: 24,
                ),
                title: Text(
                  translate(context, 'edit_post').toString(),
                ),
              ),
            if (widget.posts?.userId == getStringAsync("user_id")) ...[
              ListTile(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          translate(context, 'delete_post_confirmation')
                              .toString(),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () async {
                              Future.delayed(const Duration(seconds: 1),
                                  () => _callDeleMethod());
                              Navigator.pop(context);
                            },
                            child: Text(
                              translate(context, 'delete').toString(),
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              translate(context, 'back').toString(),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  size: 24,
                ),
                title: Text(
                  translate(context, 'delete_post').toString(),
                ),
              ),
            ],
            if (widget.posts?.userId !=
                getStringAsync(
                  "user_id",
                ))
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportUser(
                        postid: widget.posts!.id,
                      ),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.flag_outlined,
                  size: 24,
                ),
                title: Text(
                  translate(context, 'report_post').toString(),
                ),
              ),
            ListTile(
              onTap: () {
                // String url = LinkGenerator().createCustomLink(
                //   AppRoutes.postDetails,
                //   {"post_id": widget.posts!.id},
                // );
                Share.share(widget.posts!.postLink!);
                Navigator.pop(context);
              },
              leading: const Icon(
                Icons.share,
                size: 24,
              ),
              title: Text(
                translate(context, 'share_post').toString(),
              ),
            ),
          ],
        ),
      ),
      onTab: widget.posts!.pageId != "0"
          ? () {
              if (widget.isMainPosts != true) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    pageid: widget.posts!.pageId,
                  ),
                ),
              );
            }
          : () {
              if (widget.isProfilePosts == true) {
                return;
              }
              widget.posts!.pageId != "0"
                  ? const SizedBox.shrink()
                  : Navigator.of(context).pushNamed(
                      AppRoutes.profile,
                      arguments: widget.posts!.user!.id,
                    );
            },
    );
  }

  AlertDialog showPostUpdateDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text(translate(context, 'edit_your_post_text').toString()),
      titleTextStyle: TextStyle(
        fontSize: 17,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      content: TextField(
        controller: _captionController,
        decoration: InputDecoration(
          hintText: translate(context, 'enter_new_caption').toString(),
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(translate(context, 'cancel').toString()),
        ),
        MaterialButton(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () async {
            if (_captionController.text.isEmpty) {
              toast(
                translate(context, 'enter_text_to_edit').toString(),
              );
            } else {
              if (mounted) {
                Navigator.of(context).pop();
              }
              String newCaption = _captionController.text;
              //    setState(() {
              //   widget.posts?.postText = newCaption;
              // });
              dynamic response = await apiClient.callApiCiSocial(
                apiPath: 'post/update',
                apiData: {'post_id': widget.posts!.id, 'post_text': newCaption},
              );

              if (response['status'] == "200") {
                toast(response['message']);
                setState(() {
                  widget.posts?.postText = newCaption;
                });
              } else {
                toast(response['message']);
              }
            }
          },
          child: Text(
            translate(context, 'save').toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget groupUserDetail({richFeelingTxt}) {
    return GroupUserDetail(
      onTab: widget.posts!.pageId != "0"
          ? () {
              if (widget.isMainPosts != true) {
                return;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(
                            pageid: widget.posts!.pageId,
                          )));
            }
          : () {
              if (widget.isProfilePosts == true) {
                return;
              }
              widget.posts!.pageId != "0"
                  ? const SizedBox.shrink()
                  : Navigator.of(context).pushNamed(
                      AppRoutes.profile,
                      arguments: widget.posts!.user!.id,
                    );
            },
      richFeelingTxt: richFeelingTxt,
      posts: widget.posts,
      widget: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bottomSheetTopDivider(color: primaryColor),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                savepost(postid: widget.posts!.id);
                Navigator.pop(context);
              },
              leading: Icon(
                widget.posts!.isSaved == false
                    ? Icons.bookmark_add_outlined
                    : Icons.bookmark_outlined,
                size: 24,
              ),
              title: widget.posts!.isSaved == false
                  ? Text(translate(context, 'save_post').toString())
                  : Text(translate(context, 'unsave_post').toString()),
            ),
            widget.posts?.userId != getStringAsync("user_id")
                ? const PopupMenuItem(height: 0.0, child: SizedBox.shrink())
                : checkDisability(
                    postId: widget.posts?.id,
                    userId: getStringAsync("user_id"),
                  ),
            if (widget.posts?.userId == getStringAsync("user_id") &&
                getUserData.value.userLevel!.editPost == '1')
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showPostUpdateDialog(context);
                    },
                  );
                },
                leading: const Icon(
                  Icons.edit,
                  size: 24,
                ),
                title: Text(translate(context, 'edit_post').toString()),
              ),
            if (widget.posts?.userId == getStringAsync("user_id")) ...[
              ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(
                            translate(context, 'confirm_delete_post')
                                .toString(),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () async {
                                Future.delayed(const Duration(seconds: 1),
                                    () => _callDeleMethod());
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate(context, 'delete').toString(),
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate(context, 'back').toString(),
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    size: 24,
                  ),
                  title: Text(translate(context, 'delete_post').toString())),
            ],
            if (widget.posts?.userId != getStringAsync("user_id"))
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportUser(
                          postid: widget.posts!.id,
                        ),
                      ),
                    );
                  },
                  leading: const Icon(
                    Icons.flag_outlined,
                    size: 24,
                  ),
                  title: Text(translate(context, 'report_post').toString())),
            ListTile(
                onTap: () {
                  // String url = LinkGenerator().createCustomLink(
                  //     AppRoutes.postDetails, {"post_id": widget.posts!.id});
                  Share.share(widget.posts!.postLink!);
                  Navigator.pop(context);
                },
                leading: const Icon(
                  Icons.share,
                  size: 24,
                ),
                title: Text(translate(context, 'share_post').toString())),
          ],
        ),
      ),
    );
  }

  Widget pageUserDetail({richFeelingTxt}) {
    return PageUserDetail(
      onTab: widget.posts!.pageId != "0"
          ? () {
              if (widget.isMainPosts != true) {
                return;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(
                            pageid: widget.posts!.pageId,
                          )));
            }
          : () {
              if (widget.isProfilePosts == true) {
                return;
              }
              widget.posts!.pageId != "0"
                  ? const SizedBox.shrink()
                  : Navigator.of(context).pushNamed(
                      AppRoutes.profile,
                      arguments: widget.posts!.user!.id,
                    );
            },
      richFeelingTxt: richFeelingTxt,
      posts: widget.posts,
      widget: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            bottomSheetTopDivider(color: primaryColor),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                onTap: () {
                  savepost(postid: widget.posts!.id);
                  Navigator.pop(context);
                },
                leading: Icon(
                  widget.posts!.isSaved == false
                      ? Icons.bookmark_add_outlined
                      : Icons.bookmark_outlined,
                  size: 24,
                ),
                title: widget.posts!.isSaved == false
                    ? Text(translate(context, 'save_post').toString())
                    : Text(translate(context, 'unsave_post').toString())),
            widget.posts?.userId != getStringAsync("user_id")
                ? const PopupMenuItem(height: 0.0, child: SizedBox.shrink())
                : checkDisability(
                    postId: widget.posts?.id,
                    userId: getStringAsync("user_id"),
                  ),
            if (widget.posts?.userId == getStringAsync("user_id") &&
                getUserData.value.userLevel!.editPost == '1')
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showPostUpdateDialog(context);
                    },
                  );
                },
                leading: const Icon(
                  Icons.edit,
                  size: 24,
                ),
                title: Text(translate(context, 'edit_post').toString()),
              ),
            if (widget.posts?.userId == getStringAsync("user_id")) ...[
              ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(translate(context, 'confirm_delete_post')
                              .toString()),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () async {
                                Future.delayed(const Duration(seconds: 1),
                                    () => _callDeleMethod());
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate(context, 'delete').toString(),
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:
                                  Text(translate(context, 'back').toString()),
                            ),
                          ],
                        );
                      },
                    );
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    size: 24,
                  ),
                  title: Text(translate(context, 'delete_post').toString())),
            ],
            if (widget.posts?.userId != getStringAsync("user_id"))
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportUser(
                          postid: widget.posts!.id,
                        ),
                      ),
                    );
                  },
                  leading: const Icon(
                    Icons.flag_outlined,
                    size: 24,
                  ),
                  title: Text(translate(context, 'report_post').toString())),
            ListTile(
                onTap: () {
                  Share.share(widget.posts!.postLink!);
                  Navigator.pop(context);
                },
                leading: const Icon(
                  Icons.share,
                  size: 24,
                ),
                title: Text(translate(context, 'share_post').toString())),
          ],
        ),
      ),
    );
  }

  _callDeleMethod() {
    context.read<PostProvider>().deletePostProvider(
        postId: widget.posts?.id,
        eventScreen: widget.isMainPosts == true
            ? "home"
            : widget.isProfilePosts == true
                ? "profile"
                : widget.tempPost == true
                    ? "tempData"
                    : null,
        flag: widget.detailPost,
        index: widget.index,
        context: context);
  }

  Widget _multiPostsView(richFeelingTxt) {
    return widget.posts!.sharedPost != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sharePostDetail(richFeelingTxt),
                  widget.posts!.sharedPost!.postText != ""
                      ? PostContent(
                          data: widget.posts!.sharedPost!.postText,
                        )
                      : const SizedBox.shrink(),
                  PostGripView(
                      photmulti: widget.posts!.images,
                      onTab: widget.detailPost == true
                          ? null
                          : () {
                              _postDetailRoute();
                            })
                ],
              ),
            ),
          )
        : PostGripView(
            photmulti: widget.posts!.images,
            onTab: widget.detailPost == true
                ? null
                : () {
                    _postDetailRoute();
                  },
          );
  }

  void _postDetailRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsPage(
            isProfilePost: widget.isProfilePosts,
            isMainPosts: widget.isMainPosts,
            tempPost: widget.tempPost,
            index: widget.index,
            postid: widget.posts!.id!),
      ),
    );
  }

  void _productRout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProducDetail(
          isHomePost: widget.isMainPosts,
          isProfilePost: widget.isProfilePosts,
          index: widget.index,
          productModel: widget.posts!.sharedPost == null
              ? widget.posts!.product
              : widget.posts!.sharedPost!.product,
        ),
      ),
    );
  }

  void _donationRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DontaionDetailScreen(
          donationPost: widget.posts!,
          index: widget.index!,
        ),
      ),
    );
  }
}

void showLottiePopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Center(
        child: LottiePopup(),
      );
    },
  );
}
