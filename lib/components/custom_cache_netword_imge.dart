import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String? imageUrl;
  final BoxFit? cover;
  const CustomCachedNetworkImage(
      {super.key,
      this.height,
      this.width,
      this.imageUrl,
      this.cover = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      height: height,
      fit: cover,
      width: MediaQuery.sizeOf(context).width,
      progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.1),
        child: Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
