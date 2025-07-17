import 'package:flutter/material.dart';
// import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class PostSkeleton extends StatelessWidget {
  const PostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.secondary,
        highlightColor:
            Theme.of(context).colorScheme.secondary.withOpacity(0.65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black,
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.black,
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        height: 10,
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.topRight,
                          child: const Icon(
                            Icons.more_vert,
                          ))),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
              width: MediaQuery.sizeOf(context).width * 0.4,
              height: 8,
            ),
            Container(
              height: 200,
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    topLeft: Radius.circular(5.0),
                  ),
                  color: Color(0xffe2e7e9)),
              child: const Icon(
                Icons.collections,
                size: 45,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.black,
                        width: MediaQuery.sizeOf(context).width * 0.1,
                        height: 10,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      iconText(
                        icon: LineIcons.comment,
                        context: context,
                        size: 14.0,
                        text: translate(context, 'comments'),
                      ),
                      const SizedBox(width: 7),
                      iconText(
                        icon: LineIcons.share,
                        context: context,
                        size: 14.0,
                        text: translate(context, 'share'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black12,
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconText(
                    icon: LineIcons.thumbs_up,
                    context: context,
                    size: 20,
                    text: translate(context, 'like'),
                  ),
                  iconText(
                    icon: LineIcons.comment,
                    context: context,
                    size: 20,
                    text: translate(context, 'comments'),
                  ),
                  iconText(
                    icon: LineIcons.share,
                    context: context,
                    size: 20,
                    text: translate(context, 'share'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

iconText(
    {text,
    icon,
    color = AppColors.postBottomColor,
    press,
    double? size,
    context}) {
  return Row(
    children: [
      Icon(
        icon,
        size: size,
        color: color,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        text,
        style: TextStyle(color: color, fontSize: 12),
      ),
    ],
  );
}
