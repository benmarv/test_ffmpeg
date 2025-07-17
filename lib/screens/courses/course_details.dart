import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/CourseModel/course_data_model.dart';
import 'package:link_on/screens/courses/course_creation_form.dart';
import 'package:link_on/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../consts/colors.dart';
import '../../controllers/CourseProviderClass/get_course_api_provider.dart';
import '../../localization/localization_constant.dart'; // Forting

class CourseDetailsScreen extends StatefulWidget {
  final bool? isMyCourse;
  final CourseModel course;

  const CourseDetailsScreen({super.key, required this.course, this.isMyCourse});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isEnroledButton = true;
  bool isReadMore = false;
  @override
  Widget build(BuildContext context) {
    final courseProvider =
        Provider.of<GetCourseApiProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              translate(context,
                      widget.isMyCourse == true ? "my_cources" : "coursee")
                  .toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            widget.isMyCourse == true
                ? ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                translate(context, "delet_item").toString()),
                            content: Text(translate(context, "sure_to_delete")
                                .toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                    translate(context, "cancle").toString()),
                              ),
                              TextButton(
                                onPressed: () {
                                  courseProvider.deletCourse(
                                      context: context,
                                      id: widget.course.id.toString());
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.red, // Set text color to red
                                ),
                                child: Text(
                                    translate(context, "delete").toString()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gradientColor1, // Button color
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
                        translate(context, 'delete').toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    icon: Icon(Icons.delete, color: Colors.white, size: 16),
                  )
                : Container(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Carousel Slider
            Container(
              height: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  imageUrl: widget.course.cover, fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ), // This will show while the image is loading
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
                  ), // This will show if the image fails to load
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              minTileHeight: 80,
              // tileColor: const Color.fromARGB(41, 224, 224, 224),
              title: Text(
                "${widget.course.user.firstName.toString()} ${widget.course.user.lastName.toString()}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                "${widget.course.country.toString()} ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: ClipOval(
                child: CachedNetworkImage(
                  height: 50, width: 50,
                  imageUrl: widget.course.cover, fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ), // This will show while the image is loading
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
                  ), // This will show if the image fails to load
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.course.amount == "0"
                      ? translate(context, "freee").toString()
                      : "\$ ${widget.course.amount.toString()} ",
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              widget.course.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              translate(context, 'description').toString(),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CourseDescription(
              description: widget.course.description,
            ),
            // isReadMore == true
            //     ? SizedBox.shrink()
            //     : TextButton(
            //         onPressed: () {
            //           setState(() {
            //             isReadMore = true;
            //           });
            //         },
            //         child: Text(
            //           translate(context, "read_more").toString(),
            //         ),
            //       ),

            SizedBox(height: 10),

            // Dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'start_date').toString(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   widget.course.startDate,
                    //   style: TextStyle(fontSize: 14),
                    // ),

                    Text(
                      Utils.formatTimestamp(widget.course.startDate),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate(context, 'end_date').toString(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.formatTimestamp(widget.course.endDate),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // Other Details

            DetailRow(
                title: translate(context, 'course_level').toString(),
                value: widget.course.level),
            DetailRow(
                title: translate(context, 'country').toString(),
                value: widget.course.country),
            //     DetailRow(title: 'Language', value: widget.course.language),
            //     DetailRow(title: 'Price', value: widget.course.amount),

            SizedBox(height: 10),

            // Enroll Button
            // isEnroledButton == true
            //     ? MaterialButton(
            //         onPressed: () {},
            //         child: Text("Les"),
            //       )
            ElevatedButton(
              onPressed: widget.isMyCourse == true
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateCourse(
                            isMyCourse: true,
                            courseModel: widget.course,
                          ),
                        ),
                      );
                    }
                  : widget.course.isApplied == false
                      ? () {
                          courseProvider
                              .enrolledInCourse(
                                  context: context,
                                  id: widget.course.id.toString())
                              .then((val) {
                            setState(() {
                              widget.course.isApplied = val!;
                              isEnroledButton == false;
                            });
                          });
                        }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 14),
              ),
              child: Text(
                widget.isMyCourse == true
                    ? translate(context, "update").toString()
                    : widget.course.isApplied
                        ? translate(context, "enrolled").toString()
                        : translate(context, "enrolled_now").toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CourseDescription extends StatefulWidget {
  final String description;
  final TextStyle textStyle;

  const CourseDescription({
    Key? key,
    required this.description,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.grey,
    ),
  }) : super(key: key);

  @override
  _CourseDescriptionState createState() => _CourseDescriptionState();
}

class _CourseDescriptionState extends State<CourseDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final maxLines = 3;
    final truncatedText = widget.description.length <= maxLines * 60
        ? widget.description
        : widget.description.substring(0, maxLines * 60) + '...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            truncatedText,
            // style: widget.textStyle,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.description,
            // style: widget.textStyle,
            maxLines: null,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        SizedBox(height: 8), // Add space between text and button
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _isExpanded ? Text('Read Less') : Text('Read More'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
