import 'package:flutter/material.dart';
import 'package:link_on/components/PostSkeleton/friendshimmer.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/friend_unfriend/widgets/friend_suggestions_tile.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/controllers/FriendProvider/friends_suggestions_Provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class FriendSuggestions extends StatefulWidget {
  const FriendSuggestions({super.key});

  @override
  State<FriendSuggestions> createState() => _FriendSuggestionsState();
}

class _FriendSuggestionsState extends State<FriendSuggestions> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FriendFriendSuggestProvider friendSuggestProvider =
        Provider.of<FriendFriendSuggestProvider>(context, listen: false);
    friendSuggestProvider.makeFriendSuggestedEmtyList();
    Map<String, dynamic> mapData = {
      "limit": 10,
    };
    friendSuggestProvider.friendSuggestUserList(mapData: mapData);

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          friendSuggestProvider.check == true) {
        friendSuggestProvider.friendSuggestUserList(
          mapData: mapData,
          offset: friendSuggestProvider.suggestionfriend.length,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = HeaderText(
      text: translate(context, 'people_you_may_know'),
    );
    return Consumer<FriendFriendSuggestProvider>(
      builder: (context, value, child) {
        return (value.check == true && value.suggestionfriend.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loading(),
                  Text(
                    translate(context, 'no_suggestions_found').toString(),
                  ),
                ],
              )
            : value.check == true && value.suggestionfriend.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        header,
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            itemCount: value.suggestionfriend.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return FriendSuggestiontile(
                                data: value.suggestionfriend[index],
                                index: index,
                              );
                            }),
                        value.hitApi == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  )
                : value.check == false
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              header,
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return const FriendShimmer();
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
      },
    );
  }
}
