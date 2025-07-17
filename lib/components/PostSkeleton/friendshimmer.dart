import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FriendShimmer extends StatefulWidget {
  const FriendShimmer({super.key});

  @override
  State<FriendShimmer> createState() => _FriendShimmerState();
}

class _FriendShimmerState extends State<FriendShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              width: MediaQuery.sizeOf(context).width * .2,
              height: 85,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black,
                  width: MediaQuery.sizeOf(context).width * .5,
                  height: 10,
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.black,
                  width: MediaQuery.sizeOf(context).width * .5,
                  height: 10,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      color: Colors.black,
                      width: MediaQuery.sizeOf(context).width * .6,
                      height: 30,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
