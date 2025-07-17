import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/controllers/CourseProviderClass/get_course_api_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/CourseModel/course_data_model.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/courses/courses.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';

class CreateCourse extends StatefulWidget {
  final CourseModel? courseModel;
  final bool? isMyCourse;
  const CreateCourse({super.key, this.isMyCourse, this.courseModel});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final _formKey = GlobalKey<FormState>();
  String? dateTime;
  File? eventImage;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? _courseCategory;
  String? _courseCategoryKey;
  SiteSetting? site;
  String? _levelDropDownValue;
  bool? isPaidCourse = false;

  List<String> levelCategories = ['Beginner', 'Intermediate', 'Advanced'];

  TextEditingController _courseNameController = TextEditingController();
  TextEditingController _courseStartDateController = TextEditingController();
  TextEditingController _courseEndDateController = TextEditingController();
  TextEditingController _courseDescriptionController = TextEditingController();
  // TextEditingController _courseCategoryController = TextEditingController();
  TextEditingController _courseCountryController = TextEditingController();
  TextEditingController _courseLevelController = TextEditingController();
  TextEditingController _courseLanguageController = TextEditingController();
  TextEditingController _courseAddressController = TextEditingController();
  TextEditingController _coursePriceController = TextEditingController();

  @override
  void initState() {
    // log('Id is ${widget.courseModel?.id}');
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    super.initState();
    if (widget.isMyCourse == true) controllerInit();
  }

  controllerInit() {
    // Initialize controllers with null-safe access and default values
    _courseNameController =
        TextEditingController(text: widget.courseModel?.title ?? '');
    _courseStartDateController =
        TextEditingController(text: widget.courseModel?.startDate ?? '');
    _courseEndDateController =
        TextEditingController(text: widget.courseModel?.endDate ?? '');
    _courseDescriptionController =
        TextEditingController(text: widget.courseModel?.description ?? '');
    // _courseCategoryController =
    //     TextEditingController(text: widget.courseModel?.categoryId ?? '');
    _courseCountryController =
        TextEditingController(text: widget.courseModel?.country ?? '');
    _courseLevelController =
        TextEditingController(text: widget.courseModel?.level ?? '');
    _courseLanguageController =
        TextEditingController(text: widget.courseModel?.language ?? '');
    _courseAddressController =
        TextEditingController(text: widget.courseModel?.address ?? '');
    _coursePriceController =
        TextEditingController(text: widget.courseModel?.amount ?? '');

    _courseCategory = site!.groupCategories[widget.courseModel?.categoryId];
    _levelDropDownValue = widget.courseModel!.level;
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseStartDateController.dispose();
    _courseEndDateController.dispose();
    _courseDescriptionController.dispose();
    // _courseCategoryController.dispose();
    _courseCountryController.dispose();
    _courseLevelController.dispose();
    _courseLanguageController.dispose();
    _courseAddressController.dispose();
    super.dispose();
  }

  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.5),
    ),
  );

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(
          DateFormat.y().format(DateTime.now()).toInt(),
          DateFormat.M().format(DateTime.now()).toInt(),
          DateFormat.d().format(DateTime.now()).toInt(),
        ),
        lastDate: DateTime(2026),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                ),
              ),
              child: child!);
        });
    if (picked != null) {
      setState(() {
        startDate = picked;
        _courseStartDateController.text =
            DateFormat('yyyy-MM-dd').format(startDate);
      });
    }
  }

  Future _endselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(
        DateFormat.y().format(DateTime.now()).toInt(),
        DateFormat.M().format(DateTime.now()).toInt(),
        DateFormat.d().format(DateTime.now()).toInt(),
      ),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        endDate = picked;

        _courseEndDateController.text =
            DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider =
        Provider.of<GetCourseApiProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        title: Text(
          translate(context,
                  widget.isMyCourse == true ? 'update_course' : 'create_course')
              .toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: eventImage != null
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.secondary,
                              image: DecorationImage(
                                image: FileImage(eventImage!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : widget.isMyCourse == true &&
                                  widget.courseModel!.cover.isNotEmpty
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(widget.courseModel!.cover),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.5),
                                ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, right: 19),
                          child: Container(
                            height: 30,
                            width: 110,
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    eventImage = File(image.path);
                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.add_to_photos,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text(
                                      translate(context, 'add_photo')
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: _courseNameController,
                      giveDefaultBorder: true,
                      labelText: translate(context, 'course_name').toString(),
                      hinttext:
                          translate(context, 'enter_course_name').toString(),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_course_name')
                              .toString();
                        }
                        if (val.trim().length < 3 || val.trim().length > 50) {
                          return translate(context, 'course_name_length')
                              .toString();
                        }
                        RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                        if (!regex.hasMatch(val)) {
                          return translate(context, 'course_title_valid')
                              .toString();
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 25),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _courseStartDateController,
                              decoration: InputDecoration(
                                hintText: translate(context, 'start_date'),
                                labelText: translate(context, 'start_date'),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context, 'required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _endselectDate(context);
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: _courseEndDateController,
                              decoration: InputDecoration(
                                hintText: translate(context, 'end_date'),
                                labelText: translate(context, 'end_date'),
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context, 'required');
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: _courseDescriptionController,
                      giveDefaultBorder: true,
                      labelText: translate(context, 'course_description'),
                      hinttext: translate(context, 'enter_course_description'),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'descreption_name_length');
                        }
                        if (val.trim().length < 3 || val.trim().length > 300) {
                          return translate(context, 'descreption_name_length')
                              .toString();
                        }
                        RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                        if (!regex.hasMatch(val)) {
                          return translate(context, 'course_title_valid')
                              .toString();
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 192, 191, 191),
                          width: 1,
                        ),
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor:
                              Theme.of(context).colorScheme.secondary,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          hint: _courseCategory == null
                              ? Text(
                                  translate(context, 'course_category')
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )
                              : Text(
                                  _courseCategory!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          items: site!.groupCategories.entries.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val.key,
                                child: Text(
                                  val.value,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (String? val) {
                            setState(
                              () {
                                _courseCategory = site!.groupCategories[val]!;

                                _courseCategoryKey = val;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _courseCountryController,
                            giveDefaultBorder: true,
                            labelText:
                                translate(context, 'course_country').toString(),
                            hinttext: translate(context, 'enter_country_name')
                                .toString(),
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return translate(context, 'enter_country_name')
                                    .toString();
                              }
                              RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                              if (!regex.hasMatch(val)) {
                                return translate(
                                        context, 'course_country_valid')
                                    .toString();
                              }
                              return null;
                            },
                            maxLines: 1,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 192, 191, 191),
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                dropdownColor:
                                    Theme.of(context).colorScheme.secondary,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                hint: _levelDropDownValue == null
                                    ? Text(
                                        translate(context, 'course_level')
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        _levelDropDownValue!,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                items: levelCategories.map(
                                  (val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (String? val) {
                                  setState(
                                    () {
                                      _levelDropDownValue = val!;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    CustomTextField(
                      controller: _courseLanguageController,
                      giveDefaultBorder: true,
                      labelText: translate(context, 'language_name').toString(),
                      hinttext:
                          translate(context, 'enter_language_name').toString(),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_language_name')
                              .toString();
                        }
                        RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                        if (!regex.hasMatch(val)) {
                          return translate(context, 'course_Language_valid')
                              .toString();
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(translate(context, "is_this_paid_course")
                              .toString()),
                          Switch(
                            value: isPaidCourse!,
                            onChanged: (bool value) {
                              setState(() {
                                isPaidCourse = value; // Update the state
                              });
                            },
                            activeColor: Colors.white, // Thumb color when ON
                            activeTrackColor:
                                AppColors.primaryColor, // Track color when ON
                            inactiveThumbColor:
                                AppColors.primaryColor, // Thumb color when OFF
                            // Track color when OFF
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    isPaidCourse == true
                        ? CustomTextField(
                            keyboardType:
                                TextInputType.number, // Numeric keyboard

                            controller: _coursePriceController,
                            giveDefaultBorder: true,
                            labelText: translate(context, "price").toString(),
                            hinttext: translate(context, "enter_course_price")
                                .toString(),
                            //labelText: translate(context, 'course_address'),
                            //hinttext: translate(context, 'enter_course_address'),
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return translate(
                                    context, 'enter_course_address');
                              }
                              return null;
                            },
                            maxLines: null,
                          )
                        : SizedBox.shrink(),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _courseAddressController,
                      giveDefaultBorder: true,
                      labelText: translate(context, 'course_address'),
                      hinttext: translate(context, 'enter_course_address'),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_course_address');
                        }
                        RegExp locationRegex = RegExp(r'^[a-zA-Z0-9,\s]+$');
                        if (!locationRegex.hasMatch(val)) {
                          return translate(context, 'location_invalid')
                              .toString();
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        if (_courseCategory == null) {
                          toast(
                              translate(context, "please_select_category")
                                  .toString(),
                              bgColor: Colors.red,
                              textColor: Colors.white);
                        } else if (!endDate.isAfter(startDate)) {
                          toast(
                              translate(context, "please_select_valid_date")
                                  .toString(),
                              bgColor: Colors.red,
                              textColor: Colors.white);
                        } else if (_levelDropDownValue == null) {
                          toast(
                              translate(context, "please_select_level")
                                  .toString(),
                              bgColor: Colors.red,
                              textColor: Colors.white);
                        } else if (_formKey.currentState!.validate()) {
                          if (widget.isMyCourse == true) {
                            await courseProvider
                                .updateCourseApi(
                              courseId: widget.courseModel!.id,
                              context: context,
                              courseimage: eventImage?.path,
                              courseTitle: _courseNameController.text,
                              courseStartDate: _courseStartDateController.text,
                              courseEndDate: _courseEndDateController.text,
                              courseDescription:
                                  _courseDescriptionController.text,
                              courseCategory: _courseCategoryKey,
                              courseCountry: _courseCountryController.text,
                              courseLevel: levelCategories
                                      .indexOf(_levelDropDownValue!) +
                                  1,
                              courseLanguage: _courseLanguageController.text,
                              courseAddress: _courseAddressController.text,
                              amount: isPaidCourse == true
                                  ? _coursePriceController.text
                                  : "0",
                              isPaid:
                                  isPaidCourse == true ? isPaidCourse : "false",
                            )
                                .then((val) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CoursesScreen(),
                                ),
                              );
                            });
                          } else {
                            // Add your validation logic here
                            await courseProvider
                                .createCourseApi(
                                  context: context,
                                  courseimage: eventImage?.path,
                                  courseTitle: _courseNameController.text,
                                  courseStartDate:
                                      _courseStartDateController.text,
                                  courseEndDate: _courseEndDateController.text,
                                  courseDescription:
                                      _courseDescriptionController.text,
                                  courseCategory: _courseCategoryKey,
                                  courseCountry: _courseCountryController.text,
                                  courseLevel: levelCategories
                                          .indexOf(_levelDropDownValue!) +
                                      1,
                                  courseLanguage:
                                      _courseLanguageController.text,
                                  courseAddress: _courseAddressController.text,
                                  amount: isPaidCourse == true
                                      ? _coursePriceController.text
                                      : "0",
                                  isPaid: isPaidCourse == true
                                      ? isPaidCourse
                                      : "false",
                                )
                                .then((val) {});
                          }
                        }
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            translate(
                                    context,
                                    widget.isMyCourse == true
                                        ? 'update_course_button'
                                        : 'create_course_button')
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
