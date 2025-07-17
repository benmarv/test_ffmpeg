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
import 'package:link_on/screens/friend_unfriend/friend_tab.dart';
import 'package:link_on/viewModel/api_client.dart';

class UserSentRequest extends StatefulWidget {
  const UserSentRequest({super.key});

  @override
  State<UserSentRequest> createState() => _UserSentRequestState();
}

class _UserSentRequestState extends State<UserSentRequest> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FriendFollowRequestProvider followRequestProvider =
        Provider.of<FriendFollowRequestProvider>(context, listen: false);
    followRequestProvider.makeUserSentFriendRequestEmpty();
    followRequestProvider.friendYourFollowRequest();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          followRequestProvider.checkData == true) {
        followRequestProvider.friendYourFollowRequest(
          offset: followRequestProvider.followRequestList.length,
        );
      }
    });
  }

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

      if (res["friend_status"] == "Unfriend") {
        if (cancelRequest == true) {
          setState(() {});
          toast(translate(context, 'request_cancelled')!);
        } else {
          setState(() {});
          toast(translate(context, 'request_cancelled')!);
        }
      } else {
        toast(translate(context, 'request_sent')!);
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = HeaderText(text: translate(context, 'your_sent_requests')!);

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendTabs(),
                  ));
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
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
                  : (value.yourFollowRequestList.isEmpty)
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading(),
                              Text(translate(context, 'no_request_found')!),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: value.yourFollowRequestList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              image: value
                                                  .yourFollowRequestList[index]
                                                  .avatar!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: PhysicalModel(
                                        color: Colors.grey.shade400,
                                        shape: BoxShape.circle,
                                        elevation: 2.0,
                                        child: CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(value
                                              .yourFollowRequestList[index]
                                              .avatar!),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
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
                                                              .yourFollowRequestList[
                                                                  index]
                                                              .id,
                                                        )));
                                          },
                                          child: Text(
                                            "${value.yourFollowRequestList[index].username}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        value
                                                    .yourFollowRequestList[
                                                        index]
                                                    .details!
                                                    .mutualfriendsCount !=
                                                0
                                            ? Text(
                                                "${value.yourFollowRequestList[index].details!.mutualfriendsCount} ${translate(context, 'mutual_friend')}",
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            : const SizedBox.shrink(),
                                        GestureDetector(
                                          onTap: () {
                                            friendFollowUser(
                                              userId: value
                                                  .yourFollowRequestList[index]
                                                  .id,
                                              name: value
                                                  .yourFollowRequestList[index]
                                                  .username,
                                              index: index,
                                            ).then((_) {
                                              value.reamovYourSentFriendAtIndex(
                                                  index: index);
                                            });
                                          },
                                          child: Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                                color: AppColors.lightgreen,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .27,
                                            child: Center(
                                                child: Text(
                                              translate(context, 'requested')!,
                                              style: const TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }
}
