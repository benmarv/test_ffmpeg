import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GroupsShimmer extends StatelessWidget {
  const GroupsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.secondary.withOpacity(0.65),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black,
              width: MediaQuery.sizeOf(context).width * 0.1,
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
