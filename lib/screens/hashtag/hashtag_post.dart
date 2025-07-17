import 'package:flutter/material.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:link_on/controllers/CommentsProvider/comment_provider2.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class HashtagPost extends StatefulWidget {
  const HashtagPost({super.key, this.tag});
  final String? tag;
  @override
  State<HashtagPost> createState() => _HashtagPostState();
}

class _HashtagPostState extends State<HashtagPost> {
  Map<String, dynamic> mapData = {};
  @override
  void initState() {
    super.initState();
    mapData["hashtag"] = widget.tag;
    PostProviderTemp pagePostsProvider = Provider.of<PostProviderTemp>(
      context,
      listen: false,
    );
    pagePostsProvider.makePostListEmpty();
    Provider.of<PostComments2>(context, listen: false).makeEmptyList2();
    Provider.of<PostProviderTemp>(context, listen: false).getPostData(
      mapData: mapData,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Consumer<PostProviderTemp>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 7, 21, 43)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "#",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tag.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${value.postListTemp.length} ${translate(context, 'trending_posts')}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(
                  thickness: 9,
                  color: Colors.grey.shade300,
                ),
                value.postListTemp.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.postListTemp.length,
                        itemBuilder: (context, index) {
                          return PostTile(
                            tempPost: true,
                            posts: value.postListTemp[index],
                            index: index,
                          );
                        })
                    : value.loading == false && value.postListTemp.isEmpty
                        ? AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Center(
                              child: Text(
                                translate(context, 'No posts available')!,
                              ),
                            ),
                          )
                        : value.loading == true && value.postListTemp.isEmpty
                            ? const PostSkeleton()
                            : const SizedBox.shrink(),
                if (value.loading == true &&
                    value.postListTemp.isNotEmpty == true)
                  const PostSkeleton()
              ],
            ),
          );
        }),
      ),
    );
  }
}
