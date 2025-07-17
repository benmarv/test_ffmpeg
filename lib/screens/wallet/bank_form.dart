import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/components/custom_form_field.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:http_parser/http_parser.dart';

class BankForm extends StatefulWidget {
  final String? type;
  const BankForm({super.key, this.type});

  @override
  State<BankForm> createState() => _BankFormState();
}

class _BankFormState extends State<BankForm> {
  TextEditingController cnic = TextEditingController();
  TextEditingController tid = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController accname = TextEditingController();
  TextEditingController accnumber = TextEditingController();
  TextEditingController description = TextEditingController();

  File? pickImage;
  uploadFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickImage = File(image.path);
      setState(() {});
    } else {
      toast(translate(context, 'select_again'));
    }
  }

  bool _validateCNIC(String cnic) {
    final RegExp cnicRegex = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    return cnicRegex.hasMatch(cnic);
  }

  void _checkValidity(String value) {
    setState(() {
      _isValid = _validateCNIC(value);
    });
  }

  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text(
            translate(context, 'bank_transfer')!,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                HeaderText(text: translate(context, 'fill_form_carefully')),
                20.sh,
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    onChanged: _checkValidity,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14),
                    cursorColor: Colors.black45,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    controller: cnic,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      labelText: translate(context, 'enter_cnic'),
                      errorText: _isValid
                          ? null
                          : translate(context, 'enter_valid_cnic'),
                    ),
                  ),
                ),
                CustomFormField(
                  border: 10,
                  color: Colors.black,
                  labelText: translate(context, 'account_name'),
                  controller: accname,
                ),
                CustomFormField(
                  border: 10,
                  color: Colors.black,
                  labelText: translate(context, 'account_number'),
                  controller: accnumber,
                ),
                CustomFormField(
                  border: 10,
                  color: Colors.black,
                  labelText: translate(context, 'transaction_id'),
                  controller: tid,
                ),
                CustomFormField(
                  border: 10,
                  color: Colors.black,
                  labelText: translate(context, 'amount'),
                  controller: amount,
                ),
                CustomFormField(
                  border: 10,
                  color: Colors.black,
                  labelText: translate(context, 'description'),
                  controller: description,
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      uploadFile();
                    },
                    child: pickImage != null
                        ? Container(
                            height: size.height * 0.3,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.buttongrey,
                              image: pickImage != null
                                  ? DecorationImage(
                                      image: FileImage(pickImage!),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_camera,
                                    color: Colors.black87,
                                    size: 35,
                                  ),
                                  12.sh,
                                  Text(
                                    translate(context, 'upload_screenshot')!,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                10.sh,
                SizedBox(
                  width: 150,
                  child: MaterialButton(
                    color: AppColors.primaryColor,
                    onPressed: () async {
                      if (tid.text.isEmpty) {
                        toast(translate(context, 'enter_transaction_id'));
                      } else if (cnic.text.isEmpty && cnic.text.toInt() < 13) {
                        toast(translate(context, 'enter_valid_number'));
                      } else if (accname.text.isEmpty) {
                        toast(translate(context, 'enter_account_name'));
                      } else if (accnumber.text.isEmpty) {
                        toast(translate(context, 'enter_account_number'));
                      } else if (pickImage == null) {
                        toast(translate(context, 'select_image'));
                      } else if (amount.text.isEmpty) {
                        toast(translate(context, 'enter_deposit_amount'));
                      } else {
                        Map<String, dynamic> mapData = {
                          "description": description.text.toString(),
                          "price": amount.text.toString(),
                          "amount": amount.text.toString(),
                          "message": description.text.toString(),
                          "cnic": cnic.text.toString(),
                          "tid": tid.text.toString(),
                          "transfer_type": "Bank",
                          "account_no": accnumber.text.toString(),
                          "account_title": accname.text.toString(),
                          "fund_id": "1",
                        };
                        if (pickImage != null) {
                          String? mimeType1 = mime(pickImage!.path);
                          String mimee1 = mimeType1!.split('/')[0];
                          String type1 = mimeType1.split('/')[1];

                          mapData["thumbnail"] = await MultipartFile.fromFile(
                            pickImage!.path,
                            contentType: MediaType(mimee1, type1),
                          );
                        }
                        if (widget.type != null || widget.type != "") {
                          mapData["type"] = "star";
                          mapData["payment_type"] = "star";
                        } else {
                          mapData["payment_type"] = "wallet";
                        }
                      }
                    },
                    child: Text(
                      translate(context, 'submit')!,
                      style: const TextStyle(color: Colors.white),
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
}
