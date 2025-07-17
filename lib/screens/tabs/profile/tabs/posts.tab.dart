// ignore_for_file: library_private_types_in_public_api

import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';

class PostsTab extends StatefulWidget {
  final dynamic userId;
  final ScrollController? controller;

  const PostsTab({
    required this.userId,
    this.controller,
    Key? key,
  }) : super(key: key);
  @override
  _PostsTabState createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  @override
  void initState() {
    log('Running......');
    super.initState();

    Map<String, dynamic> mapData = {
      'user_id': widget.userId ?? getStringAsync("user_id"),
      "limit": 6,
    };
    Provider.of<ProfilePostsProvider>(context, listen: false)
        .getUsersPosts(context: context, mapData: mapData);
    widget.controller?.addListener(() {
      var provider = Provider.of<ProfilePostsProvider>(context, listen: false);
      var postId = provider
          .getProfilePostProviderList[
              provider.getProfilePostProviderList.length - 1]
          .id;
      Map<String, dynamic> mapData2 = {
        'user_id': widget.userId ?? getStringAsync("user_id"),
        "limit": 6,
        "last_post_id": postId
      };
      if ((widget.controller?.position.maxScrollExtent ==
              widget.controller?.position.pixels) &&
          provider.loading == false) {
        provider.getUsersPosts(mapData: mapData2, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(builder: (context, value, child) {
      return value.loading == true && value.getProfilePostProviderList.isEmpty
          ? ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const Padding(
                    padding: EdgeInsets.only(
                      left: 2,
                      right: 2,
                    ),
                    child: PostSkeleton());
              },
            )
          : value.loading == false && value.getProfilePostProviderList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(
                      translate(context, 'no_posts')!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // controller: widget.controller,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,

                      // controller: _scrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.getProfilePostProviderList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            // bottom: 20.0,
                            left: 2,
                            right: 2,
                          ),
                          child: PostTile(
                            isProfilePosts: true,
                            posts: value.getProfilePostProviderList[index],
                            index: index,
                          ),
                        );
                      },
                    ),
                    if (value.loading == true &&
                        value.getProfilePostProviderList.isNotEmpty) ...[
                      const PostSkeleton()
                    ],
                  ],
                );
    });
  }
}
