import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';
import 'package:link_on/viewModel/api_client.dart';

class PageShare extends StatefulWidget {
  final Posts? posts;
  const PageShare({super.key, this.posts});
  @override
  State<PageShare> createState() => _PageShareState();
}

class _PageShareState extends State<PageShare> {
  List<GetLikePage>? getmypages;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bottomSheetTopDivider(color: AppColors.primaryColor),
              const SizedBox(
                height: 20,
              ),
              Text(
                translate(context,
                    'share_on_page')!, // Use translation key for 'Share on Page'
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: apiClient.getMyPages(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!["data"].isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loading(),
                            Text(translate(context,
                                'no_pages_found')!), // Use translation key for 'No pages found'
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
                                    ListTile(
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
                                                        getmypages![index]
                                                            .avatar
                                                            .toString())))),
                                        title: Text(
                                          getmypages![index]
                                              .pageTitle
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          getmypages![index]
                                              .pageCategory
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        hoverColor: Colors.black12,
                                        trailing: InkWell(
                                          onTap: () async {
                                            context
                                                .read<PostProvider>()
                                                .sharePostonTimeLine(
                                                    context: context,
                                                    post: widget.posts!,
                                                    pageId:
                                                        getmypages![index].id);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              translate(context,
                                                  'share')!, // Use translation key for 'Share'
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
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
        ),
      ),
    );
  }
}
