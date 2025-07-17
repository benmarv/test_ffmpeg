import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'widgets/product_card.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});
  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    GetProductProvider provider =
        Provider.of<GetProductProvider>(context, listen: false);
    provider.setScreenName = "my_product";
    getProducts();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          provider.laoding == false) {
        int id = provider.myProductList.length;
        provider.getProducts(afterPostId: id, screenName: 'my_product');
      }
    });
  }

  Future getProducts() async {
    final provider = Provider.of<GetProductProvider>(context, listen: false);
    provider.myProductList.clear();
    if (provider.myProductList.isEmpty) {
      await provider.getProducts(screenName: 'my_product');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GetProductProvider>(
          builder: (context, value, child) {
            value.setScreenName = "my_product";
            return (value.laoding == true && value.myProductList.isEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loader(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        translate(context, 'loading')!,
                      ),
                    ],
                  )
                : (value.laoding == false && value.myProductList.isEmpty)
                    ? SizedBox(
                        height: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            loading(),
                            Text(
                              translate(context, 'no_product_found')!,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          context.read<GetProductProvider>().makeListEmpty();
                          context
                              .read<GetProductProvider>()
                              .getProducts(screenName: 'my_product');
                        },
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < value.myProductList.length;
                                  i++)
                                ProductCard(
                                  productsModel: value.myProductList[i],
                                  index: i,
                                ),
                            ],
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
