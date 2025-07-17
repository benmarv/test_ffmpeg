import 'package:flutter/material.dart';
import 'package:link_on/components/PostSkeleton/friendshimmer.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/controllers/FriendProvider/friend_request_provider.dart';
import 'package:link_on/viewModel/api_client.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({super.key});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FriendFollowRequestProvider followRequestProvider =
        Provider.of<FriendFollowRequestProvider>(context, listen: false);
    followRequestProvider.makeFriendRequestEmpty();
    followRequestProvider.friendFollowRequest();

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          followRequestProvider.checkData == true) {
        followRequestProvider.friendFollowRequest(
          offset: followRequestProvider.followRequestList.length,
        );
      }
    });
  }

  Future requestAction({action, userId, index}) async {
    customDialogueLoader(context: context);
    String url = "friend-request-action";
    Map<String, dynamic> mapData = {
      "user_id": userId,
      "request_action": action
    };

    dynamic res =
        await apiClient.callApiCiSocial(apiPath: url, apiData: mapData);
    if (res["code"] == '200') {
      Navigator.pop(context);
      if (action == "accept") {
        toast("Accept friend request successsfully");
      } else {
        toast("Friend request cancel sccessfully");
      }

      Provider.of<FriendFollowRequestProvider>(context, listen: false)
          .reamovFriendAtIndex(index: index);
    } else {
      Navigator.pop(context);
      toast('Error: ${res['message']}');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = HeaderText(
      text: translate(context, 'friend_requests'),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Consumer<FriendFollowRequestProvider>(
                builder: (context, value, child) {
              return value.checkData == false
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return const FriendShimmer();
                          },
                        ),
                      ),
                    )
                  : (value.checkData == true && value.followRequestList.isEmpty)
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading(),
                              Text(
                                translate(context, 'no_requests_found')
                                    .toString(),
                              ),
                            ],
                          ),
                        )
                      : Scrollbar(
                          trackVisibility: true,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.followRequestList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                            image: value
                                                                .followRequestList[
                                                                    index]
                                                                .avatar!,
                                                          )));
                                            },
                                            child: PhysicalModel(
                                              color: Colors.grey.shade400,
                                              shape: BoxShape.circle,
                                              elevation: 2.0,
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                    value
                                                        .followRequestList[
                                                            index]
                                                        .avatar!),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfileTab(
                                                                userId: value
                                                                    .followRequestList[
                                                                        index]
                                                                    .id,
                                                              )));
                                                },
                                                child: Text(
                                                  "${value.followRequestList[index].username}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              value
                                                          .followRequestList[
                                                              index]
                                                          .details!
                                                          .mutualfriendsCount !=
                                                      0
                                                  ? Text(
                                                      "${value.followRequestList[index].details!.mutualfriendsCount} mutual friend",
                                                      style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  : const SizedBox.shrink(),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        .30,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: WidgetStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5))),
                                                        backgroundColor:
                                                            WidgetStateProperty
                                                                .all(AppColors
                                                                    .primaryColor),
                                                      ),
                                                      onPressed: () {
                                                        requestAction(
                                                            action: "accept",
                                                            userId: value
                                                                .followRequestList[
                                                                    index]
                                                                .id,
                                                            index: index);
                                                      },
                                                      child: Text(
                                                        translate(context,
                                                                'accept')
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        .30,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          shape: WidgetStateProperty.all(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5))),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.grey
                                                                      .shade300)),
                                                      onPressed: () {
                                                        requestAction(
                                                            action: "decline",
                                                            userId: value
                                                                .followRequestList[
                                                                    index]
                                                                .id,
                                                            index: index);
                                                      },
                                                      child: Text(
                                                        translate(context,
                                                                'cancel')
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }
}
