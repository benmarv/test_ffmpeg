import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/friend_unfriend/widgets/user_friend_tile.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class PeopleSearch extends StatefulWidget {
  final TextEditingController searchController;

  const PeopleSearch({super.key, required this.searchController});

  @override
  State<PeopleSearch> createState() => _PeopleSearchState();
}

class _PeopleSearchState extends State<PeopleSearch> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.user.clear();
    if (widget.searchController.text.isEmpty) {
      searchProvider.search(query: '', type: 'people');
    } else {
      searchProvider.search(
        query: widget.searchController.text,
        type: 'people',
      );
    }
    searchProvider.currentIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<SearchProvider>(context, listen: false).user.clear();
    super.dispose();
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
          : value.peopleMessage == 'Please Enter Something To Search' ||
                  value.peopleMessage == 'User Not Found'
              ? Center(
                  child: Text(
                    value.peopleMessage.toString(),
                  ),
                )
              : value.user.isNotEmpty && value.data == true
                  ? ListView.separated(
                      controller: _scrollController,
                      itemCount: value.user.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserFriendTile(
                          user: value.user[index],
                          query: widget.searchController.text,
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
                        translate(context, 'user_not_found').toString(),
                      ),
                    );
    });
  }
}
