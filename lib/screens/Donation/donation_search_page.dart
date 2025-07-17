import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:provider/provider.dart';

import '../../controllers/CourseProviderClass/get_course_api_provider.dart';

class DonationSearchPage extends StatefulWidget {
  final bool? isMyCourses;
  DonationSearchPage({super.key, this.isMyCourses});

  @override
  State<DonationSearchPage> createState() => _DonationSearchPageState();
}

class _DonationSearchPageState extends State<DonationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingMore = false;
  int offset = 0; // Offset for pagination
  int limit = 10; // Number of items per page

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  Future<void> _getCourses({bool isLoadMore = false}) async {
    var pro = Provider.of<GetCourseApiProvider>(context, listen: false);

    if (isLoadMore) {
      setState(() {
        isLoadingMore = true;
        offset += limit; // Increment the offset to load the next page
      });
    }

    await pro.fetchCoursesList(
      context: context,
      searchText: _searchController.text,
      //  userId: widget.isMyCourses ? getStringAsync('user_id').toInt() : null,
      offset: offset,
      limit: limit,
    );

    if (isLoadMore) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final colors = [Color(0xffa4f2e6), Color(0xfffda4c5), Color(0xffe1fca1)];
    return Scaffold(
      appBar: AppBar(
        title:
            //    widget.isMyCourses            ?
            Text("Doners"),
        //   : Text(translate(context, 'search_page').toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              onChanged: (val) {
                var pro =
                    Provider.of<GetCourseApiProvider>(context, listen: false);
                pro.searchedCourses.clear();
                offset = 0;
                pro.fetchCoursesList(
                  context: context,
                  searchText: val,
                  // userId: widget.isMyCourses
                  //     ? getStringAsync('user_id').toInt()
                  //     : null,
                  offset: offset,
                  limit: limit,
                );
              },
              decoration: InputDecoration(
                labelText: 'Search Doner',
                hintText: 'Write the name of donner',
                prefixIcon: Icon(Icons.search),
                prefixIconColor: AppColors.primaryColor,
                hintStyle:
                    TextStyle(color: const Color.fromARGB(179, 41, 40, 40)),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display search results in ListView
            // Expanded(
            //   child: Consumer<GetCourseApiProvider>(
            //     builder: (context, provider, child) {
            //       return provider.loading && !isLoadingMore
            //           ? Center(child: CircularProgressIndicator())
            //           : provider.searchedCourses.isEmpty
            //               ? Center(
            //                   child: Text(
            //                       translate(context, 'empty_list').toString()))
            //               : NotificationListener<ScrollNotification>(
            //                   onNotification: (ScrollNotification scrollInfo) {
            //                     if (!isLoadingMore &&
            //                         scrollInfo.metrics.pixels ==
            //                             scrollInfo.metrics.maxScrollExtent) {
            //                       _getCourses(isLoadMore: true);
            //                     }
            //                     return false;
            //                   },
            //                   child: ListView.builder(
            //                     itemCount: provider.searchedCourses.length +
            //                         (isLoadingMore ? 1 : 0),
            //                     itemBuilder: (context, index) {
            //                       if (index ==
            //                           provider.searchedCourses.length) {
            //                         return Padding(
            //                           padding: const EdgeInsets.only(top: 30.0),
            //                           child: Center(
            //                             child: CircularProgressIndicator(
            //                               color: Colors.orange,
            //                             ),
            //                           ),
            //                         );
            //                       }
            //                       return GestureDetector(
            //                         onTap: () {
            //                           // Navigator.push(
            //                           //   context,
            //                           //   MaterialPageRoute(
            //                           //     builder: (context) =>
            //                           //         CourseDetailsScreen(
            //                           //       course:
            //                           //           provider.searchedCourses[index],
            //                           //       isMyCourse: widget.isMyCourses,
            //                           //     ),
            //                           //   ),
            //                           // );
            //                         },
            //                         child: CourseTile(
            //                           course: provider.searchedCourses[index],
            //                           colour: colors[index % colors.length]
            //                               .withAlpha(35),
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
