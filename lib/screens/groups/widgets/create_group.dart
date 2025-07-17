import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/controllers/GroupsProvider/groups_provider.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:http_parser/http_parser.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();

  List privicylist = [
    'public',
    'private',
  ];
  int? privicy;
  File? groupcoverpic;

  Future groupCover(type) async {
    XFile? groupcover;
    if (type == "camera") {
      groupcover = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      groupcover = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (groupcover != null) {
      setState(() {
        groupcoverpic = File(groupcover!.path);
      });
    }
  }

  final TextEditingController _grouptitle = TextEditingController();
  SiteSetting? site;

  @override
  void initState() {
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    super.initState();
  }

  final TextEditingController _about = TextEditingController();
  String? _dropDownKey;
  String? _dropDownValue;
  String? privicyvalue;

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
              )),
          title: Text(
            translate(context, 'create_new_group').toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: groupcoverpic != null
                      ? BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: FileImage(groupcoverpic!),
                              fit: BoxFit.cover))
                      : BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
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
                              coverBottom();
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
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: _grouptitle,
                  maxLines: 1,
                  labelText: translate(context, 'group_title').toString(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_group_title').toString();
                    }
                    if (val.length < 3) {
                      return translate(context, 'title_min_limit');
                    }
                    if (val.length > 50) {
                      return translate(context, 'title_exceed_limit');
                    }
                    return null;
                  },
                  giveDefaultBorder: true,
                  hinttext: translate(context, 'enter_group_title').toString(),
                  textinputaction: TextInputAction.next,
                ),
                20.sh,
                CustomTextField(
                  controller: _about,
                  maxLines: null,
                  labelText: translate(context, 'group_info').toString(),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_group_info').toString();
                    }
                    return null;
                  },
                  giveDefaultBorder: true,
                  hinttext: translate(context, 'enter_group_info').toString(),
                  textinputaction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                dropDwonPrivicy(),
                const SizedBox(
                  height: 20,
                ),
                dropDwonCategory(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (groupcoverpic == null) {
                          toast(translate(context, 'select_group_cover')
                              .toString());
                        } else if (privicyvalue == '' || privicyvalue == null) {
                          toast(translate(context, 'select_group_privacy')
                              .toString());
                        } else if (_dropDownKey == '' || _dropDownKey == null) {
                          toast(translate(context, 'select_group_category')
                              .toString());
                        } else {
                          Map<String, dynamic> mapData = {
                            "group_title": _grouptitle.text,
                            "category": _dropDownKey,
                            "privacy": privicyvalue,
                            "about_group": _about.text,
                          };

                          if (groupcoverpic != null) {
                            String? mimeType = mime(groupcoverpic?.path);
                            String mimee = mimeType!.split('/')[0];
                            String type = mimeType.split('/')[1];
                            mapData["cover"] = await MultipartFile.fromFile(
                              groupcoverpic!.path,
                              contentType: MediaType(mimee, type),
                            );
                          }

                          await context
                              .read<GroupsProvider>()
                              .createGroup(context, mapData: mapData);
                        }
                      }
                    },
                    child: Text(
                      translate(context, 'create_group').toString(),
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

  coverBottom() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

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
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              InkWell(
                  onTap: () {
                    groupCover("camera");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(translate(context, 'open_camera').toString()),
                  )),
              InkWell(
                  onTap: () {
                    groupCover("gallery");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.photo),
                    title: Text(translate(context, 'open_gallery').toString()),
                  )),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  items: site!.groupCategories.entries.map(
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
                        _dropDownKey = val;
                        _dropDownValue = site!.groupCategories[val];
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

  Widget dropDwonPrivicy() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: privicyvalue == null
                      ? Text(
                          translate(context, 'select_privacy').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          privicyvalue!,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  items: privicylist.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          translate(context, val)!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? val) {
                    setState(
                      () {
                        privicyvalue = val;
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
