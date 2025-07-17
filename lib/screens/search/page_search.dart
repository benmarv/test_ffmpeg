// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:link_on/screens/pages/detail_page.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class PageSearch extends StatefulWidget {
  final TextEditingController searchController;

  const PageSearch({super.key, required this.searchController});

  @override
  State<PageSearch> createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (widget.searchController.text.isEmpty) {
      searchProvider.search(query: '', type: 'page');
    } else {
      searchProvider.search(query: widget.searchController.text, type: 'page');
    }
    searchProvider.currentIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, value, child) {
      return value.data == false
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : value.pageMessage ==
                      translate(context, 'enter_something_to_search') ||
                  value.pageMessage == translate(context, 'page_not_found')
              ? Center(
                  child: Text(
                    value.pageMessage.toString(),
                  ),
                )
              : value.page.isNotEmpty && value.data == true
                  ? ListView.separated(
                      itemCount: value.page.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PageSearchTile(
                          page: value.page[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 0.5,
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        translate(context, 'page_not_found').toString(),
                      ),
                    );
    });
  }
}

class PageSearchTile extends StatefulWidget {
  final GetLikePage? page;

  const PageSearchTile({Key? key, this.page}) : super(key: key);

  @override
  _PageSearchTileState createState() => _PageSearchTileState();
}

class _PageSearchTileState extends State<PageSearchTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: ((context, value, child) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(pageid: widget.page?.id),
              ),
            );
          },
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 3,
          ),
          leading: CircularImage(
            image: widget.page!.cover.toString(),
          ),
          title: Text(
            "${widget.page?.pageTitle}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.page?.likesCount == "1"
                ? "${widget.page?.likesCount} ${translate(context, 'like')}"
                : "${widget.page?.likesCount} ${translate(context, 'likes')}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primaryColor,
          ),
        );
      }),
    );
  }
}
