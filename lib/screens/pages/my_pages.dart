import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'detail_page.dart';

class MyPages extends StatefulWidget {
  const MyPages({super.key});

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  List<GetLikePage>? getmypages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              translate(context, 'pages_you_manage').toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: apiClient.getMyPages(),
              builder: (context, snapshot) {
                log('Snapshot data is ${snapshot.data}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Text(translate(context, 'no_pages_found').toString()),
                    ],
                  );
                }

                if (snapshot.hasData) {
                  if (snapshot.data!["data"].isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(translate(context, 'no_pages_found').toString()),
                      ],
                    );
                  } else {
                    var data = snapshot.data!['data'];
                    getmypages = List.from(data)
                        .map<GetLikePage>((e) => GetLikePage.fromJson(e))
                        .toList();

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: getmypages!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                          pageid: getmypages![index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    getmypages![index]
                                                        .avatar
                                                        .toString())))),
                                    title: Text(
                                      getmypages![index].pageTitle.toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      getmypages![index]
                                          .pageCategory
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    hoverColor: Colors.black12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }
                } else {
                  return const Center();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
