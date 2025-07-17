import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/screens/pages/detail_page.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/utils/utils.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/notifcation_model.dart';
import 'package:link_on/screens/tabs/profile/notifications/notification_provider.dart';
import 'package:link_on/screens/post_details/post_details.page.dart';
import '../../../../PokeScreens/poke_screen.dart';

class NotificationTile extends StatefulWidget {
  final NotificationModel? notification;

  final int index;

  const NotificationTile({
    Key? key,
    this.notification,
    required this.index,
  }) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  showEmoji() {
    if (widget.notification!.type2 == '1' ||
        widget.notification!.type2 == '0') {
      return Image.asset(
        'assets/fbImages/like.gif',
        width: 20.0,
        height: 20.0,
      );
    } else if (widget.notification!.type2 == '2') {
      return Image.asset(
        'assets/fbImages/love.gif',
        width: 20.0,
        height: 20.0,
      );
    } else if (widget.notification!.type2 == '3') {
      return Image.asset(
        'assets/fbImages/wow.gif',
        width: 20.0,
        height: 20.0,
      );
    } else if (widget.notification!.type2 == '4') {
      return Image.asset(
        'assets/fbImages/sad.gif',
        width: 20.0,
        height: 20.0,
      );
    } else if (widget.notification!.type2 == '5') {
      return Image.asset(
        'assets/fbImages/angry.gif',
        width: 20.0,
        height: 20.0,
      );
    } else if (widget.notification!.type2 == '6') {
      return Image.asset(
        'assets/fbImages/haha.gif',
        width: 20.0,
        height: 20.0,
      );
    } else {
      return Container();
    }
  }

  int? index;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvier>(context, listen: false);

    final userImage = CircularImage(
      size: 60,
      image: widget.notification?.notifier?.avatar ?? "",
    );

    content() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.notification!.type == "admin_notification"
              ? RichText(
                  text: TextSpan(
                    text: widget.notification!.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                )
              : widget.notification?.notifier?.firstName != ""
                  ? RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileTab(
                                    userId: widget.notification!.notifierId!,
                                  ),
                                ),
                              );
                            },
                          text: "${widget.notification?.notifier?.firstName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(width: 3)),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileTab(
                                      userId: widget.notification!.notifierId!,
                                    ),
                                  ),
                                );
                              },
                            text: "${widget.notification?.notifier?.lastName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(width: 5)),
                          TextSpan(
                            text: "${widget.notification?.text}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ]))
                  : RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileTab(
                                    userId: widget.notification!.notifierId!,
                                  ),
                                ),
                              );
                            },
                          text: "${widget.notification?.notifier?.username}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          children: [
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: SizedBox(width: 5),
                          ),
                          TextSpan(
                            text: "${widget.notification?.typeText}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                          ),
                        ])),
          const SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.notification!.time!.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // widget.notification!.type == "poked-user" &&
              //         widget.notification!.isPoked == false
              //     ? SizedBox(
              //         height: 25,
              //         child: ElevatedButton.icon(
              //           onPressed: () {
              //             Future.delayed(const Duration(milliseconds: 200), () {
              //               showLottiePopup(context);
              //               pokeProvider
              //                   .pokeUser(widget.notification!.notifierId)
              //                   .then((val) {
              //                 setState(() {
              //                   widget.notification?.isPoked = true;
              //                 });
              //               });
              //             });
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor:
              //                 AppColors.primaryColor, // Button color
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //                   BorderRadius.circular(20), // Rounded corners
              //             ),
              //             padding: EdgeInsets.symmetric(
              //               horizontal: 5,
              //               vertical: 2,
              //             ), // Padding
              //           ),
              //           label: Padding(
              //             padding: const EdgeInsets.only(right: 8),
              //             child: Text(
              //               "Poke back",
              //               style: TextStyle(color: Colors.white, fontSize: 12),
              //             ),
              //           ),
              //           icon: Icon(Icons.sign_language,
              //               color: Colors.white, size: 16),
              //         ),
              //       )
              //     : SizedBox.shrink(),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Dismissible(
        key: Key(
          widget.notification!.id.toString(),
        ),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) async {
          dynamic res = await apiClient
              .deleteNotificationById(widget.notification!.id.toInt());
          provider.deleteNotificationByIndex(widget.index);
          if (res['code'] == "200") {
            toast(res['message']);
          }
        },
        direction: DismissDirection.endToStart,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: widget.notification!.seen == "1"
              ? Colors.transparent
              : Colors.grey.withOpacity(0.1),
          padding: const EdgeInsets.only(left: 5, right: 5),
          height: 80,
          onPressed: widget.notification!.type == "admin_notification"
              ? () {}
              : widget.notification!.type == "viewed-story"
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileTab(
                            userId: widget.notification!.notifierId!,
                          ),
                        ),
                      );
                    }
                  : widget.notification!.postId != "0"
                      ? () {
                          apiClient.markNotificationAsRead(
                            widget.notification!.id.toInt(),
                            context,
                          );
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsPage(
                                  index: widget.index,
                                  postid: widget.notification!.postId,
                                ),
                              ),
                            );
                          }
                        }
                      : widget.notification!.groupId != "0"
                          ? () {
                              apiClient.markNotificationAsRead(
                                  widget.notification!.id.toInt(), context);
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => DetailsGroup(
                              //     ),
                              //   ),
                              // );
                            }
                          : widget.notification!.pageId != "0"
                              ? () {
                                  apiClient.markNotificationAsRead(
                                      widget.notification!.id.toInt(), context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                        pageid: widget.notification!.pageId,
                                      ),
                                    ),
                                  );
                                }
                              : widget.notification!.type == "poked-user"
                                  ? () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PokeListPage()));
                                    }
                                  : () {
                                      apiClient.markNotificationAsRead(
                                          widget.notification!.id.toInt(),
                                          context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileTab(
                                            userId: widget
                                                .notification!.notifierId!,
                                          ),
                                        ),
                                      );
                                    },
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.notification!.type == "Admin-Notification"
                  ? Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                          fit: BoxFit.cover,
                        ),
                      ))
                  : userImage,
              Utils.horizontalSpacer(space: 10.0),
              Expanded(
                child: content(),
              ),
              widget.notification!.type == "Viewed_Story" ||
                      widget.notification!.type == 'view_profile'
                  ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: const Icon(
                        Icons.remove_red_eye,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    )
                  : widget.notification!.type == "Comment"
                      ? Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.comment,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : widget.notification!.type == "Accepted-Request"
                          ? Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.check,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : widget.notification!.type == "tag-user"
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    LineIcons.tag,
                                    size: 18,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : widget.notification!.type == "share-post"
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          shape: BoxShape.circle),
                                      child: const Icon(
                                        Icons.share,
                                        size: 18,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : widget.notification!.type == "poked-user"
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            CupertinoIcons
                                                .hand_point_right_fill,
                                            size: 18,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : widget.notification!.type ==
                                              "sent_request"
                                          ? Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.2),
                                                  shape: BoxShape.circle),
                                              child: const Icon(
                                                Icons.person_add,
                                                size: 18,
                                                color: AppColors.primaryColor,
                                              ),
                                            )
                                          : widget.notification!.type ==
                                                  "post-reaction"
                                              ? Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle),
                                                  child: Center(
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: showEmoji(),
                                                    ),
                                                  ),
                                                )
                                              : widget.notification!.typeText ==
                                                      "comment_reaction"
                                                  ? Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withOpacity(0.2),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Center(
                                                        child: SizedBox(
                                                            height: 20,
                                                            width: 20,
                                                            child: Icon(
                                                              Icons.thumb_up,
                                                              color: AppColors
                                                                  .primaryColor,
                                                              size: 18,
                                                            )),
                                                      ),
                                                    )
                                                  : widget.notification!.type ==
                                                          "Like-page"
                                                      ? Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.2),
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: const Center(
                                                            child: SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                                child: Icon(
                                                                  Icons.flag,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  size: 18,
                                                                )),
                                                          ),
                                                        )
                                                      : widget.notification!
                                                                  .type ==
                                                              "Join-group"
                                                          ? Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.2),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: SizedBox(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: Icon(
                                                                    Icons.group,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : widget.notification!
                                                                      .type ==
                                                                  "new_post"
                                                              ? Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            0.2),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      const Center(
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: AppColors
                                                                            .primaryColor,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
            ],
          ),
        ),
      ),
    );
  }
}
