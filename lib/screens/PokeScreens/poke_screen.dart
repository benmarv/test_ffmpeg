import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'poke_provider.dart';

class PokeListPage extends StatefulWidget {
  const PokeListPage({super.key});

  @override
  State<PokeListPage> createState() => _PokeListPageState();
}

class _PokeListPageState extends State<PokeListPage> {
  bool isLoadingMore = false;
  int offset = 0; // Offset for pagination
  int limit = 5; // Number of items per page
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PokeProvider>(context, listen: false);
    provider.getPokeList.clear();
    _fetchInitialData();

    // Add scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  Future<void> _fetchInitialData() async {
    var pro = Provider.of<PokeProvider>(context, listen: false);
    await pro.getPokeUser(context: context, offset: offset, limit: limit);
  }

  Future<void> _loadMoreData() async {
    setState(() {
      isLoadingMore = true;
      offset += limit;
    });

    var pro = Provider.of<PokeProvider>(context, listen: false);
    await pro.getPokeUser(context: context, offset: offset, limit: limit);

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          translate(context, "poked_history").toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Consumer<PokeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.getPokeList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (!provider.isLoading && provider.getPokeList.isEmpty) {
            return Center(
                child: Text(translate(context, "no_data_found").toString()));
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: provider.getPokeList.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.getPokeList.length) {
                  return Center(child: CircularProgressIndicator());
                }

                var item = provider.getPokeList[index];

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isDarkMode
                            ? Color.fromARGB(255, 44, 44, 44)
                            : Color.fromARGB(41, 224, 224, 224),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: item.cover.toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.firstName ??
                                    translate(context, "unknow").toString()),
                                Text(item.createdAt?.timeAgo ?? ""),
                              ],
                            ),
                          ],
                        ),
                        item.isBack == true
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  color: AppColors.primaryColor,
                                  child: Text(
                                    translate(context, "poke_back").toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primaryLightColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await provider.pokeUser(
                                      context: context,
                                      userId: item.id,
                                      pokeBack: 1,
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
