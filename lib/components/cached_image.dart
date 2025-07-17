import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final bool? isVideo;

  const CachedImage({
    Key? key,
    this.isVideo,
    required this.url,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: isVideo == true ? 200 : 250,
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: url!,
              placeholder: (context, url) {
                return const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(
                  Icons.error,
                );
              },
            ),
          ),
        ),
        if (isVideo == true)
          SizedBox(
            height: isVideo == true ? 200 : 250,
            width: 250,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.play_arrow,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
