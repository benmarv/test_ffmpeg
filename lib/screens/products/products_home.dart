import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/products/create_products.dart';
import 'package:link_on/screens/products/product_detail.dart';
import 'package:link_on/screens/products/products.dart';
import 'package:link_on/screens/products/widgets/product_card.dart';

class ProductsHomeScreen extends StatefulWidget {
  const ProductsHomeScreen({super.key});

  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final provider = Provider.of<GetProductProvider>(context, listen: false);
    provider.setScreenName = "get_product";
    getProducts();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          provider.laoding == false) {
        int id = provider.productList.length;
        provider.getProducts(afterPostId: id, screenName: 'get_product');
      }
    });
  }

  Future getProducts() async {
    final provider = Provider.of<GetProductProvider>(context, listen: false);
    provider.productList.clear();
    if (provider.productList.isEmpty) {
      await provider.getProducts(screenName: 'get_product');
    }
    setState(() {});
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateProducts()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Products(),
                ))),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              child: const Icon(
                Icons.person_pin,
                size: 24,
                color: AppColors.primaryColor,
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: (() => Navigator.pop(context)),
        ),
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 100,
              child: Image(
                  image: NetworkImage(
                getStringAsync("appLogo"),
              )),
            ),
            // Text(
            //   translate(context, 'marketplace').toString(),
            //   style: const TextStyle(
            //     fontStyle: FontStyle.italic,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
          ],
        ),
        elevation: 2,
      ),
      body: Consumer<GetProductProvider>(builder: (context, value, child) {
        value.setScreenName = "get_product";
        return (value.laoding == true && value.productList.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loader(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    translate(context, 'loading').toString(),
                  )
                ],
              )
            : (value.laoding == false && value.productList.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loading(),
                      Text(
                        translate(context, 'no_products').toString(),
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      context.read<GetProductProvider>().makeListEmpty();
                      context
                          .read<GetProductProvider>()
                          .getProducts(screenName: 'get_product');
                    },
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.25,
                              width: MediaQuery.sizeOf(context).width,
                              child: PageView.builder(
                                itemCount:
                                    (value.productList.length / 2).ceil(),
                                controller:
                                    PageController(initialPage: _currentIndex),
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProducDetail(
                                                      productModel: value
                                                          .productList[index],
                                                      index: index,
                                                      isHomePost: false,
                                                    )));
                                      },
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl: value
                                                    .productList[index]
                                                    .images[0]
                                                    .image
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                width: double
                                                    .infinity, // Ensures full width
                                                height: double
                                                    .infinity, // Ensures full height
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.grey[
                                                        300], // Placeholder background
                                                  ),
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(), // Loading Indicator
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.grey[
                                                        300], // Error background
                                                  ),
                                                  child: const Center(
                                                    child: Icon(Icons.error,
                                                        color: Colors
                                                            .red), // Error icon
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Gradient overlay
                                            Container(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.25,
                                              decoration: const BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.center,
                                                  colors: [
                                                    Colors.black54,
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Product name text
                                            Positioned(
                                              left: 10,
                                              bottom: 20,
                                              child: SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.85,
                                                child: Text(
                                                  '${value.productList[index].productName}',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  (value.productList.length / 2).ceil(),
                                  (index) {
                                return Container(
                                  width: _currentIndex == index ? 16 : 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _currentIndex == index
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                translate(context, 'all_products').toString(),
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Products()));
                                },
                                child: Text(
                                  translate(context, 'see_all').toString(),
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          alignment: WrapAlignment.start,
                          children: [
                            for (int i = 0; i < value.productList.length; i++)
                              ProductCard(
                                productsModel: value.productList[i],
                                index: i,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
      }),
    );
  }
}
