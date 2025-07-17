import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:http_parser/http_parser.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();

  Future<void> createPage(cover, profile) async {
    customDialogueLoader(context: context);
    String? mimeType = mime(cover);
    String mimee = mimeType!.split('/')[0];
    String type = mimeType.split('/')[1];
    String mimee1 = mimeType.split('/')[0];
    String type1 = mimeType.split('/')[1];
    Map<String, dynamic> dataArray = {
      "page_title": _pagetitle.text.toString(),
      "page_category": dropindex,
      "page_description": _aboutpage.text.toString(),
      "cover": await MultipartFile.fromFile(cover,
          filename: cover.split('/').last, contentType: MediaType(mimee, type)),
      "avatar": await MultipartFile.fromFile(profile,
          filename: profile.split('/').last,
          contentType: MediaType(mimee1, type1)),
    };
    log('jjjjjjjjjj');
    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'add-page', apiData: dataArray);
    log('jjjjjjjjjj ${res}');

    if (res["code"] == '200') {
      toast(res['message'].toString());
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ExplorePages(),
            ));
      }

      setState(() {});
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  File? pageavatar;
  String? dropindex;
  File? pagecoverpic;

  Future pageAvatar(type) async {
    XFile? pageimage;
    if (type == "camera") {
      pageimage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pageimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pageimage != null) {
      setState(() {
        pageavatar = File(pageimage!.path);
      });
    }
  }

  Future pageCover(type) async {
    XFile? pagecover;
    if (type == "camera") {
      pagecover = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pagecover = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pagecover != null) {
      setState(() {
        pagecoverpic = File(pagecover!.path);
      });
    }
  }

  final TextEditingController _pagetitle = TextEditingController();
  final TextEditingController _aboutpage = TextEditingController();

  String? _dropDownValue;
  SiteSetting? site;

  @override
  void initState() {
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              )),
          title: Text(
            translate(context, 'create_new_page').toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: pagecoverpic != null
                      ? BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          image: DecorationImage(
                              image: FileImage(pagecoverpic!),
                              fit: BoxFit.cover))
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                        ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, right: 19),
                      child: Container(
                        height: 30,
                        width: 120,
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () async {
                              // ignore: invalid_use_of_visible_for_testing_member
                              PickedFile? image = await ImagePicker.platform
                                  .pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                pagecoverpic = File(image.path);
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.add_to_photos,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                Text(
                                  translate(context, 'add_photo').toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                14.sh,
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: pageavatar != null
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).colorScheme.secondary,
                            image: DecorationImage(
                                image: FileImage(pageavatar!),
                                fit: BoxFit.cover))
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ),
                    child: GestureDetector(
                      onTap: () async {
                        // ignore: invalid_use_of_visible_for_testing_member
                        PickedFile? image = await ImagePicker.platform
                            .pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          pageavatar = File(image.path);
                          setState(() {});
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                25.sh,
                CustomTextField(
                  controller: _pagetitle,
                  giveDefaultBorder: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_your_page_title')
                          .toString();
                    }
                    if (val.length > 50) {
                      return translate(context, 'title_exceed_limit')
                          .toString();
                    }
                    if (val.length < 5) {
                      return translate(context,
                              'page_title_must_be_atleast_5_characters_long')
                          .toString();
                    }
                    return null;
                  },
                  maxLines: 1,
                  labelText: translate(context, 'your_page_title').toString(),
                  hinttext:
                      translate(context, 'enter_your_page_title').toString(),
                  textinputaction: TextInputAction.next,
                ),
                25.sh,
                dropDwonCategory(),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  giveDefaultBorder: true,
                  controller: _aboutpage,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_your_page_info')
                          .toString();
                    }
                    return null;
                  },
                  maxLines: null,
                  labelText: translate(context, 'your_page_info').toString(),
                  hinttext:
                      translate(context, 'enter_your_page_info').toString(),
                  textinputaction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (pagecoverpic == null) {
                          toast(translate(context, 'select_your_page_cover')
                              .toString());
                        } else if (pageavatar == null) {
                          toast(translate(context, 'select_your_page_avatar')
                              .toString());
                        } else if (dropindex == null) {
                          toast(translate(context, 'select_your_page_category')
                              .toString());
                        } else {
                          createPage(pagecoverpic!.path, pageavatar!.path);
                        }
                      }
                    },
                    child: Text(
                      translate(context, 'create_page').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
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

  avatarBottom(context) {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.0,
                width: MediaQuery.sizeOf(context).width * 0.2,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              InkWell(
                onTap: () {
                  pageAvatar("camera");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    translate(context, 'open_camera').toString(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  pageAvatar("gallery");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(
                    translate(context, 'open_gallery').toString(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  coverBottom() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.0,
                width: MediaQuery.sizeOf(context).width * 0.2,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              InkWell(
                onTap: () {
                  pageCover("camera");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    translate(context, 'open_camera').toString(),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  pageCover("gallery");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(
                    translate(context, 'open_gallery').toString(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dropDwonCategory() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? Text(
                          translate(context, 'select_category').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          _dropDownValue!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  items: site!.pageCategories.entries.map(
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
                        dropindex = val;
                        _dropDownValue = site!.pageCategories[val];
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
