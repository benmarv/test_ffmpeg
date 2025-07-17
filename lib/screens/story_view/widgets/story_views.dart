import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';

class StoryviewsCount extends StatefulWidget {
  final dynamic storyId;
  final String? userId;
  const StoryviewsCount({super.key, this.storyId, this.userId});

  @override
  State<StoryviewsCount> createState() => _StoryviewsCountState();
}

class _StoryviewsCountState extends State<StoryviewsCount> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    GetUserStoryProvider getUserStoryProvider =
        Provider.of<GetUserStoryProvider>(context, listen: false);

    getUserStoryProvider.makeViewsEmpty();
    getUserStoryProvider.getStoriesViesCount(storyId: widget.storyId);
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        int postId = getUserStoryProvider.viewsList.length;
        if ((_scrollController.position.maxScrollExtent ==
                _scrollController.position.pixels) &&
            getUserStoryProvider.loading == false) {
          getUserStoryProvider.getStoriesViesCount(
              storyId: widget.storyId, afterPostId: postId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Wrap(
        children: [
          Container(
            height: 65,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  10.sh,
                  bottomSheetTopDivider(color: Colors.white),
                  // 10.sh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<GetUserStoryProvider>(
                          builder: (context, value, child) {
                        return Text(
                          value.viewsList.isEmpty
                              ? "${translate(context, 'viewed_by')} 0"
                              : "${translate(context, 'viewed_by')} ${value.viewsList.length}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          10.sh,
          Consumer<GetUserStoryProvider>(
            builder: (context, value, child) {
              return value.viewsList.isEmpty
                  ? Center(
                      child: Text(translate(context, 'no_viewer')!),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => 4.sh,
                        shrinkWrap: true,
                        itemCount: value.viewsList.length,
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 15,
                            backgroundImage: NetworkImage(
                                value.viewsList[index].avatar.toString()),
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${value.viewsList[index].username}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              4.sw,
                              value.viewsList[index].isVerified == "1"
                                  ? verified()
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
          Consumer<GetUserStoryProvider>(
            builder: (context, value, child) {
              return (value.loading == true && value.viewsList.isNotEmpty)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
