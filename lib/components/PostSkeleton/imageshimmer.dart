import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ImageShimmer extends StatelessWidget {
  const ImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              width: MediaQuery.sizeOf(context).width * .32,
              height: 100,
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width * .01),
            Container(
              color: Colors.black,
              width: MediaQuery.sizeOf(context).width * .32,
              height: 100,
            ),
            SizedBox(width: MediaQuery.sizeOf(context).width * .01),
            Container(
              color: Colors.black,
              width: MediaQuery.sizeOf(context).width * .32,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
