import 'package:flutter/material.dart';
import 'package:link_on/controllers/SavePostProvider/save_post_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/screens/SavePosts/save_posts_list.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class SavePosts extends StatefulWidget {
  const SavePosts({Key? key}) : super(key: key);

  @override
  State<SavePosts> createState() => _SavePostsState();
}

class _SavePostsState extends State<SavePosts> {
  @override
  void initState() {
    super.initState();
    Provider.of<SaveProvider>(context, listen: false)
        .savePostList(context: context)
        .then((val) {
      log("save post list length ${Provider.of<SaveProvider>(context, listen: false).savepostlist.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          translate(context, 'saved').toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<SaveProvider>(builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * .02,
            vertical: 10,
          ),
          child: value.isdata == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loader(),
                    Text(translate(context, 'loading').toString()),
                  ],
                )
              : (value.isdata == true && value.savepostlist.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_saved_post_found')
                            .toString()),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: MediaQuery.sizeOf(context).width * .05,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: [
                          for (int i = 0; i < value.savepostlist.length; i++)
                            SavedPostList(post: value.savepostlist[i], index: i)
                        ],
                      ),
                    ),
        );
      }),
    );
  }
}
