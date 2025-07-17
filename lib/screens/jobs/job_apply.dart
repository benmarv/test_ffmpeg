// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class JobApply extends StatefulWidget {
  final String? jobtitile, jobid;
  const JobApply({super.key, this.jobtitile, this.jobid});

  @override
  State<JobApply> createState() => _JobApplyState();
}

class _JobApplyState extends State<JobApply> {
  Usr? userData;

  final _formKey = GlobalKey<FormState>();

  String? fileName;
  File? _file;

  late TextEditingController phone;
  late TextEditingController location;
  TextEditingController work = TextEditingController();
  TextEditingController exdescription = TextEditingController();
  TextEditingController position = TextEditingController();
  TextEditingController companyname = TextEditingController();

  @override
  void initState() {
    userData = Usr.fromJson(
      jsonDecode(
        getStringAsync('userData'),
      ),
    );
    phone = TextEditingController(text: userData?.phone ?? '');
    location = TextEditingController(text: userData?.address ?? '');
    super.initState();
  }

  Future<bool> applyjob() async {
    bool isApplied = false;
    Map<String, dynamic> dataArray = {
      "job_id": widget.jobid,
      "phone": phone.text,
      "location": location.text,
      "position": position.text,
      "previous_work": companyname.text,
      "description": exdescription.text,
    };

    if (_file != null) {
      dataArray["cv_file"] = await MultipartFile.fromFile(
        _file!.path,
        filename: fileName,
      );
    }
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'apply-for-job', apiData: dataArray);

    log('Response of apply job is ${res.toString()}');

    if (res["code"] == "200") {
      if (res["message"] == 'Applied Successfully') {
        toast(res["message"].toString());
        isApplied = true;
      } else {
        toast(res["message"].toString());
      }
    } else {
      print('Error: ${res['errors']['error_text']}');
    }
    return isApplied;
  }

  Future getResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result == null) return;

    _file = File(result.files.single.path!);
    fileName = result.files.single.name;

    if (!_file!.path.toLowerCase().endsWith('.pdf')) {
      toast(translate(context, "please_select_a_valid_pdf"));
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
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
            widget.jobtitile.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    translate(context, "personal_information").toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    prefixIconTextField: const Icon(
                      Icons.phone,
                      size: 20,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return translate(context, 'enter_your_phone_number');
                      }
                      if (val.trim().length < 10 || val.trim().length > 15) {
                        return translate(context, '11_to_15_digit_required');
                      }
                      RegExp phoneRegex = RegExp(r'^[0-9]+$');
                      if (!phoneRegex.hasMatch(val.trim())) {
                        return translate(context, 'invalid_phonenumber')
                            .toString();
                      }
                      return null;
                    },
                    giveDefaultBorder: true,
                    isPhoneNumberField: true,
                    controller: phone,
                    labelText: translate(context, "your_phone_number"),
                    maxLines: null,
                    keyboardType: TextInputType.phone,
                    hinttext: translate(context, "enter_your_phone_number"),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        translate(context, "experience").toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      5.sw,
                      Text(
                        translate(context, "optional").toString(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    prefixIconTextField: const Icon(
                      Icons.panorama_fish_eye_outlined,
                      size: 20,
                    ),
                    labelText: translate(context, "your_position"),
                    giveDefaultBorder: true,
                    controller: position,
                    maxLines: null,
                    hinttext: translate(context, "enter_your_position"),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      if (val.length < 3) {
                        return translate(context, "at_least_3_characters");
                      }
                      RegExp regex = RegExp(r'^[a-zA-Z\s\-]+$');
                      if (!regex.hasMatch(val.trim())) {
                        return translate(context, 'invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    prefixIconTextField: const Icon(
                      Icons.work,
                      size: 20,
                    ),
                    labelText: translate(context, "your_companey_name"),
                    giveDefaultBorder: true,
                    controller: companyname,
                    maxLines: null,
                    hinttext: translate(context, "enter_your_company_name"),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return null;
                      if (val.length < 5) {
                        return translate(context, "at_least_5_characters");
                      }
                      RegExp regex = RegExp(r'^[a-zA-Z\s\-]+$');
                      if (!regex.hasMatch(val.trim())) {
                        return translate(context, 'invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Text(
                    translate(context, "pdf_only").toString(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  5.sh,
                  SizedBox(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width * .5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor:
                              AppColors.primaryColor.withOpacity(0.8)),
                      onPressed: () {
                        getResume();
                      },
                      child: Text(
                        translate(context, "upload_resume").toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  5.sh,
                  _file == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text(fileName!.split('/').last.toString())),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_file == null) {
                            toast(translate(context, "upload_your_cv"));
                          } else {
                            applyjob().then(
                              (val) {
                                return Navigator.pop(context);
                              },
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Apply",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
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
    );
  }
}
