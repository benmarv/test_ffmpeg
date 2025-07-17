import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/like_page_data.dart';
import 'detail_page.dart';

class LikePages extends StatefulWidget {
  const LikePages({super.key});
  @override
  State<LikePages> createState() => _LikePagesState();
}

class _LikePagesState extends State<LikePages> {
  List<GetLikePage> likepostlist = [];
  final ScrollController _scrollController = ScrollController();
  bool isInitLoading = false;
  bool isPaginationLoading = false;

  @override
  void initState() {
    likepostlist.clear();
    getInitData();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          fetchData(offset: likepostlist.length);
        });
      }
    });
    super.initState();
  }

  Future getInitData() async {
    setState(() {
      isInitLoading = true;
    });
    dynamic res = await apiClient.getlikepages(
        userid: getStringAsync("user_id"), offset: 0);
    setState(() {
      isInitLoading = false;
    });
    if (res['code'] == '200') {
      List<GetLikePage> tempList = [];
      tempList = List.from(res['data']).map<GetLikePage>((e) {
        GetLikePage list = GetLikePage.fromJson(e);
        return list;
      }).toList();
      likepostlist = tempList;
    }
  }

  Future fetchData({required int offset}) async {
    setState(() {
      isPaginationLoading = true;
    });
    dynamic res = await apiClient.getlikepages(
        userid: getStringAsync("user_id"), offset: offset);
    if (res['code'] == '200') {
      List<GetLikePage> tempList = [];
      tempList = List.from(res['data']).map<GetLikePage>((e) {
        GetLikePage list = GetLikePage.fromJson(e);
        return list;
      }).toList();
      likepostlist.addAll(tempList);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    translate(context, 'pages_you_liked').toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                likepostlist.isEmpty
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
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: likepostlist.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                  pageid:
                                                      likepostlist[index].id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            leading: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    likepostlist[index]
                                                        .avatar
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              likepostlist[index]
                                                  .pageTitle
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                              likepostlist[index]
                                                  .pageCategory
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            hoverColor: Colors.black12,
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              size: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            if (isPaginationLoading == true &&
                                likepostlist.isNotEmpty) ...[
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
