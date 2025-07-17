import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/courses/course_details.dart';
import 'package:link_on/screens/courses/courses.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../controllers/CourseProviderClass/get_course_api_provider.dart';
import '../../localization/localization_constant.dart';

class SearchPage extends StatefulWidget {
  final bool isMyCourses;

  const SearchPage({super.key, this.isMyCourses = false});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoadingMore = false;
  int offset = 0; // Offset for pagination
  int limit = 10; // Number of items per pag

  @override
  void initState() {
    _getCourses();
    super.initState();
  }

  Future<void> _getCourses({bool isLoadMore = false}) async {
    var pro = Provider.of<GetCourseApiProvider>(context, listen: false);

    if (isLoadMore) {
      setState(() {
        isLoadingMore = true;
        offset += limit;
      });
    }

    await pro.fetchCoursesList(
      context: context,
      searchText: searchController.text,
      userId: widget.isMyCourses ? getStringAsync('user_id').toInt() : null,
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
    final colors = [Color(0xffa4f2e6), Color(0xfffda4c5), Color(0xffe1fca1)];
    return Scaffold(
      appBar: AppBar(
        title: widget.isMyCourses
            ? Text(translate(context, 'my_cources').toString())
            : Text(translate(context, 'search_page').toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search TextField
            SizedBox(
              height: 50,
              child: TextField(
                controller: searchController,
                style: TextStyle(fontSize: 12),
                onChanged: (val) {
                  var pro =
                      Provider.of<GetCourseApiProvider>(context, listen: false);
                  pro.searchedCourses
                      .clear(); // Clear existing list for a new search
                  offset = 0; // Reset offset for a new search
                  pro.fetchCoursesList(
                    context: context,
                    searchText: val,
                    userId: widget.isMyCourses
                        ? getStringAsync('user_id').toInt()
                        : null,
                    offset: offset,
                    limit: limit,
                  );
                },
                decoration: InputDecoration(
                  labelText: translate(context, 'search_hint').toString(),
                  hintText: translate(context, 'enter_course_name').toString(),
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: AppColors.primaryColor,
                  hintStyle: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(179, 41, 40, 40)),
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
            ),
            SizedBox(height: 20),
            // Display search results in ListView
            Expanded(
              child: Consumer<GetCourseApiProvider>(
                builder: (context, provider, child) {
                  return provider.loading && !isLoadingMore
                      ? Center(child: CircularProgressIndicator())
                      : provider.searchedCourses.isEmpty
                          ? Center(
                              child: Text(
                                  translate(context, 'empty_list').toString()))
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (!isLoadingMore &&
                                    scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                  _getCourses(isLoadMore: true);
                                }
                                return false;
                              },
                              child: ListView.builder(
                                itemCount: provider.searchedCourses.length +
                                    (isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index ==
                                      provider.searchedCourses.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orange,
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CourseDetailsScreen(
                                            course:
                                                provider.searchedCourses[index],
                                            isMyCourse: widget.isMyCourses,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CourseTile(
                                      course: provider.searchedCourses[index],
                                      colour: colors[index % colors.length]
                                          .withAlpha(35),
                                    ),
                                  );
                                },
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SearchPage extends StatefulWidget {
//   final bool isMyCourses;

//   const SearchPage({super.key, this.isMyCourses = false});
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   // Controller for the search TextField
//   TextEditingController searchController = TextEditingController();
//   Future<void> _getCourses() async {
//     var pro = Provider.of<GetCourseApiProvider>(context, listen: false);
//     pro.searchedCourses.clear();
//     widget.isMyCourses
//         ? pro.fetchCoursesList(
//             context: context,
//             userId: getStringAsync('user_id').toInt(),
//           )
//         : pro.fetchCoursesList(context: context);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getCourses();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = [Color(0xffa4f2e6), Color(0xfffda4c5), Color(0xffe1fca1)];
//     return Scaffold(
//       appBar: AppBar(
//         title: widget.isMyCourses ? Text('My Courses') : Text('Search Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Search TextField
//             TextField(
//               controller: searchController,
//               onChanged: (val) {
//                 var pro =
//                     Provider.of<GetCourseApiProvider>(context, listen: false);
//                 pro.searchedCourses.clear();

//                 widget.isMyCourses
//                     ? pro.fetchCoursesList(
//                         context: context,
//                         searchText: val,
//                         userId: getStringAsync('user_id').toInt())
//                     : pro.fetchCoursesList(context: context, searchText: val);
//               },
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 hintText: 'Enter course name...',
//                 prefixIcon: Icon(Icons.search),
//                 fillColor: Colors.red,
//                 prefixIconColor: AppColors.primaryColor,

//                 hintStyle: TextStyle(
//                   color: const Color.fromARGB(179, 41, 40, 40),
//                 ),
//                 border: OutlineInputBorder(),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30), // Rounded corners
//                   borderSide: BorderSide(
//                       color: AppColors.primaryColor,
//                       width: 1), // Border color and width
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30), // Rounded corners
//                   borderSide: BorderSide(
//                       color: AppColors.primaryColor,
//                       width: 2), // Border color when focused
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide(color: Colors.red, width: 1),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide(color: Colors.red, width: 2),
//                 ), // No bor
//               ),
//             ),
//             SizedBox(height: 20),
//             // Display search results in ListView
//             Expanded(
//               child: Consumer<GetCourseApiProvider>(
//                 builder: (
//                   context,
//                   provider,
//                   child,
//                 ) {
//                   return provider.loading
//                       ? Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : provider.searchedCourses.isEmpty
//                           ? Center(
//                               child: Text('Empty List'),
//                             )
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: BouncingScrollPhysics(),
//                               itemBuilder: (context, index) => GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CourseDetailsScreen(
//                                         course: provider.searchedCourses[index],
//                                         isMyCourse: widget.isMyCourses,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: CourseTile(
//                                   course: provider.searchedCourses[index],
//                                   colour: colors[index % colors.length]
//                                       .withAlpha(35),
//                                 ),
//                               ),
//                               itemCount: provider.searchedCourses.length,
//                             );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
