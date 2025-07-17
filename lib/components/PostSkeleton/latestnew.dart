import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LatestNewsShimmer extends StatefulWidget {
  const LatestNewsShimmer({super.key});

  @override
  State<LatestNewsShimmer> createState() => _LatestNewsShimmerState();
}

class _LatestNewsShimmerState extends State<LatestNewsShimmer> {
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
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              width: 100,
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.black,
                    width: MediaQuery.sizeOf(context).width * .5,
                    height: 10,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    color: Colors.black,
                    width: MediaQuery.sizeOf(context).width * .5,
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
