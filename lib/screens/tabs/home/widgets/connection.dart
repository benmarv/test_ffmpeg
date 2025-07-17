import 'package:flutter/cupertino.dart';
import 'package:link_on/controllers/getUserStroyProvider/get_user_story_provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/controllers/randomVideoProvider/random_video_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';

class ConnectionCheck extends StatelessWidget {
  const ConnectionCheck({super.key});

  @override
  Widget build(BuildContext context) {
    RandomVideoProvider randomVideoProvider =
        Provider.of<RandomVideoProvider>(context, listen: false);
    PostProvider postProvider =
        Provider.of<PostProvider>(context, listen: false);
    GetUserStoryProvider getUserStoryProvider =
        Provider.of<GetUserStoryProvider>(context, listen: false);

    return SliverList(
        delegate: SliverChildListDelegate([
      SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              translate(context, 'timeout_no_internet')!,
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoButton(
              color: AppColors.primaryColor,
              child: Text(
                translate(context, 'load_data')!,
              ),
              onPressed: () {
                postProvider.getApiDataProvider(context: context);
                if (randomVideoProvider.randomVideoListProvider.isEmpty) {
                  randomVideoProvider.gertRandomVideo(
                      context: context, isHome: false);
                }

                getUserStoryProvider.getUsersStories(
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    ]));
  }
}
