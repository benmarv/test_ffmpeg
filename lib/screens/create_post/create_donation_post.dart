// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/viewModel/dio_service.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AddDonation extends StatefulWidget {
  const AddDonation({super.key});

  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController donationTitleController = TextEditingController();
  final TextEditingController donationDescriptionController =
      TextEditingController();
  final TextEditingController donationAmountController =
      TextEditingController();

  File? _imageFile;
  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    log('My Image File is ${_imageFile.toString()}');
  }

  void createDonationPost() async {
    customDialogueLoader(context: context);
    Map<String, dynamic> dataArray = {};
    // data array
    dataArray['privacy'] = 1;
    dataArray['post_type'] = 'donation';
    if (donationTitleController.text.trim().isNotEmpty) {
      dataArray['post_text'] = donationTitleController.text;
    }
    if (donationDescriptionController.text.trim().isNotEmpty) {
      dataArray['description'] = donationDescriptionController.text;
    }
    if (donationAmountController.text.trim().isNotEmpty) {
      dataArray['amount'] = donationAmountController.text;
    }

    String? mimeType1 = mime(_imageFile!.path);
    String mimee1 = mimeType1!.split('/')[0];
    String type1 = mimeType1.split('/')[1];
    dataArray['donation_image'] = await MultipartFile.fromFile(
      _imageFile!.path,
      filename: _imageFile!.path.split('/').last,
      contentType: MediaType(mimee1, type1),
    );

    FormData form = FormData.fromMap(dataArray);

    try {
      var accessToken = getStringAsync("access_token");
      Response res = await dioService.dio.post(
        "post/create",
        data: form,
        cancelToken: cancelToken,
        options: Options(headers: {"Authorization": 'Bearer $accessToken'}),
      );
      if (res.data['code'] == '200') {
        toast(res.data['message']);
        final provider = Provider.of<GreetingsProvider>(context, listen: false);
        provider.setCurrentTabIndex(index: 2);

        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TabsPage()))
            .then((value) {});
      } else {
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      Navigator.pop(context);

      log('create donation error : ${e.response?.data}');
    }
  }

  final defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.2),
    ),
  );

  @override
  void initState() {
    final pro = Provider.of<PostProvider>(context, listen: false);
    if (pro.taggedUserIds.isNotEmpty || pro.taggedUserNames.isNotEmpty) {
      pro.taggedUserIds.clear();
      pro.taggedUserNames.clear();
    }
    super.initState();
  }

  @override
  void dispose() {
    donationTitleController.dispose();
    donationDescriptionController.dispose();
    donationAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'raise_funding')!,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (donationTitleController.text.trim().isEmpty) {
                    toast(translate(context, 'title_required'));
                  } else if (donationDescriptionController.text
                      .trim()
                      .isEmpty) {
                    toast(translate(context, 'description_required'));
                  } else if (donationAmountController.text.trim().isEmpty) {
                    toast(translate(context, 'amount_required'));
                  } else {
                    createDonationPost();
                  }
                }
              },
              child: Text(
                translate(context, 'create')!,
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'required');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: donationTitleController,
                  decoration: InputDecoration(
                    labelText: translate(context, 'donation_title'),
                    border: defaultBorder,
                    enabledBorder: defaultBorder,
                    focusedBorder: defaultBorder,
                    errorBorder: defaultBorder,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'required');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: donationDescriptionController,
                  decoration: InputDecoration(
                    labelText: translate(context, 'donation_description'),
                    border: defaultBorder,
                    enabledBorder: defaultBorder,
                    focusedBorder: defaultBorder,
                    errorBorder: defaultBorder,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return translate(context, 'required');
                    }
                    final numValue = int.tryParse(val);

                    if (numValue == null || numValue <= 10) {
                      return translate(context,
                          "your_amount_must_be_greater_than_10_dollars");
                    }

                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: donationAmountController,
                  decoration: InputDecoration(
                    labelText: translate(context, 'donation_amount'),
                    border: defaultBorder,
                    enabledBorder: defaultBorder,
                    focusedBorder: defaultBorder,
                    errorBorder: defaultBorder,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: _getImage,
                  child: Container(
                    height: 200,
                    width: MediaQuery.sizeOf(context).width,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: _imageFile != null
                        ? Image(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                translate(context, 'upload_image')!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
