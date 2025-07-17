import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/deep_ar/deep_ar.dart';
import 'package:link_on/controllers/filters_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key, required this.isPost});
  final bool isPost;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    final pro = Provider.of<FiltersProvider>(context, listen: false);
    pro.getDeepArFilters();
    _controller.addListener(() {
      if ((_controller.position.pixels ==
              _controller.position.maxScrollExtent) &&
          pro.isLoading == false) {
        pro.getDeepArFilters(offset: pro.allFilters.length);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 20,
              width: 100,
              child: Image(
                image: NetworkImage(
                  getStringAsync("appLogo"),
                ),
              ),
            ),
            Text(
              translate(context, 'filters')!,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<FiltersProvider>(
        builder: (context, value, child) => value.isLoading == false &&
                value.allFilters.isNotEmpty
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 0.73),
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                controller: _controller,
                itemCount: value.allFilters.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeepArScreen(
                                isPost: widget.isPost,
                                deepArFilterLink:
                                    value.allFilters[index].link!),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.sizeOf(context).height * 0.23,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        value.allFilters[index].image!),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              value.allFilters[index].name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : value.isLoading == false && value.allFilters.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        translate(context, 'no_filters_found')!,
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 16),
                      )),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
      ),
    );
  }
}
