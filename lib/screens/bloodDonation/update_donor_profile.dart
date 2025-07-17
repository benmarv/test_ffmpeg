import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/bloodDonation/blood_donation_provider.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';

class UpdateDonorInfo extends StatefulWidget {
  const UpdateDonorInfo({super.key});

  @override
  State<UpdateDonorInfo> createState() => _UpdateDonorInfoState();
}

class _UpdateDonorInfoState extends State<UpdateDonorInfo> {
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

  int? genderValueIndex;
  int? bloodGroupTypeIndex;
  String? _bloodGroupTypeValue;
  Usr getUsrData = Usr();
  late TextEditingController fullName;
  late TextEditingController email;
  late TextEditingController phoneNumber;
  late TextEditingController location;
  late TextEditingController _dateController;
  DateTime startDate = DateTime.now();
  bool data = false;

  Future userdata() async {
    dynamic res =
        await apiClient.get_user_data(userId: getStringAsync('user_id'));
    if (res["code"] == '200') {
      log('code 200 : ${res['data']}');
      getUsrData = Usr.fromJson(res["data"]);
      data = true;
      setState(() {});
    } else {
      data = true;
      toast(translate(context, 'error_user_profile'));
    }
  }

  @override
  void initState() {
    userdata().then((value) {
      fullName = TextEditingController(
          text: "${getUsrData.firstName} ${getUsrData.lastName}");
      email = TextEditingController(text: getUsrData.email);
      phoneNumber = TextEditingController(text: getUsrData.phone);
      location = TextEditingController(text: getUsrData.address);
      _dateController = TextEditingController(
          text: getUsrData.lastDonationDate ??
              translate(context, 'last_donation_date'));
      log(getUsrData.lastDonationDate.toString());
      bloodGroupValue();
    });

    super.initState();
  }

  bloodGroupValue() {
    setState(() {
      _bloodGroupTypeValue = getUsrData.bloodGroup;
      isAvailableForDonation =
          getUsrData.isAvailableForDonation == "0" ? false : true;
    });
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Restrict to past dates
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

  bool? isAvailableForDonation;
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
              translate(context, 'update_info').toString(),
              style: const TextStyle(
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
              child: !data
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
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
                              return translate(context, 'enter_full_name');
                            }
                            return null;
                          },
                          hinttext: translate(context, 'enter_full_name'),
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
                              return translate(context, 'enter_email');
                            }
                            return null;
                          },
                          labelText: translate(context, 'email'),
                          hinttext: translate(context, 'enter_email'),
                          textinputaction: TextInputAction.next,
                        ),
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
                              return translate(context, 'enter_phone_number');
                            }
                            return null;
                          },
                          labelText: translate(context, 'your_phone_number'),
                          hinttext: translate(context, 'enter_phone_number'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          controller: location,
                          maxLines: 1,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return translate(context, 'enter_location');
                            }
                            return null;
                          },
                          giveDefaultBorder: true,
                          labelText: translate(context, 'your_location'),
                          hinttext: translate(context, 'enter_location'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        bloodGroupTypeDropDown(),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(translate(context, 'last_donation_date')
                            .toString()),
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
                          height: 20,
                        ),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          value: isAvailableForDonation!,
                          onChanged: (value) {
                            setState(() {
                              isAvailableForDonation = value;
                            });
                          },
                          title: Text(
                              translate(context, 'available_for_donation')
                                  .toString()),
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
                                      translate(context, 'select_blood_group'));
                                } else {
                                  Map<String, dynamic> dataArray = {
                                    "blood_group": _bloodGroupTypeValue,
                                    "phone": phoneNumber.text,
                                    "address": location.text,
                                    "donation_available":
                                        isAvailableForDonation! ? '1' : '0'
                                  };
                                  if (_dateController.text.isNotEmpty) {
                                    dataArray['donation_date'] =
                                        _dateController.text;
                                  }

                                  context
                                      .read<BloodDonationProvider>()
                                      .updateDonorData(
                                          context: context,
                                          dataArray: dataArray);
                                }
                              }
                            },
                            child: Text(
                              translate(context, 'update_info').toString(),
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
          ))),
    );
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
                  hint: _bloodGroupTypeValue == null
                      ? Text(
                          translate(context, 'select_blood_group').toString(),
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
