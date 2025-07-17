// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/like_page_data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/controllers/jobsProvider/joblist_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class CreateJob extends StatefulWidget {
  const CreateJob({super.key});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  final _formKey = GlobalKey<FormState>();

  File? groupcoverpic;

  bool check = false;
  List<GetLikePage> mypagelist = [];
  List<String> mypagenames = [];
  List<String> mypageid = [];

  List categoryjobtype = [
    "full_time",
    "part_time",
    "internship",
    "volunteer",
    "contract",
  ];

  List urgentHiring = [
    "yes",
    "no",
  ];

  List categorysaldate = [
    "month",
    "day",
    "hour",
    "week",
    "year",
  ];

  int? currencydropindex;
  String? _currencydropDownValue;
  int? saldatedropindex;
  String? _saldatedropDownValue;
  String? jobdropindex;
  String? _jobdropDownValue;
  int? jobtypedropindex;
  int? urgentHiringindex;
  String? _jobtypedropDownValue;
  String? _urgentHiringdropDownValue;
  SiteSetting? site;

  @override
  void initState() {
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
  }

  TextEditingController title = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController salmax = TextEditingController();
  TextEditingController salmin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            translate(context, 'create_job').toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: companyName,
                    maxLines: null,
                    labelText: translate(context, 'enter_your_company_name')
                        .toString(),
                    giveDefaultBorder: true,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_company_name')
                            .toString();
                      }
                      if (val.trim().length < 4) {
                        return translate(context, 'course_name_length')
                            .toString();
                      }
                      // Regular expression to allow only alphanumeric characters (letters and numbers)
                      RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                      if (!regex.hasMatch(val)) {
                        return translate(context,
                                'name_can_only_contain_letters_and_numbers')
                            .toString();
                      }
                      return null;
                    },
                    hinttext: translate(context, 'enter_your_company_name')
                        .toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: title,
                    giveDefaultBorder: true,
                    maxLines: 1,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_job_title')
                            .toString();
                      }
                      if (val.trim().length < 4) {
                        return translate(context, 'course_name_length')
                            .toString();
                      }
                      // Regular expression to allow only alphanumeric characters (letters and numbers)
                      RegExp regex = RegExp(r'^[a-zA-Z0-9 ]+$');
                      if (!regex.hasMatch(val)) {
                        return translate(context,
                                'job_title_can_only_contain_letters_and_numbers')
                            .toString();
                      }
                      return null;
                    },
                    labelText:
                        translate(context, 'enter_your_job_title').toString(),
                    hinttext:
                        translate(context, 'enter_your_job_title').toString(),
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // CustomTextField(
                  //   controller: experience,
                  //   maxLines: 1,
                  //   giveDefaultBorder: true,
                  //   validator: (val) {
                  //     if (val!.trim().isEmpty) {
                  //       return translate(
                  //               context, 'enter_your_required_job_experience')
                  //           .toString();
                  //     }
                  //     // Regular expression to allow only alphanumeric characters (letters and numbers)
                  //     RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
                  //     if (!regex.hasMatch(val)) {
                  //       return translate(context,
                  //               'job_experience_can_only_contain_letters_and_numbers')
                  //           .toString();
                  //     }
                  //     return null;
                  //   },
                  //   labelText:
                  //       translate(context, 'enter_your_required_job_experience')
                  //           .toString(),
                  //   hinttext:
                  //       translate(context, 'enter_your_required_job_experience')
                  //           .toString(),
                  // ),
                  CustomTextField(
                    controller: experience,
                    maxLines: 1,
                    giveDefaultBorder: true,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val != null && val.isNotEmpty) {
                        RegExp regex = RegExp(r'^\d{1,2}(\s*-\s*\d{1,2})?$');
                        if (!regex.hasMatch(val)) {
                          return translate(
                                  context, 'experience_can_only_numbers')
                              .toString();
                        }
                      }
                      return null;
                    },
                    labelText: translate(context, 'required_job_experience')
                        .toString(),
                    hinttext: translate(context, 'required_job_experience')
                        .toString(),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // CustomTextField(
                  //   controller: city,
                  //   maxLines: 1,
                  //   validator: (val) {
                  //     if (val!.trim().isEmpty) {
                  //       return translate(context, 'enter_your_job_location')
                  //           .toString();
                  //     }
                  //     return null;
                  //   },
                  //   giveDefaultBorder: true,
                  //   labelText: translate(context, 'enter_your_job_location')
                  //       .toString(),
                  //   hinttext: translate(context, 'enter_your_job_location')
                  //       .toString(),
                  // ),
                  CustomTextField(
                    controller: city,
                    maxLines: 1,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_job_location')
                            .toString();
                      }
                      // Regular expression to validate an address
                      RegExp regex = RegExp(r'^[a-zA-Z0-9\s,.-]+$');
                      if (!regex.hasMatch(val)) {
                        return "Invalid address";
                      }
                      return null;
                    },
                    giveDefaultBorder: true,
                    labelText: translate(context, 'enter_your_job_location')
                        .toString(),
                    hinttext: translate(context, 'enter_your_job_location')
                        .toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  dropDwonJobType(),
                  const SizedBox(
                    height: 20,
                  ),
                  dropDwonCategory(),
                  const SizedBox(
                    height: 20,
                  ),
                  dropDwonCurrency(),
                  const SizedBox(
                    height: 20,
                  ),
                  dropDwonUrgenTHiring(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          keyboardType: TextInputType.number,
                          controller: salmin,
                          giveDefaultBorder: true,
                          maxLines: 1,
                          labelText:
                              translate(context, 'minimum_salary').toString(),
                          hinttext:
                              translate(context, 'minimum_salary').toString(),
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return translate(context, 'required').toString();
                            }
                            // Regular expression to allow only alphanumeric characters (letters and numbers)
                            RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
                            if (!regex.hasMatch(val)) {
                              return translate(context, 'invalid').toString();
                            }
                            return null;
                          },
                        ),
                      ),
                      10.sw,
                      // Expanded(
                      //   child: CustomTextField(
                      //     controller: salmax,
                      //     keyboardType: TextInputType.number,
                      //     giveDefaultBorder: true,
                      //     textinputaction: TextInputAction.next,
                      //     maxLines: 1,
                      //     hinttext:
                      //         translate(context, 'maximum_salary').toString(),
                      //     labelText:
                      //         translate(context, 'maximum_salary').toString(),
                      //     validator: (val) {
                      //       if (val!.trim().isEmpty) {
                      //         return translate(context, 'required').toString();
                      //       }
                      //       if (int.tryParse(val.trim())! <
                      //           int.tryParse(salmin.text.trim())!) {
                      //         return "Invalid";
                      //       }
                      //       // Regular expression to allow only alphanumeric characters (letters and numbers)
                      //       RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
                      //       if (!regex.hasMatch(val)) {
                      //         return translate(context,
                      //                 'can_only_contain_letters_and_numbers')
                      //             .toString();
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Expanded(
                        child: CustomTextField(
                          controller: salmax,
                          keyboardType: TextInputType.number,
                          giveDefaultBorder: true,
                          textinputaction: TextInputAction.next,
                          maxLines: 1,
                          hinttext:
                              translate(context, 'maximum_salary').toString(),
                          labelText:
                              translate(context, 'maximum_salary').toString(),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return translate(context, 'required').toString();
                            }

                            int? maxSal = int.tryParse(val.trim());
                            int? minSal = int.tryParse(salmin.text.trim());

                            // Ensure both values are valid before comparing
                            if (maxSal != null &&
                                minSal != null &&
                                maxSal < minSal) {
                              return translate(context, 'invalid').toString();
                            }

                            // Regular expression to allow only numbers
                            RegExp regex = RegExp(r'^[0-9]+$');
                            if (!regex.hasMatch(val.trim())) {
                              return translate(context, 'invalid').toString();
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  dropDwonsaldate(),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: description,
                    maxLines: null,
                    giveDefaultBorder: true,
                    keyboardType: TextInputType.multiline,
                    hinttext: translate(context, 'enter_your_job_description')
                        .toString(),
                    labelText:
                        translate(context, 'your_job_description').toString(),
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_job_description')
                            .toString();
                      }
                      return null;
                    },
                  ),
                  10.sh,
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_jobtypedropDownValue == null) {
                            toast(translate(context, 'select_your_job_type')
                                .toString());
                          } else if (jobdropindex == null) {
                            toast(translate(context, 'select_your_job_category')
                                .toString());
                          } else if (currencydropindex == null) {
                            toast(
                                translate(context, 'select_your_currency_type')
                                    .toString());
                          } else if (urgentHiringindex == null) {
                            toast(translate(
                                    context, 'select_your_urgent_hiring_status')
                                .toString());
                          } else if (_saldatedropDownValue == null) {
                            toast(translate(context, 'select_your_salary_date')
                                .toString());
                          } else {
                            Map<String, dynamic> dataArray = {
                              "job_title": title.text,
                              "job_location": city.text,
                              "job_type": _jobtypedropDownValue,
                              "job_description": description.text,
                              "category": jobdropindex,
                              "minimum_salary": salmin.text,
                              "experience_years": experience.text,
                              "company_name": companyName.text,
                              "is_urgent_hiring": urgentHiringindex,
                              "maximum_salary": salmax.text,
                              "salary_date": _saldatedropDownValue,
                              "currency": _currencydropDownValue,
                            };

                            context.read<JobListProvider>().createjob(
                                context: context, mapData: dataArray);
                          }
                        }
                      },
                      child: Text(
                        translate(context, 'create_job').toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDwonCategory() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Theme.of(context).colorScheme.secondary,
            hint: _jobdropDownValue == null
                ? Text(
                    translate(context, 'select_category').toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  )
                : Text(
                    _jobdropDownValue!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500),
            items: site!.jobCategories.entries.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val.key,
                  child: Text(
                    val.value,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                );
              },
            ).toList(),
            onChanged: (String? val) {
              setState(
                () {
                  jobdropindex = val;
                  _jobdropDownValue = site!.jobCategories[val];
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget jobExperience() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
  //         borderRadius: BorderRadius.circular(10)),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton(
  //           hint: _selectedExperience == null
  //               ? const Text(
  //                   'Select Experience',
  //                   style: TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w500),
  //                 )
  //               : Text(
  //                   _selectedExperience!,
  //                   style: const TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //           isExpanded: true,
  //           iconSize: 30.0,
  //           style: const TextStyle(
  //               color: Colors.black87,
  //               fontSize: 15,
  //               fontWeight: FontWeight.w500),
  //           items: experienceList.map(
  //             (val) {
  //               return DropdownMenuItem<String>(
  //                 value: val,
  //                 child: Text(
  //                   val,
  //                   style: TextStyle(
  //                       color: Theme.of(context).colorScheme.onSurface),
  //                 ),
  //               );
  //             },
  //           ).toList(),
  //           onChanged: (String? val) {
  //             setState(
  //               () {
  //                 _selectedExperience = val;
  //                 // jobdropindex = categoryjob.indexOf(val);
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget dropDwonsaldate() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  hint: _saldatedropDownValue == null
                      ? Text(
                          translate(context, 'select_salary_date').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          _saldatedropDownValue!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  items: categorysaldate.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          translate(context, val)!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        _saldatedropDownValue = val;
                        saldatedropindex = categorysaldate.indexOf(val);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDwonCurrency() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  hint: _currencydropDownValue == null
                      ? Text(
                          translate(context, 'select_currency_type').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          _currencydropDownValue!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  items: site!.currecyArray.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        _currencydropDownValue = val;
                        currencydropindex = site!.currecyArray.indexOf(val!);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDwonJobType() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  hint: _jobtypedropDownValue == null
                      ? Text(
                          translate(context, 'select_job_type').toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          translate(context, _jobtypedropDownValue!)!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  items: categoryjobtype.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          translate(context, val)!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        _jobtypedropDownValue = val;
                        jobtypedropindex = categoryjobtype.indexOf(val);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDwonUrgenTHiring() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  hint: _urgentHiringdropDownValue == null
                      ? Text(
                          translate(context, 'select_urgent_hiring_status')
                              .toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          translate(context, _urgentHiringdropDownValue!)!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  items: urgentHiring.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          translate(context, val)!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        _urgentHiringdropDownValue = val;
                        urgentHiringindex = urgentHiring.indexOf(val);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
