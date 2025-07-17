// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/screens/groups/group_details.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class GroupSearch extends StatefulWidget {
  TextEditingController searchController = TextEditingController();

  GroupSearch({super.key, required this.searchController});

  @override
  State<GroupSearch> createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    if (widget.searchController.text.isEmptyOrNull) {
      searchProvider.search(query: '', type: 'group');
    } else {
      searchProvider.search(query: widget.searchController.text, type: 'group');
    }
    searchProvider.currentIndex = 2;
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
          : value.groupMessage ==
                      translate(context, 'enter_something_to_search') ||
                  value.groupMessage == translate(context, 'group_not_found')
              ? Center(
                  child: Text(
                    value.groupMessage.toString(),
                  ),
                )
              : value.group.isNotEmpty && value.data == true
                  ? ListView.separated(
                      itemCount: value.group.length,
                      itemBuilder: (BuildContext context, int index) {
                        log('Value is ${value.group.toString()}');
                        return GroupSearchTile(
                          group: value.group[index],
                          index: index,
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
                        translate(context, 'group_not_found').toString(),
                      ),
                    );
    });
  }
}

class GroupSearchTile extends StatefulWidget {
  final JoinGroupModel? group;

  final int? index;

  const GroupSearchTile({Key? key, this.group, this.index}) : super(key: key);

  @override
  _GroupSearchTileState createState() => _GroupSearchTileState();
}

class _GroupSearchTileState extends State<GroupSearchTile> {
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
                builder: (context) => DetailsGroup(
                  joinGroupModel: widget.group,
                  index: widget.index,
                ),
              ),
            );
          },
          contentPadding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 3,
          ),
          leading: CircularImage(
            image: widget.group!.cover.toString(),
          ),
          title: Text(
            "${widget.group?.groupTitle}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.group?.membersCount == "1"
                ? "${widget.group?.membersCount} ${translate(context, 'member')}"
                : "${widget.group?.membersCount} ${translate(context, 'members')}",
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
