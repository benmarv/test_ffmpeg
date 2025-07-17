import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/CustomDialogues/delete_dialogue.dart';
import 'package:link_on/controllers/CommentsProvider/comment_provider2.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/components/PostSkeleton/post_skeleton.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/components/post_tile/post_tile.dart';
import 'package:link_on/models/page_data.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/controllers/PageProvider/like_page.dart';
import 'package:link_on/controllers/postProvider/post_provider_temp.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, this.pageid});
  final String? pageid;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Posts> pagepostlist = [];
  // bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    PostProviderTemp pagePostsProvider =
        Provider.of<PostProviderTemp>(context, listen: false);
    pagePostsProvider.makePostListEmpty();

    Provider.of<PostComments2>(context, listen: false).makeEmptyList2();

    pagePostsProvider
        .getPostData(context: context, mapData: {"page_id": widget.pageid});

    _scrollController.addListener(() {
      var provider = Provider.of<PostProviderTemp>(context, listen: false);

      var postId = provider.postListTemp[provider.postListTemp.length - 1].id;

      if ((_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels) &&
          provider.loading == false) {
        provider.getPostData(
            mapData: {"page_id": widget.pageid, "last_post_id": postId},
            context: context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  PageData? pagedata;

  Color likeByMe(list) {
    Color color = AppColors.buttongrey;
    if (list[0]["is_liked"] == true) {
      color = AppColors.primaryColor;
    } else {
      color = AppColors.buttongrey;
    }
    return color;
  }

  String totalLikesCount(list) {
    String toatalCounts = "0";
    toatalCounts = list[0]["likes_count"];
    return toatalCounts;
  }

  bool flag = false;
  Usr? user;
  Future<void> getUserData(userid) async {
    dynamic res = await apiClient.get_user_data(userId: userid);
    if (res["code"] == '200') {
      user = Usr.fromJson(res["data"]);
      flag = true;
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        PostProviderTemp pagePostsProvider =
            Provider.of<PostProviderTemp>(context, listen: false);
        // pagePostsProvider.makePostListEmpty();
        pagePostsProvider
            .getPostData(context: context, mapData: {"page_id": widget.pageid});
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: user?.id == getStringAsync("user_id")
            ? FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createPost,
                      arguments: CreatePostPage(
                          pageId: widget.pageid, val: true, flag: true));
                },
                child: const Icon(Icons.edit),
              )
            : Container(),
        body: FutureBuilder<Map<String, dynamic>>(
          future:
              apiClient.getPageData(widget.pageid, getStringAsync('user_id')),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!["data"];

              pagedata = PageData.fromJson(data);
              if (flag == false) {
                getUserData(pagedata!.userId);
              }

              Provider.of<LikePageProvider>(context, listen: false)
                  .likeCountList(
                isLike: pagedata?.isLiked,
                likesCount: pagedata?.likesCount,
                userId: pagedata?.userId,
                pageId: pagedata?.id,
              );
              return SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                image: pagedata!.cover,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: MediaQuery.sizeOf(context).width,
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(pagedata!.cover.toString()),
                                fit: BoxFit.cover),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      blurRadius: 1, offset: Offset(0.3, 0.3))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 120, left: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          image: pagedata!.avatar,
                                        )));
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        pagedata!.avatar.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 245, left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pagedata!.pageTitle.toString(),
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Consumer<LikePageProvider>(
                                      builder: (context, value, child) {
                                        return Row(
                                          children: [
                                            Text(
                                              totalLikesCount(value.likesData),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              translate(context, 'likes')
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    // CourseDescription(
                                    //   description:
                                    //       pagedata!.pageDescription.toString(),
                                    // )
                                    ReadMoreText(
                                      pagedata!.pageDescription.toString(),
                                      trimLines: 2,
                                      trimLength: 100,
                                      style: const TextStyle(
                                        textBaseline: TextBaseline.alphabetic,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      trimCollapsedText:
                                          translate(context, 'more_text')
                                              .toString(),
                                      trimExpandedText:
                                          translate(context, 'show_less')
                                              .toString(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (pagedata?.isPageOwner == false)
                                          ? Consumer<LikePageProvider>(
                                              builder: (context, value, child) {
                                              return MaterialButton(
                                                minWidth: 130,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                color: AppColors.primaryColor,
                                                onPressed: () {
                                                  if (pagedata!.isLiked ==
                                                      true) {
                                                    value.likePage(
                                                        pageId: pagedata!,
                                                        index: 0,
                                                        value: false);
                                                  } else {
                                                    value.likePage(
                                                        pageId: pagedata!,
                                                        index: 0,
                                                        value: true);
                                                  }
                                                },
                                                child: Center(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        pagedata!.isLiked ==
                                                                true
                                                            ? Icons
                                                                .thumb_up_alt_rounded
                                                            : Icons
                                                                .thumb_up_off_alt_outlined,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        pagedata!.isLiked ==
                                                                true
                                                            ? translate(context,
                                                                    'liked')
                                                                .toString()
                                                            : translate(context,
                                                                    'like')
                                                                .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                          : MaterialButton(
                                              minWidth: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              color: AppColors.primaryColor,
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    AppRoutes.updatePage,
                                                    arguments: pagedata);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    translate(context,
                                                            'edit_page')
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      (pagedata?.isPageOwner == false)
                                          ? MaterialButton(
                                              minWidth: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  isDismissible: true,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return SizedBox(
                                                      child: ListTile(
                                                        leading: const Icon(
                                                          CupertinoIcons
                                                              .arrowshape_turn_up_right_fill,
                                                        ),
                                                        title: Text(
                                                          translate(context,
                                                                  'share')
                                                              .toString(),
                                                        ),
                                                        onTap: () {
                                                          Share.share(
                                                            pagedata!
                                                                .callActionTypeUrl
                                                                .toString(),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.more_vert,
                                              ))
                                          : MaterialButton(
                                              minWidth: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  isDismissible:
                                                      true, // Set to true to allow dismissing on tap outside
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return SizedBox(
                                                      height: 170,
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            leading: Icon(
                                                                Icons.delete),
                                                            title: Text(translate(
                                                                    context,
                                                                    'delete_page')
                                                                .toString()),
                                                            onTap: () {
                                                              deletDialouge(
                                                                title: translate(
                                                                    context,
                                                                    'delete_page'),
                                                                context:
                                                                    context,
                                                                id: widget
                                                                    .pageid,
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons.update),
                                                            title: Text(
                                                              translate(context,
                                                                      'update_page')
                                                                  .toString(),
                                                            ),
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                AppRoutes
                                                                    .updatePage,
                                                                arguments:
                                                                    pagedata,
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(
                                                              CupertinoIcons
                                                                  .arrowshape_turn_up_right_fill,
                                                            ),
                                                            title: Text(
                                                              translate(context,
                                                                      'share')
                                                                  .toString(),
                                                            ),
                                                            onTap: () {
                                                              Share.share(
                                                                pagedata!
                                                                    .callActionTypeUrl
                                                                    .toString(),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child:
                                                  const Icon(Icons.more_vert),
                                            )
                                    ]),
                                7.sh,
                                Divider(
                                  color: Colors.grey.shade500,
                                  thickness: 1,
                                ),
                                10.sh,
                                Text(
                                  translate(context, 'details').toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                pagedata!.pageCategory != ""
                                    ? Row(
                                        children: [
                                          const Icon(Icons.local_offer),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            pagedata!.pageCategory.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 10,
                                ),
                                pagedata!.website != '' &&
                                        pagedata!.website != null
                                    ? Row(
                                        children: [
                                          const Icon(Icons.link),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.80,
                                            child: Text(
                                              pagedata!.website.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 5,
                                ),
                                pagedata!.address != null &&
                                        pagedata!.address != "" &&
                                        pagedata!.address != "null"
                                    ? Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            pagedata!.address.toString(),
                                            style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      )
                                    : Container(),
                                7.sh,
                                Divider(
                                  color: Colors.grey.shade500,
                                  thickness: 1,
                                ),
                                Text(
                                  translate(context, 'page_posts').toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          Consumer<PostProviderTemp>(
                              builder: (context, value, child) {
                            return value.postListTemp.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: value.postListTemp.length,
                                    itemBuilder: (context, index) {
                                      return PostTile(
                                        tempPost: true,
                                        posts: value.postListTemp[index],
                                        index: index,
                                      );
                                    })
                                : AspectRatio(
                                    aspectRatio: 16 / 8,
                                    child: Center(
                                      child: Text(
                                        translate(
                                          context,
                                          'no_posts_available',
                                        ).toString(),
                                      ),
                                    ),
                                  );
                          }),
                          context
                                  .watch<PostProviderTemp>()
                                  .postListTemp
                                  .isNotEmpty
                              ? context.watch<PostProviderTemp>().loading ==
                                      true
                                  ? const PostSkeleton()
                                  : const SizedBox.shrink()
                              : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
