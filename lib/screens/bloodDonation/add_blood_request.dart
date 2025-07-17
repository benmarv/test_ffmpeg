// ignore_for_file: use_build_context_synchronously, deprecated_member_use
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

class AddBloodRequest extends StatefulWidget {
  const AddBloodRequest({super.key});

  @override
  State<AddBloodRequest> createState() => _AddBloodRequestState();
}

class _AddBloodRequestState extends State<AddBloodRequest> {
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

  int? bloodGroupTypeIndex;
  String? _bloodGroupTypeValue;
  Usr getUsrData = Usr();
  late TextEditingController fullName;
  late TextEditingController email;
  late TextEditingController age;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  bool isAvailableForDonation = true;

  @override
  void initState() {
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));

    fullName = TextEditingController(
        text: "${getUsrData.firstName} ${getUsrData.lastName}");
    email = TextEditingController(text: getUsrData.email);

    log('Get user Date of Birth is ${getUsrData.id}');

    age = getUsrData.dateOfBirth != null
        ? TextEditingController(text: getage(getUsrData.dateOfBirth.toString()))
        : TextEditingController();
    super.initState();
  }

  String getage(String? dateOfBirthc) {
    String dateOfBirth = dateOfBirthc!;
    log('Date of Birth is ${dateOfBirth}');
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
              title: const Text(
                "Add Blood Request",
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
                            return translate(
                                context, 'enter_your_phone_number');
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
                            return translate(
                                context, 'invalid_location_format');
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
                      bloodGroupTypeDropDown(),
                      const SizedBox(
                        height: 20,
                      ),
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        value: isAvailableForDonation,
                        onChanged: (value) {
                          setState(() {
                            isAvailableForDonation = value;
                          });
                        },
                        title: Text(
                          translate(context, 'urgently_needed')!,
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
                                toast(translate(
                                    context, 'select_your_blood_group'));
                              } else {
                                Map<String, dynamic> dataArray = {
                                  "blood_group": _bloodGroupTypeValue,
                                  "phone": phoneNumber.text,
                                  "location": location.text,
                                  "is_urgent_need":
                                      isAvailableForDonation ? '1' : '0',
                                };

                                context
                                    .read<BloodDonationProvider>()
                                    .createBloodRequest(
                                        context: context, dataArray: dataArray);
                              }
                            }
                          },
                          child: Text(
                            translate(context, 'add_blood_request')!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
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
            )));
  }

  Widget bloodGroupTypeDropDown() {
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
                          translate(context, 'select_your_blood_group')
                              .toString(),
                          style: TextStyle(
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
                              color: Theme.of(context).colorScheme.onSurface),
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
