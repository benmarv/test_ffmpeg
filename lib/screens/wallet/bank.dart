import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'bank_form.dart';

class Bank extends StatefulWidget {
  final String? type;
  const Bank({super.key, this.type});
  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  File? pickImage;
  uploadFie() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickImage = File(image.path);
      setState(() {});
    } else {
      toast("Select again");
    }
  }

  SiteSetting? site;
  bool isdata = false;
  Future<void> getSiteSettings() async {
    Response response = await dioService.dio.get(
      'get_site_settings',
      cancelToken: cancelToken,
    );

    dynamic res = response.data;
    if (res["status"] == '200') {
      site = SiteSetting.fromJson(res["data"]);
      isdata = true;
      setState(() {});
    } else {
      log('Error: ${res['message']}');
    }
  }

  @override
  void initState() {
    super.initState();
    getSiteSettings();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
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
        title: const Text(
          "Bank Transfer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isdata == false
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.sh,
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor.withOpacity(0.2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            site!.bankName ?? "",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          10.sh,
                          const Text(
                            "Account Number/IBN",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          2.sh,
                          InkWell(
                            onTap: () {
                              if (site?.bankAccountNumber != null) {
                                Clipboard.setData(ClipboardData(
                                        text: site!.bankAccountNumber ?? ""))
                                    .then((_) {
                                  toast('Account number copied successfully');
                                });
                              } else {}
                            },
                            child: Text(
                              site!.bankAccountNumber ?? "",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.sh,
                                  const Text(
                                    "Account Title",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  2.sh,
                                  Text(
                                    site!.bankAccountTitle ?? "",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.sh,
                                  const Text(
                                    "Country",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  2.sh,
                                  const Text(
                                    "Pakistan",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    20.sh,
                    Text(
                      site!.bankTransferNote ?? "",
                      style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    20.sh,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: Colors.grey.shade500,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        12.sw,
                        MaterialButton(
                          color: AppColors.primaryColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BankForm(type: widget.type)));
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    20.sh,
                  ],
                ),
              ),
            ),
    );
  }
}
