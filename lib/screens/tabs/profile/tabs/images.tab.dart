import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/PostSkeleton/imageshimmer.dart';
import 'package:link_on/components/custom_cache_netword_imge.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/controllers/profile_post_provider.dart/profile_post_provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ImagesTab extends StatefulWidget {
  final dynamic userId;
  final ScrollController? controller;

  const ImagesTab({
    this.userId,
    this.controller,
    Key? key,
  }) : super(key: key);
  @override
  _ImagesTabState createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab> {
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> mapData = {
      'user_id': widget.userId ?? getStringAsync("user_id"),
      "limit": 6,
      "post_type": "1"
    };
    ProfilePostsProvider profilePostsProvider =
        Provider.of<ProfilePostsProvider>(context, listen: false);
    if (profilePostsProvider.getProfileImages.isEmpty &&
        profilePostsProvider.loading == false) {
      profilePostsProvider.getUsersPosts(context: context, mapData: mapData);
    }
    widget.controller?.addListener(() {
      dev.log("images tabsss ======>>>");
      var postId = profilePostsProvider
          .getProfileImages[profilePostsProvider.getProfileImages.length - 1]
          .id;
      Map<String, dynamic> mapData2 = {
        'user_id': widget.userId ?? getStringAsync("user_id"),
        "limit": 6,
        "last_post_id": postId,
        "post_type": "1"
      };
      if ((widget.controller?.position.maxScrollExtent ==
              widget.controller?.position.pixels) &&
          profilePostsProvider.loading == false) {
        profilePostsProvider.getUsersPosts(mapData: mapData2, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostsProvider>(builder: (context, value, child) {
      return (value.loading == true && value.getProfileImages.isEmpty)
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const ImageShimmer();
              },
            )
          : (value.loading == false && value.getProfileImages.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading(),
                    Text(
                      translate(context, 'no_data_found')!,
                    ),
                  ],
                )
              : SizedBox(
                  child: SingleChildScrollView(
                    // controller: widget.controller,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width * .012,
                          vertical: 5),
                      child: Wrap(
                        spacing: MediaQuery.sizeOf(context).width * .014,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: [
                          for (int i = 0;
                              i < value.getProfileImages.length;
                              i++) ...[
                            if (value.getProfileImages[i].images != '' &&
                                value.getProfileImages[i].images != null) ...[
                              for (int j = 0;
                                  j < value.getProfileImages[i].images!.length;
                                  j++) ...[
                                DisplayUserImages(
                                  imageUrl: value
                                      .getProfileImages[i].images![j].mediaPath,
                                ),
                              ]
                            ] else ...[
                              DisplayUserImages(
                                imageUrl: value
                                    .getProfileImages[i].images![0].mediaPath,
                              ),
                            ],
                          ],
                          if (value.loading == true &&
                              value.getProfileImages.isNotEmpty) ...[
                            const ImageShimmer(),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
    });
  }
}

class DisplayUserImages extends StatelessWidget {
  final String? imageUrl;
  const DisplayUserImages({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        image: imageUrl.toString(),
                      )));
        },
        child: SizedBox(
          height: 100,
          width: MediaQuery.sizeOf(context).width * .31,
          child: CustomCachedNetworkImage(
            imageUrl: imageUrl.toString(),
          ),
        ),
      ),
    );
  }
}
