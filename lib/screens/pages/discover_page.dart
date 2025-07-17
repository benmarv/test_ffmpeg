import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'detail_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final ScrollController _scrollController = ScrollController();
  List<GetLikePage> suggestpostlist = [];
  bool isInitLoading = false;
  bool isPaginationLoading = false;

  @override
  void initState() {
    suggestpostlist.clear();
    getInitData();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          fetchData(offset: suggestpostlist.length);
        });
      }
    });
    super.initState();
  }

  Future getInitData() async {
    setState(() {
      isInitLoading = true;
    });
    dynamic res = await apiClient.discoverPagelist(offset: 0);
    setState(() {
      isInitLoading = false;
    });
    if (res['code'] == '200') {
      List<GetLikePage> tempList = [];
      tempList = List.from(res['data']).map<GetLikePage>((e) {
        GetLikePage list = GetLikePage.fromJson(e);
        return list;
      }).toList();
      suggestpostlist = tempList;
    } else {
      setState(() {
        isInitLoading = false;
      });
      toast(translate(context, 'no_data_found').toString());
    }
    setState(() {
      isInitLoading = false;
    });
  }

  Future fetchData({required int offset}) async {
    setState(() {
      isPaginationLoading = true;
    });
    dynamic res = await apiClient.discoverPagelist(offset: offset);
    if (res['code'] == '200') {
      List<GetLikePage> tempList = [];
      tempList = List.from(res['data']).map<GetLikePage>((e) {
        GetLikePage list = GetLikePage.fromJson(e);
        return list;
      }).toList();
      suggestpostlist.addAll(tempList);
    } else {
      setState(() {
        isPaginationLoading = false;
      });
      toast(translate(context, 'no_more_data').toString());
      return;
    }
    setState(() {
      isPaginationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isInitLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    translate(context, 'suggestions_for_you').toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                isInitLoading == false && suggestpostlist.isEmpty
                    ? AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loading(),
                            Text(
                                translate(context, 'no_page_found').toString()),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: suggestpostlist.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsPage(
                                                        pageid: suggestpostlist[
                                                                index]
                                                            .id,
                                                      )));
                                        },
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  suggestpostlist[index]
                                                      .avatar
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            suggestpostlist[index]
                                                .pageTitle
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            suggestpostlist[index]
                                                .pageCategory
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          hoverColor: Colors.black12,
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (isPaginationLoading == true &&
                                suggestpostlist.isNotEmpty) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            ]
                          ],
                        ),
                      ),
              ],
            ),
          );
  }
}
