import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/CourseModel/course_data_model.dart';
import 'package:link_on/screens/courses/course_creation_form.dart';
import 'package:link_on/screens/courses/course_details.dart';
import 'package:link_on/screens/courses/search_course_page.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../controllers/CourseProviderClass/get_course_api_provider.dart';
import '../../models/usr.dart';

class CoursesScreen extends StatefulWidget {
  final Usr? user;

  const CoursesScreen({super.key, this.user});

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<String> images = [
    'https://summer.harvard.edu/wp-content/uploads/sites/7/2023/12/choosing-classes.jpg',
    'https://www.discover.com/content/dam/dfs/student-loans/article/college-planning/college-life/academics/student-raising-hand-in-university-class-tab-520x348.jpeg',
    'https://www.collegedata.com/hubfs/freshmandodont-4_small-1.jpg',
  ];

  List<CourseModel>? getAllCourses;

  Future<void> _getCourses() async {
    var pro = Provider.of<GetCourseApiProvider>(context, listen: false);
    pro.allCourses.clear();
    pro.fetchCoursesList(context: context, screenName: 'allCourses');
  }

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [Color(0xffa4f2e6), Color(0xfffda4c5), Color(0xffe1fca1)];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(getStringAsync("appLogo")),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SearchPage(),
          //       ),
          //     );
          //   },
          //   icon: const Icon(
          //     Icons.search_outlined,
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0),
                      fillColor: Colors.red, prefixIcon: Icon(Icons.search),
                      prefixIconColor: AppColors.primaryColor,
                      hintText: translate(context, "search_here").toString(),
                      hintStyle: TextStyle(),
                      enabled: false,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1), // Border color and width
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1), // Border color when focused
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                        borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 1), // Border color when focused
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ), // No border
                    ),
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            const Color.fromARGB(255, 5, 5, 5)), // Text color
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(
                              isMyCourses: true,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ), // Padding
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          translate(context, 'my_cources').toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      icon: Icon(Icons.dataset, color: Colors.white, size: 15),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateCourse(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ), // Padding
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          translate(context, 'create_course').toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      icon: Icon(Icons.add, color: Colors.white, size: 15),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Carousel Slider
            CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        offset: Offset(2, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ), // This will show while the image is loading
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.black,
                      ), // This will show if the image fails to load
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 160,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction:
                    1.0, // Use full screen width for carousel items
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "select_your_course").toString(),
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                  child: Text(
                    translate(context, "see_all").toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                )
              ],
            ),
            // Course List
            Expanded(child: Consumer<GetCourseApiProvider>(
                builder: (context, provider, child) {
              if (provider.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (provider.allCourses.isEmpty &&
                  provider.loading == false) {
                return Center(child: Text("No Courses Found"));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsScreen(
                          course: provider.allCourses[index],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CourseTile(
                      course: provider.allCourses[index],
                      colour: colors[index % colors.length].withAlpha(35),
                    ),
                  ),
                ),
                itemCount: provider.allCourses.length,
              );
            })),
          ],
        ),
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  final Color? colour;
  final CourseModel course;
  final Random random = Random();

  CourseTile({
    required this.course,
    this.colour,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isDarkMode
                  ? Color.fromARGB(255, 44, 44, 44)
                  : Color.fromARGB(41, 224, 224, 224), // Border color
              width: 1, // Border width
            ),
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          elevation: 0,
          color: isDarkMode
              ? Theme.of(context).primaryColorDark
              : const Color.fromARGB(214, 243, 243, 243),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: course.cover,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        course.title.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      translate(context, 'level_:').toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      course.level.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              translate(context, 'language_:').toString(),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                course.language.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              translate(context, 'price').toString() + ":",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            course.amount != "0"
                                ? Center(
                                    child: Text(
                                      "\$ ${course.amount}",
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      translate(context, 'free').toString(),
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
