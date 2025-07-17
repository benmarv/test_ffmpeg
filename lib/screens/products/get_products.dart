import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'widgets/product_card.dart';

class GetProducts extends StatefulWidget {
  const GetProducts({super.key});
  @override
  State<GetProducts> createState() => _GetProductsState();
}

class _GetProductsState extends State<GetProducts> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    GetProductProvider provider =
        Provider.of<GetProductProvider>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<GetProductProvider>(builder: (context, value, child) {
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
                  translate(context, 'loading')!,
                  style: const TextStyle(color: Colors.black),
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
                      translate(context, 'no_products')!,
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
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Wrap(
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
                  ),
                );
    });
  }
}
