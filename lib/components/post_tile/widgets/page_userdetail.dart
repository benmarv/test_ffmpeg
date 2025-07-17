import 'package:flutter/material.dart';
import 'package:link_on/models/posts.dart';

class PageUserDetail extends StatelessWidget {
  const PageUserDetail({
    super.key,
    this.posts,
    this.richFeelingTxt,
    this.onTab,
    this.widget,
  });
  final Posts? posts;
  final Widget? widget;
  final RichText? richFeelingTxt;
  final void Function()? onTab;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        minVerticalPadding: 0.0,
        dense: true,
        minLeadingWidth: 0.0,
        horizontalTitleGap: 4,
        contentPadding: EdgeInsets.zero,
        leading: GestureDetector(
          onTap: onTab,
          child: Hero(
            tag: posts!.page!.avatar!,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              backgroundImage: NetworkImage(posts!.page!.avatar!),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: onTab,
          child: Text(
            posts!.page!.pageTitle!.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              posts!.createdHuman.toString(),
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isDismissible:
                  true, // Set to true to allow dismissing on tap outside

              backgroundColor: Theme.of(context).colorScheme.secondary,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              context: context,
              builder: (context) => widget!,
            );
          },
          child: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
