import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/post_content.dart';
import 'package:link_on/models/posts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/localization/localization_constant.dart';

class ProductDisplay extends StatelessWidget {
  const ProductDisplay(
      {super.key, this.posts, this.index, this.onTab, this.widget});
  final Posts? posts;
  final int? index;
  final Widget? widget;
  final void Function()? onTab;
  @override
  Widget build(BuildContext context) {
    return posts!.sharedPost != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: onTab,
              child: SizedBox(
                child: Column(
                  children: [
                    widget!,
                    posts!.sharedPost!.postText != null
                        ? PostContent(
                            data: posts!.sharedPost!.postText,
                          )
                        : const SizedBox(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: posts!.sharedPost!.product!.images.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: posts!
                                      .sharedPost!.product!.images[0].image!,
                                  height: 239,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.sizeOf(context).width,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.sizeOf(context).width *
                                                0.1),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              AppColors.primaryColor),
                                    )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Container(
                                  height: 239,
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.55,
                                    child: Text(
                                      "${posts?.sharedPost!.product?.productName}",
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        translate(context, 'price').toString() +
                                            " ", // Translated Key
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryColor),
                                      ),
                                      Text(
                                        "${posts?.sharedPost!.product?.price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        " (${posts?.sharedPost!.product?.currency})",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate(context, 'category')
                                                .toString() +
                                            " ", // Translated Key
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryColor),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.4,
                                        child: Text(
                                          posts!.sharedPost!.product!.category
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.primaryColor,
                                        size: 16,
                                      ),
                                      Text(
                                        "${posts?.sharedPost!.product?.location}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (posts!.user!.id != getStringAsync('user_id'))
                                OutlinedButton(
                                  onPressed: onTab,
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  child: Text(
                                    // posts!.user!.id == getStringAsync('user_id')
                                    //     ? translate(context, 'edit')
                                    //         .toString() // Translated Key
                                    //     :
                                    translate(context, 'buy_now')
                                        .toString(), // Translated Key
                                    style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: onTab,
            child: SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: posts!.product!.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: posts!.product!.images[0].image!,
                            height: 239,
                            fit: BoxFit.cover,
                            width: MediaQuery.sizeOf(context).width,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.sizeOf(context).width * 0.1),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryColor),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(
                            height: 239,
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: Text(
                                "${posts?.product?.productName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * .9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width *
                                        .9 /
                                        2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate(context, 'price')
                                                  .toString() +
                                              " ", // Translated key
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryColor),
                                        ),
                                        Text(
                                          "${posts?.product?.price}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          " (${posts?.product?.currency})",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width *
                                        .9 /
                                        2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          translate(context, 'category')
                                                  .toString() +
                                              '  ', // Translated key

                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryColor,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  .8 /
                                                  3,
                                          child: Text(
                                            posts!.product!.category.toString(),
                                            overflow: TextOverflow.visible,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.primaryColor,
                                        size: 16,
                                      ),
                                      Text(
                                        " ${posts!.product?.location}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  if (posts!.user!.id !=
                                      getStringAsync('user_id'))
                                    OutlinedButton(
                                      onPressed: onTab,
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.primaryColor),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      child: Text(
                                        // posts!.user!.id == getStringAsync('user_id')
                                        //     ? translate(context, 'edit')
                                        //         .toString() // Translated key
                                        //     :
                                        translate(context, 'buy_now')
                                            .toString(), // Translated key
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
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
