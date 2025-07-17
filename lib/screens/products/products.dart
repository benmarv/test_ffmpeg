import "package:flutter/material.dart";
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/screens/products/create_products.dart';
import 'package:link_on/screens/products/get_products.dart';
import 'my_products.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products>
    with SingleTickerProviderStateMixin {
  List tabs = [];
  late TabController tabController = TabController(
    vsync: this,
    length: 2,
  );
  @override
  void initState() {
    super.initState();
    tabs = [
      "market",
      "my_products",
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      dividerHeight: 0,
      labelColor: AppColors.primaryColor,
      indicatorColor: AppColors.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      tabs: tabs.map((tab) {
        var index = tabs.indexOf(tab);
        return Tab(
          text: translate(context, tabs[index]),
        );
      }).toList(),
      controller: tabController,
    );
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
          ],
        ),
        elevation: 2,
        bottom: tabBar,
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          GetProducts(),
          MyProducts(),
        ],
      ),
    );
  }
}
