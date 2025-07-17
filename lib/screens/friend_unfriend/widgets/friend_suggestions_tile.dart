import 'package:flutter/material.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/FriendProvider/friends_suggestions_Provider.dart';
import 'package:link_on/controllers/FriendProvider/userModel/user_model_friend&follow.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendSuggestiontile extends StatefulWidget {
  final UserModelFriendandFollow? data;
  final int? index;

  const FriendSuggestiontile({super.key, this.data, this.index});

  @override
  State<FriendSuggestiontile> createState() => _FriendSuggestiontileState();
}

class _FriendSuggestiontileState extends State<FriendSuggestiontile> {
  Future friendFollowUser({userId, name, cancelRequest, index}) async {
    customDialogueLoader(context: context);
    String url = 'make-friend';
    Map<String, dynamic> mapData = {"friend_two": userId};
    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      if (mounted) {
        Navigator.pop(context);
      }
      if (res["friend_status"] == "Not Friends") {
        if (cancelRequest == true) {
          toast("Request cancelled successfully");
          widget.data?.isfollowing = 0;
        } else {
          toast("Request cancelled successfully");
          widget.data?.isfollowing = 0;
        }
        widget.data?.ispending = 0;
        setState(() {});
      } else {
        toast("Request sent successfully");
        widget.data?.ispending = 1;
        setState(() {});
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast('Error: ${res['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileTab(
                        userId: widget.data!.id,
                      )));
        },
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(widget.data!.avatar.toString()),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data!.username.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                widget.data!.details!.mutualfriendsCount != null &&
                        widget.data!.details!.mutualfriendsCount != 0
                    ? Text(
                        "${widget.data!.details!.mutualfriendsCount} ${translate(context, 'mutual_friends')}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 4,
                ),
                widget.data!.ispending == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                friendFollowUser(
                                    userId: widget.data!.id,
                                    name: widget.data!.username,
                                    index: widget.index,
                                    cancelRequest: true);
                              },
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.lightgreen,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: MediaQuery.sizeOf(context).width * .3,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate(context, 'requested')
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<FriendFriendSuggestProvider>(context,
                                      listen: false)
                                  .reamovFriendAtIndex(index: widget.index);
                            },
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5)),
                              width: MediaQuery.sizeOf(context).width * .3,
                              child: Center(
                                  child: Text(
                                translate(context, 'remove').toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              friendFollowUser(
                                  userId: widget.data!.id,
                                  name: widget.data!.username);
                            },
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: MediaQuery.sizeOf(context).width * .3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    translate(context, 'add_friend').toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<FriendFriendSuggestProvider>(context,
                                      listen: false)
                                  .reamovFriendAtIndex(index: widget.index);
                            },
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: MediaQuery.sizeOf(context).width * .3,
                              child: Center(
                                  child: Text(
                                translate(context, 'remove').toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          )
                        ],
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
