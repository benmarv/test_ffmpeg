// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/bloodDonation/blood_donation_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';

class BecomeADonor extends StatefulWidget {
  const BecomeADonor({super.key});

  @override
  State<BecomeADonor> createState() => _BecomeADonorState();
}

class _BecomeADonorState extends State<BecomeADonor> {
  final _formKey = GlobalKey<FormState>();

  List bloodGroupType = [
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-',
  ];

  List gender = [
    "Male",
    "Female",
    "Other",
  ];

  int? genderValueIndex;

  int? bloodGroupTypeIndex;
  String? _bloodGroupTypeValue;
  Usr getUsrData = Usr();
  late TextEditingController fullName;
  late TextEditingController email;
  late TextEditingController age;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime startDate = DateTime.now();

  @override
  void initState() {
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));

    fullName = TextEditingController(
        text: "${getUsrData.firstName} ${getUsrData.lastName}");
    email = TextEditingController(text: getUsrData.email);
    age = getUsrData.dateOfBirth != null
        ? TextEditingController(text: getage(getUsrData.dateOfBirth.toString()))
        : TextEditingController();
    super.initState();
  }

  String getage(String? dateOfBirthc) {
    String dateOfBirth = dateOfBirthc!;
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(dateOfBirth);
    DateTime currentDate = DateTime.now();

    int ageInYears = currentDate.year - parsedDate.year;
    int monthDifference = currentDate.month - parsedDate.month;

    // Correcting the month difference calculation
    int correctedMonthDifference = (currentDate.month > parsedDate.month)
        ? currentDate.month - parsedDate.month
        : currentDate.month + 12 - parsedDate.month;

    if (monthDifference < 0 ||
        (monthDifference == 0 && currentDate.day < parsedDate.day)) {
      ageInYears--;
    }

    // Check if age is less than 1 year
    if (ageInYears < 1) {
      return '$correctedMonthDifference months';
    } else {
      return '$ageInYears years';
    }
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
        startDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(startDate);
      });
    }
  }

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
            translate(context, 'become_a_donor').toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: fullName,
                    isEnabled: false,
                    maxLines: null,
                    labelText: translate(context, 'full_name'),
                    giveDefaultBorder: true,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_full_name');
                      }
                      return null;
                    },
                    hinttext: translate(context, 'enter_your_full_name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: email,
                    isEnabled: false,
                    giveDefaultBorder: true,
                    maxLines: 1,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_email');
                      }
                      return null;
                    },
                    labelText: translate(context, 'email'),
                    hinttext: translate(context, 'enter_your_email'),
                    textinputaction: TextInputAction.next,
                  ),
                  if (age.text.isNotEmpty) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: age,
                      isEnabled: false,
                      giveDefaultBorder: true,
                      maxLines: 1,
                      labelText: translate(context, 'age'),
                      hinttext: translate(context, 'enter_your_age'),
                      textinputaction: TextInputAction.next,
                    ),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: phoneNumber,
                    maxLines: 1,
                    isPhoneNumberField: true,
                    giveDefaultBorder: true,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_phone_number');
                      }
                      RegExp locationRegex = RegExp(r'^[a-zA-Z0-9,\s]+$');
                      if (!locationRegex.hasMatch(val)) {
                        return translate(context, 'invalid_phonenumber')
                            .toString();
                      }
                      return null;
                    },
                    labelText: translate(context, 'your_phone_number'),
                    hinttext: translate(context, 'enter_your_phone_number'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: location,
                    maxLines: 1,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return translate(context, 'enter_your_location');
                      }
                      final RegExp locationRegex =
                          RegExp(r'^[a-zA-Z\s,-]+(?:,\s*[a-zA-Z\s,-]+)*$');

                      if (!locationRegex.hasMatch(val)) {
                        return translate(context, 'invalid_location_format');
                      }
                      RegExp locationRegexx = RegExp(r'^[a-zA-Z0-9,\s]+$');
                      if (!locationRegexx.hasMatch(val)) {
                        return translate(context, 'invalid_location_format')
                            .toString();
                      }
                      return null;
                    },
                    giveDefaultBorder: true,
                    labelText: translate(context, 'your_location'),
                    hinttext: translate(context, 'enter_your_location'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  bloodGroupTypeDropDown(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    translate(context, 'last_donation_date')!,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      hinttext: translate(context, 'select_last_donation_date'),
                      isEnabled: false,
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return translate(context, 'required');
                        }
                        return null;
                      },
                      giveDefaultBorder: true,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_bloodGroupTypeValue == null) {
                            toast(
                                translate(context, 'select_your_blood_group'));
                          } else {
                            Map<String, dynamic> dataArray = {
                              "blood_group": _bloodGroupTypeValue,
                              "phone": phoneNumber.text,
                              "address": location.text,
                            };
                            if (_dateController.text.isNotEmpty) {
                              dataArray['donation_date'] = _dateController.text;
                            }

                            context
                                .read<BloodDonationProvider>()
                                .updateDonorData(
                                    context: context, dataArray: dataArray);
                          }
                        }
                      },
                      child: Text(
                        translate(context, 'become_a_donor')!,
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

  Widget bloodGroupTypeDropDown(BuildContext context) {
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
                  hint: _bloodGroupTypeValue == null
                      ? Text(
                          translate(context, 'select_your_blood_group')!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          _bloodGroupTypeValue!,
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
                  items: bloodGroupType.map(
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
                        _bloodGroupTypeValue = val;
                        bloodGroupTypeIndex = bloodGroupType.indexOf(val);
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
