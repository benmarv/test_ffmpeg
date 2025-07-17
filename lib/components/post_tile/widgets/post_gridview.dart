import 'package:flutter/material.dart';
import 'package:link_on/components/custom_cache_netword_imge.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/post_details/details.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostGripView extends StatelessWidget {
  const PostGripView({super.key, required this.photmulti, this.onTab});
  final List<Audio>? photmulti;
  final void Function()? onTab;
  @override
  Widget build(BuildContext context) {
    return photmulti?.length == 2
        ? postData2(context)
        : photmulti?.length == 3
            ? multiPostData3()
            : photmulti?.length == 4
                ? multiPostData4()
                : photmulti?.length == 5
                    ? multiPostData5()
                    : photmulti!.length > 5
                        ? multiPostData6Greater()
                        : const SizedBox.shrink();
  }

  postData2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTab ??
                      () {
                        _imageView(context, 0);
                      },
                  child: Container(
                    height: 239,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(photmulti![0].mediaPath!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTab ??
                      () {
                        _imageView(context, 1);
                      },
                  child: Container(
                    height: 239,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(photmulti![1].mediaPath!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  multiPostData3() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GridView.custom(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  const QuiltedGridTile(2, 2),
                  const QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate:
                  SliverChildBuilderDelegate(childCount: 3, (context, index) {
                return GestureDetector(
                  onTap: onTab ??
                      () {
                        _imageView(context, index);
                      },
                  child: CustomCachedNetworkImage(
                    imageUrl: photmulti![index].mediaPath!,
                  ),
                );
              }),
            ),
          ],
        ));
  }

  multiPostData4() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTab,
              child: GridView.custom(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(2, 2),
                  ],
                ),
                childrenDelegate:
                    SliverChildBuilderDelegate(childCount: 4, (context, index) {
                  return GestureDetector(
                    onTap: onTab ??
                        () {
                          _imageView(context, index);
                        },
                    child: CustomCachedNetworkImage(
                      imageUrl: photmulti![index].mediaPath!,
                    ),
                  );
                }),
              ),
            ),
          ],
        ));
  }

  multiPostData5() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GridView.custom(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 6,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 3),
                ],
              ),
              childrenDelegate:
                  SliverChildBuilderDelegate(childCount: 5, (context, index) {
                return GestureDetector(
                  onTap: onTab ??
                      () {
                        _imageView(context, index);
                      },
                  child: CustomCachedNetworkImage(
                    imageUrl: photmulti![index].mediaPath!,
                  ),
                );
              }),
            ),
          ],
        ));
  }

  multiPostData6Greater() {
    int data = photmulti!.length;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GridView.custom(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 6,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 2),
                  const QuiltedGridTile(2, 2),
                  const QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate:
                  SliverChildBuilderDelegate(childCount: 5, (context, index) {
                return GestureDetector(
                  onTap: onTab ??
                      () {
                        _imageView(context, index);
                      },
                  child: CustomCachedNetworkImage(
                    imageUrl: photmulti![index].mediaPath!,
                  ),
                );
              }),
            ),
            Positioned(
              bottom: 40,
              right: 40,
              child: Text(
                "+${data - 5}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ));
  }

  void _imageView(BuildContext context, index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsList(
                  photo: photmulti!,
                  index: index,
                )));
  }
}
