import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/product_model/product_model.dart';
import 'package:link_on/screens/products/product_detail.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, this.productsModel, this.index});
  final ProductsModel? productsModel;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProducDetail(
                    productModel: productsModel,
                    index: index,
                    isHomePost: false,
                  )));
        },
        child: PhysicalModel(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          elevation: 0,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .45,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: productsModel!.images[0].image.toString(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Colors.grey[300], // Placeholder background color
                        ),
                        child: Center(
                          child:
                              CircularProgressIndicator(), // Loading indicator
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300], // Error background color
                        ),
                        child: Center(
                          child: Icon(Icons.error,
                              color: Colors.red), // Error icon
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .4,
                  child: Text(
                    "${productsModel?.productName}",
                    maxLines: 1,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.price_change_outlined,
                      size: 12,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .2,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 12,
                          ),
                          text: "${productsModel?.price} ",
                          children: [
                            const WidgetSpan(
                                alignment: PlaceholderAlignment.baseline,
                                baseline: TextBaseline.alphabetic,
                                child: SizedBox(width: 2)),
                            TextSpan(
                                text: productsModel!.currency.toString(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .3,
                      child: Text(
                        "${productsModel?.location}",
                        maxLines: 1,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
