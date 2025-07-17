import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/search/event_search.dart';
import 'package:link_on/screens/search/group_search.dart';
import 'package:link_on/screens/search/job_search.dart';
import 'package:link_on/screens/search/page_search.dart';
import 'package:link_on/screens/search/people_search.dart';
import 'package:link_on/screens/search/search_page_provider.dart';

class NewSearchPage extends StatefulWidget {
  const NewSearchPage({super.key});
  @override
  _NewSearchPageState createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.search(query: '', type: 'people');
    searchProvider.currentIndex = 0;
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      onSearch();
    }
  }

  dynamic onSearch() async {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.currentIndex == 0
        ? await searchProvider.search(
            query: _searchController.text,
            type: 'people',
          )
        : searchProvider.currentIndex == 1
            ? searchProvider.search(
                query: _searchController.text,
                type: 'page',
              )
            : searchProvider.currentIndex == 2
                ? searchProvider.search(
                    query: _searchController.text,
                    type: 'group',
                  )
                : searchProvider.currentIndex == 3
                    ? searchProvider.search(
                        query: _searchController.text,
                        type: 'job',
                      )
                    : searchProvider.search(
                        query: _searchController.text,
                        type: 'event',
                      );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SearchProvider>(
        builder: ((context, value, child) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 25,
                          )),
                      Container(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: TextField(
                          onSubmitted: (val) async {
                            if (val.trim().isNotEmpty) {
                              await onSearch();
                            } else {
                              toast(translate(context, 'enter_text_to_search'));
                            }
                          },
                          scrollPadding: EdgeInsets.zero,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          controller: _searchController,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: AppColors.primaryColor,
                          decoration: InputDecoration(
                            focusColor: Colors.grey.withOpacity(0.5),
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            border: InputBorder.none,
                            hintText: translate(context, 'search_hint'),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.search,
                              ),
                              onPressed: () {
                                if (_searchController.text.isEmpty) {
                                  toast(translate(
                                      context, 'enter_text_to_search'));
                                } else {
                                  onSearch();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: SizedBox(
                            height: 35,
                            child: TabBar(
                              tabAlignment: Device.get().isTablet
                                  ? TabAlignment.center
                                  : TabAlignment.start,
                              dividerHeight: 0,
                              isScrollable: true,
                              indicatorWeight: 2,
                              dragStartBehavior: DragStartBehavior.down,
                              physics: const BouncingScrollPhysics(),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.white,
                              padding: EdgeInsets.zero,
                              indicator: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              tabs: [
                                Tab(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(translate(context, 'people')
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.pages_outlined,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(translate(context, 'pages')
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.groups_3_outlined,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(translate(context, 'groups')
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.cases_outlined,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(translate(context, 'jobs')
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.event,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(translate(context, 'events')
                                          .toString()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Builder(
                            builder: (context) => TabBarView(
                              controller: DefaultTabController.of(context),
                              physics: const BouncingScrollPhysics(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              children: [
                                PeopleSearch(
                                    searchController: _searchController),
                                PageSearch(searchController: _searchController),
                                GroupSearch(
                                    searchController: _searchController),
                                JobSearch(
                                  searchController: _searchController,
                                ),
                                EventSearch(
                                  searchController: _searchController,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
