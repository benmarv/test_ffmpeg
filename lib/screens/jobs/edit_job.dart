import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/models/myjoblist_model.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/controllers/jobsProvider/joblist_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class EditJob extends StatefulWidget {
  const EditJob({super.key, required this.jobDetail});
  final MyJobModel? jobDetail;
  @override
  State<EditJob> createState() => _EditJobState();
}

class _EditJobState extends State<EditJob> {
  final _formKey = GlobalKey<FormState>();
  List categoryjob = [
    "Other",
    "Admin & Office",
    "Art & Design",
    "Business Operations",
    "Cleaning & Facilities",
    "Community & Social Services",
    "Computer & Data",
    "Construction & Mining",
    "Education",
    "Farming & Forestry",
    "Healthcare",
    "Installation, Maintenance & Repair",
    "Legal",
    "Management",
    "Manufacturing",
    "Media & Communication",
    "Personal Care",
    "Protective Services",
    "Restaurant & Hospitality",
    "Retail & Sales",
    "Science & Engineering",
    "Sports & Entertainment",
    "Transportation",
  ];

  List categoryjobtype = [
    "Full time",
    "Part time",
    "Internship",
    "Volunteer",
    "Contract",
  ];

  List categorysaldate = [
    "month",
    "day",
    "hour",
    "week",
    "year",
  ];
  List<String> experienceList = [
    'Fresher',
    '6 months to 1 year',
    '2 to 3 years',
    '3 to 5 years',
    'More than 5 years'
  ];
  List categorycurrency = [];
  int? currencydropindex;
  String? _currencydropDownValue;
  int? saldatedropindex;
  String? _saldatedropDownValue;
  int? jobdropindex;
  String? _jobdropDownValue;
  String? _selectedExperience;
  int? jobtypedropindex;
  String? _jobtypedropDownValue;
  SiteSetting? site;

  late TextEditingController updatedescription;
  late TextEditingController updatejobtitle;

  late TextEditingController updatelocation;

  late TextEditingController updatemaxsal;
  late TextEditingController updateminsal;
  bool? _isUrHire;
  @override
  void initState() {
    _isUrHire = widget.jobDetail!.isUrgentHiring == '0' ? false : true;
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    initializeData();
  }

  void initializeData() {
    updatedescription =
        TextEditingController(text: widget.jobDetail?.jobDescription);
    updatejobtitle = TextEditingController(text: widget.jobDetail?.jobTitle);
    updatelocation = TextEditingController(text: widget.jobDetail?.jobLocation);
    updatemaxsal = TextEditingController(text: widget.jobDetail?.maximumSalary);
    updateminsal = TextEditingController(text: widget.jobDetail?.minimumSalary);
    _currencydropDownValue = widget.jobDetail!.currency;
    saldatedropindex = categorysaldate.indexOf(widget.jobDetail?.salaryDate);
    _saldatedropDownValue = widget.jobDetail?.salaryDate;
    jobdropindex = categoryjob.indexOf(widget.jobDetail?.jobType);
    _jobdropDownValue = widget.jobDetail?.jobType;
    jobtypedropindex = categoryjobtype.indexOf(widget.jobDetail?.jobType);
    _jobtypedropDownValue = widget.jobDetail?.jobType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          translate(context, 'update_job')!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  giveDefaultBorder: true,
                  labelText: translate(context, 'your_job_title'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'update_your_job_title');
                    }
                    return null;
                  },
                  controller: updatejobtitle,
                  keyboardType: TextInputType.multiline,
                  hinttext: translate(context, 'update_your_job_title'),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  labelText: translate(context, 'your_job_location'),
                  controller: updatelocation,
                  giveDefaultBorder: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'update_your_job_location');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  hinttext: translate(context, 'update_your_job_location'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  translate(context, 'job_type')!,
                ),
                const SizedBox(
                  height: 8,
                ),
                dropDwonJobType(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  translate(context, 'experience')!,
                ),
                const SizedBox(
                  height: 8,
                ),
                jobExperience(),
                const SizedBox(
                  height: 20,
                ),
                Text(translate(context, 'currency')!),
                const SizedBox(
                  height: 8,
                ),
                dropDwonCurrency(),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: updateminsal,
                        textinputaction: TextInputAction.next,
                        maxLines: 1,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translate(context, 'required');
                          }
                          return null;
                        },
                        giveDefaultBorder: true,
                        labelText: translate(context, 'minimum_salary'),
                        hinttext: translate(context, 'minimum_salary'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: updatemaxsal,
                        maxLines: 1,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translate(context, 'required');
                          }
                          return null;
                        },
                        giveDefaultBorder: true,
                        labelText: translate(context, 'maximum_salary'),
                        hinttext: translate(context, 'maximum_salary'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(translate(context, 'salary_type')!),
                const SizedBox(
                  height: 8,
                ),
                dropDwonsaldate(),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'update_your_job_description');
                    }
                    return null;
                  },
                  controller: updatedescription,
                  maxLines: null,
                  giveDefaultBorder: true,
                  keyboardType: TextInputType.multiline,
                  labelText: translate(context, 'your_job_description'),
                  hinttext: translate(context, 'update_your_job_description'),
                ),
                2.sh,
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(translate(context, 'is_urgent_hiring')!),
                  autofocus: false,
                  activeColor: Colors.red,
                  checkColor: Colors.white,
                  selected:
                      widget.jobDetail?.isUrgentHiring == '0' ? false : true,
                  value: _isUrHire ?? false,
                  onChanged: (value) {
                    log("Value is ${value.toString()}");
                    setState(() {
                      _isUrHire = value;
                    });
                  },
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> mapData = {
                          "job_id": widget.jobDetail?.id,
                        };
                        if (updatejobtitle.text.isNotEmpty) {
                          mapData['job_title'] = updatejobtitle.text.trim();
                        }
                        if (updatelocation.text.isNotEmpty) {
                          mapData['job_location'] = updatelocation.text.trim();
                        }
                        if (_jobtypedropDownValue!.isNotEmpty) {
                          mapData['job_type'] = _jobtypedropDownValue;
                        }
                        if (_currencydropDownValue!.isNotEmpty) {
                          mapData['currency'] = _currencydropDownValue;
                        }
                        if (updateminsal.text.isNotEmpty) {
                          mapData['minimum_salary'] = updateminsal.text;
                        }
                        if (updatemaxsal.text.isNotEmpty) {
                          mapData['maximum_salary'] = updatemaxsal.text;
                        }
                        if (_saldatedropDownValue!.isNotEmpty) {
                          mapData['salary_date'] = _saldatedropDownValue;
                        }
                        if (updatedescription.text.isNotEmpty) {
                          mapData['job_description'] = updatedescription.text;
                        }
                        if (_isUrHire == true) {
                          mapData['is_urgent_hiring'] = '1';
                        }
                        if (_isUrHire == false) {
                          mapData['is_urgent_hiring'] = '0';
                        }
                        if (_selectedExperience != null) {
                          mapData['experience_years'] = _selectedExperience;
                        }

                        context
                            .read<JobListProvider>()
                            .updatejob(context: context, mapData: mapData);
                      }
                    },
                    child: Center(
                      child: Text(
                        translate(context, 'update_job')!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDwonCategory() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: _jobdropDownValue == null
                ? Text(
                    categoryjob[widget.jobDetail!.category.toInt()] ??
                        translate(context, 'select_category'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    _jobdropDownValue!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            items: categoryjob.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (String? val) {
              setState(() {
                _jobdropDownValue = val;
                jobdropindex = categoryjob.indexOf(val);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget dropDwonJobType() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _jobtypedropDownValue == null
                      ? Text(
                          widget.jobDetail?.jobType ??
                              translate(context, 'job_type')!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          _jobtypedropDownValue!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: categoryjobtype.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _jobtypedropDownValue = val;
                      jobtypedropindex = categoryjobtype.indexOf(val);
                    });
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
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _currencydropDownValue == null
                      ? Text(
                          widget.jobDetail!.currency ??
                              translate(context, 'currency')!,
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
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
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
                        currencydropindex = categorycurrency.indexOf(val);
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

  Widget dropDwonsaldate() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _saldatedropDownValue == null
                      ? Text(
                          widget.jobDetail?.salaryDate ??
                              translate(context, 'salary_date')!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          _saldatedropDownValue!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: categorysaldate.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _saldatedropDownValue = val;
                      saldatedropindex = categorysaldate.indexOf(val);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget jobExperience() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: _selectedExperience == null
                ? Text(
                    widget.jobDetail!.experienceYears ??
                        translate(context, 'select_experience')!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    _selectedExperience!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            items: experienceList.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (String? val) {
              setState(
                () {
                  _selectedExperience = val;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
