import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/models/users_stories_model.dart';
import 'package:link_on/utils/Spaces/custom_bottom_sheet.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:story_view/story_view.dart';
import 'widgets/story_views.dart';

class StoryPageView extends StatefulWidget {
  final Stories? data;
  final bool? type;

  const StoryPageView({
    super.key,
    this.data,
    required this.type,
  });

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final StoryController _storyController = StoryController();
  String? storyIdForStoryViews;
  int? storyIndex;
  List<Story>? otherUserStories;

  @override
  void initState() {
    super.initState();
    otherUserStories = widget.data!.stories
        .where((story) => story.userId == widget.data!.stories[0].userId)
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _storyController.dispose();
  }

  static List<Shadow> shodow = [
    Shadow(blurRadius: 1, offset: Offset(0.3, 0.3))
  ];
  Duration adjustedDuration = const Duration(seconds: 30);
  Duration storyVideoDuration(duration) {
    return int.parse(duration) > 30
        ? adjustedDuration
        : Duration(seconds: int.parse(duration));
  }

  StoryItem storyView({required Story story}) {
    return story.type == 'text'
        ? StoryItem.text(
            key: Key(story.id.toString()),
            title: story.description!,
            shown: true,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            backgroundColor: const Color(0xff2F4E6E),
            duration: const Duration(seconds: 10))
        : story.type != 'video'
            ? StoryItem.pageImage(
                key: Key(story.id.toString()),
                caption: story.description != ''
                    ? Text(
                        story.description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
                url: story.media.toString(),
                controller: _storyController,
                shown: true,
                duration: const Duration(seconds: 10))
            : StoryItem.pageVideo(
                key: Key(story.id.toString()),
                story.media.toString(),
                controller: _storyController,
                caption: story.description != ''
                    ? Text(
                        story.description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
                shown: true,
                duration: storyVideoDuration(story.duration),
              );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: Consumer<GetUserStoryProvider>(
          builder: (context, consumerValue, child) => Stack(
            children: [
              StoryView(
                repeat: false,
                onStoryShow: (value, index) {
                  storyIndex = index;
                  storyIdForStoryViews = widget.type == true
                      ? consumerValue.userStories[index].id
                      : otherUserStories![index].id;

                  print('story id : $storyIdForStoryViews');

                  if (widget.type == false) {
                    consumerValue.increaseStorySeen(
                        storyId: storyIdForStoryViews.toString());
                  }
                },
                storyItems: widget.type == true
                    ? consumerValue.userStories
                        .map((story) => storyView(story: story))
                        .toList()
                    : otherUserStories!
                        .map((story) => storyView(story: story))
                        .toList(),
                controller: _storyController,
                onComplete: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back,
                                shadows: shodow, color: Colors.white)),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius: 1, offset: Offset(0.3, 0.3))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  widget.data!.avatar!,
                                ),
                                fit: BoxFit.cover),
                            color: Colors.grey,
                          ),
                        ),
                        15.sw,
                        Text(widget.data!.username!,
                            style: TextStyle(
                                color: Colors.white,
                                shadows: shodow,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        4.sw,
                        widget.data!.verified == "1"
                            ? verified()
                            : const SizedBox.shrink(),
                        if (getStringAsync("user_id") ==
                            widget.data!.stories[0].userId) ...[
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.15),
                          GestureDetector(
                            onTap: () {
                              _storyController.pause();
                              showModelBottomSheet(
                                  isScroll: true,
                                  colors: Colors.white,
                                  context: context,
                                  widget: StoryviewsCount(
                                    userId: widget.data!.stories[0].userId,
                                    storyId: storyIdForStoryViews.toString(),
                                  )).then((value) => _storyController.play());
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                shadows: shodow,
                                size: 20,
                              ),
                            ),
                          ),
                          10.sw,
                          GestureDetector(
                            onTap: () {
                              _showDeleteConfirmationDialog(context, () {
                                consumerValue.deleteStory(
                                  userId: widget.data!.stories[0].userId,
                                  storyId: storyIdForStoryViews.toString(),
                                  index: storyIndex,
                                  context: context,
                                );
                              });
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.delete,
                                shadows: shodow,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, VoidCallback onDelete) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            translate(context, 'confirm_delete_story')
                .toString(), // Your translation key for confirmation
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                onDelete(); // Call delete function
                Navigator.of(context).pop(true); // Close the dialog
              },
              child: Text(
                translate(context, 'yes').toString(),
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(false); // Just close the dialog
              },
              child: Text(
                translate(context, 'no').toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
