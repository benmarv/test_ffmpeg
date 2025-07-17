import 'package:flutter/material.dart';
import 'package:link_on/consts/appconfig.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/createstory/create_story.dart';
import 'package:link_on/screens/story_view/story_view.page.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/liveStream_Provider/live_stream_provider.dart';
import 'package:link_on/models/users_stories_model.dart';
import 'package:link_on/screens/create_post/live_stream_screen.dart';
import 'package:link_on/screens/tabs/home/widgets/cusomt_story_card.dart';

Widget customListView({context, required String avatar}) {
  return SizedBox(
    height: 160,
    width: MediaQuery.sizeOf(context).width,
    child: ListView(scrollDirection: Axis.horizontal, children: [
      // Create Story
      _createStoryItem(context, avatar),
      // Live Users
      _liveUsers(context),
      // User Stories
      _userStories(context),
      // Other User Stories
      _otherUserStories(context),
      // Stories Placeholder
      _storiesPlaceholder(context),
    ]),
  );
}

Widget _createStoryItem(BuildContext context, String avatar) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateStory()),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      height: 120,
      width: 90,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        children: [
          Container(
            height: 110,
            width: 90,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                image: DecorationImage(
                    image: NetworkImage(
                      avatar.toString(),
                    ),
                    fit: BoxFit.cover)),
          ),
          Baseline(
            baseline: 2,
            baselineType: TextBaseline.alphabetic,
            child: PhysicalModel(
              color: Colors.grey.shade300,
              elevation: 1,
              borderRadius: BorderRadius.circular(100),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    radius: 16.0,
                    backgroundColor: AppColors.primaryColor,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateStory(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            translate(context, 'create_story').toString(),
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

Widget _liveUsers(BuildContext context) {
  return Consumer<LiveStreamProvider>(builder: (context, value, child) {
    return value.liveUserData.isEmpty
        ? const SizedBox.shrink()
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: value.liveUserData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveStreamScreen(
                          isHome: true,
                          userId: value.liveUserData[index].id,
                          loggedInUser: getStringAsync("user_id"),
                          token: value.liveUserData[index].agoraAccessToken,
                          avatar: value.liveUserData[index].avatar,
                          username: value.liveUserData[index].username,
                          channelName: value.liveUserData[index].username,
                          isVerified: value.liveUserData[index].isVerified,
                        ),
                      ));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 120,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 90,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(value
                                    .liveUserData[index].avatar
                                    .toString()),
                                fit: BoxFit.cover)),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${value.liveUserData[index].firstName} ${value.liveUserData[index].lastName}",
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          height: 15,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(3)),
                          alignment: Alignment.center,
                          child: Text(
                            translate(context, 'live')!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
  });
}

Widget _userStories(BuildContext context) {
  return Consumer<GetUserStoryProvider>(builder: (context, value, child) {
    Stories stories = Stories.fromJson(value.userDataStoryMap);
    return value.userDataStoryMap.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoryPageView(
                            type: true,
                            data: stories,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              height: 120,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: 90,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(stories.stories[0].type ==
                                    'image'
                                ? stories.stories[0].media.toString()
                                : stories.stories[0].type == 'video'
                                    ? stories.stories[0].thumbnail.toString()
                                    : '${AppConfig.baseUrl}public/storybg/storybg.PNG'),
                            fit: BoxFit.cover)),
                    alignment: Alignment.bottomLeft,
                    child: Stack(
                      children: [
                        stories.stories[0].type == 'text'
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: Text(
                                  stories.stories[0].description.toString(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Text(
                            stories.username.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PhysicalModel(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                      child: CircleAvatar(
                        radius: 13.0,
                        backgroundColor: AppColors.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: PhysicalModel(
                            color: Colors.grey.shade300,
                            elevation: 1,
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 13.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              backgroundImage:
                                  NetworkImage(stories.avatar.toString()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  });
}

Widget _otherUserStories(BuildContext context) {
  return Consumer<GetUserStoryProvider>(builder: (context, value, child) {
    return value.otherDataStortList.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: value.otherDataStortList.length,
            itemBuilder: (context, index) {
              Stories stories =
                  Stories.fromJson(value.otherDataStortList[index]);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryPageView(
                                type: false,
                                data: stories,
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 120,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 90,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(stories.stories[0].type ==
                                        'image'
                                    ? stories.stories[0].media.toString()
                                    : stories.stories[0].type == 'video'
                                        ? stories.stories[0].thumbnail
                                            .toString()
                                        : '${AppConfig.baseUrl}public/storybg/storybg.PNG'),
                                fit: BoxFit.cover)),
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: [
                            stories.stories[0].type == 'text'
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(5),
                                    child: Text(
                                      stories.stories[0].description.toString(),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : Container(),
                            Positioned(
                              bottom: 5,
                              left: 5,
                              child: SizedBox(
                                width: 80,
                                child: Text(
                                  stories.username.toString(),
                                  maxLines: 2,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: PhysicalModel(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 13.0,
                            backgroundColor:
                                AppColors.primaryColor.withOpacity(.8),
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: PhysicalModel(
                                color: Colors.grey.shade300,
                                elevation: 1,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 13.0,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      NetworkImage(stories.avatar.toString()),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const SizedBox.shrink();
  });
}

Widget _storiesPlaceholder(BuildContext context) {
  return Consumer<GetUserStoryProvider>(builder: (context, value, child) {
    if (value.userDataStoryMap.isEmpty && value.otherDataStortList.isEmpty) {
      return const CustomStoryCard();
    }
    return const SizedBox
        .shrink(); // Return an empty SizedBox if the condition is met
  });
}
