import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:link_on/localization/localization_constant.dart'; // Import the localization function
import 'package:nb_utils/nb_utils.dart';

class AdvertisementCard extends StatefulWidget {
  final String? postId;
  const AdvertisementCard({super.key, required this.postId});

  @override
  State<AdvertisementCard> createState() => _AdvertisementCardState();
}

class _AdvertisementCardState extends State<AdvertisementCard> {
  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  File? _imageFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _bodyTextController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    log('My Image File is ${_imageFile.toString()}');
  }

  Future<void> submitAdvertisementForm() async {
    setState(() {
      isLoading = true;
    });
    log('Add Advertisement...${_imageFile.toString()}');
    Map<String, dynamic> apiData = {
      'post_id': widget.postId,
      'title': _titleController.text,
      'link': _linkController.text,
      'body': _bodyTextController.text,
      'image': await MultipartFile.fromFile(
        _imageFile!.path,
        filename: _imageFile!.path.split('/').last,
      ),
    };

    final response = await apiClient.callApiCiSocial(
      apiData: apiData,
      apiPath: 'post/add-advertisement',
    );
    log('Add Advertisement...${response.toString()}');

    if (response['code'] == '200') {
      if (mounted) {
        Navigator.pop(context);
      }
      toast(
        response['message'],
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _bodyTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.secondary,
        height: 520,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    translate(context, 'advertise_message').toString(),
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    CustomTextField(
                      controller: _titleController,
                      giveDefaultBorder: true,
                      hinttext: translate(context, 'enter_ad_title'),
                      labelText: translate(context, 'your_ad_title'),
                      maxLines: null,
                      validator: (val) {
                        return val!.isEmptyOrNull
                            ? translate(context, 'title_required')
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      labelText: translate(context, 'your_ad_link'),
                      hinttext: translate(context, 'enter_ad_link'),
                      giveDefaultBorder: true,
                      controller: _linkController,
                      maxLines: null,
                      validator: (val) {
                        return val!.isEmptyOrNull
                            ? translate(context, 'link_required')
                            : null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hinttext: translate(context, 'enter_ad_text'),
                      labelText: translate(context, 'your_ad_text'),
                      controller: _bodyTextController,
                      giveDefaultBorder: true,
                      maxLines: null,
                      validator: (val) {
                        return val!.isEmptyOrNull
                            ? translate(context, 'body_text_required')
                            : null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: TextEditingController(
                        text: _imageFile?.path.split('/').last ??
                            translate(context, 'choose_ad_image'),
                      ),
                      validator: (val) {
                        return _imageFile == null
                            ? translate(context, 'image_file_required')
                            : null;
                      },
                      giveDefaultBorder: true,
                      readOnly: true,
                      ontap: _getImage,
                      suffixIcon: _imageFile == null
                          ? const Icon(
                              Icons.upload_file,
                            )
                          : null,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        translate(context, 'recommended_size').toString(),
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            translate(context, 'cancel').toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    submitAdvertisementForm();
                                  }
                                },
                                child: Text(
                                  translate(context, 'submit').toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
