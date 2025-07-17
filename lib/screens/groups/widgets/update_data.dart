import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/groups/group.dart';

class UpdateGroupData extends StatefulWidget {
  final JoinGroupModel? joinGroupModel;
  final String? id;
  const UpdateGroupData({super.key, this.joinGroupModel, this.id});

  @override
  State<UpdateGroupData> createState() => _UpdateGroupDataState();
}

class _UpdateGroupDataState extends State<UpdateGroupData> {
  TextEditingController? _grouptitle;
  TextEditingController? _about;
  SiteSetting? site;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    _grouptitle = TextEditingController(
        text: widget.joinGroupModel!.groupTitle.toString());
    _about = TextEditingController(
        text: widget.joinGroupModel!.aboutGroup.toString());
  }

  List categorygroup = [
    'other',
    'cars_and_vehicles',
    'comedy',
    'economics_and_trade',
    'education',
    'entertainment',
    'movies_and_animation',
    'gaming',
    'history_and_facts',
    'live_style',
    'natural',
    'news_and_politics',
    'people_and_nations',
    'pets_and_animals',
    'places_and_regions',
    'science_and_technology',
    'sport',
    'travel_and_events',
  ];

  List privicylist = [
    'public',
    'private',
  ];
  String? groupdropindex;
  String? privicyvalue;
  File? groupcoverpic;
  String? _dropDownValue;

  Future groupCover(type) async {
    dynamic groupcover;
    if (type == "camera") {
      groupcover = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      groupcover = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (groupcover != null) {
      setState(() {
        groupcoverpic = File(groupcover.path);
      });
    }
  }

  bool showLoader = true;

  Future updateGroupDataFuntion(
      {category,
      subCategory,
      groupTitle,
      about,
      File? coverPhoto,
      privicy}) async {
    customDialogueLoader(context: context);
    dynamic res = await apiClient.updateGroupDataApi(
        groupId: widget.id,
        category: category,
        subCategory: subCategory,
        groupTitle: groupTitle,
        about: about,
        privicy: privicy,
        cover: groupcoverpic);
    if (res["code"] == '200') {
      Navigator.pop(context);

      toast("${res['message']}", bgColor: Colors.green);
      toast("${res['message']}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Groups()));
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
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
            translate(context, 'update_group')!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  translate(context, 'group_cover_photo')!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                widget.joinGroupModel!.cover == null
                    ? InkWell(
                        onTap: () {
                          coverBottom();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 20.0),
                          height: MediaQuery.sizeOf(context).height * .25,
                          width: MediaQuery.sizeOf(context).width,
                          decoration:
                              const BoxDecoration(color: Colors.black12),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.collections,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Text(
                                translate(context, 'select_photo')!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )),
                        ),
                      )
                    : GestureDetector(
                        onDoubleTap: () =>
                            Navigator.pushNamed(context, AppRoutes.imageDetail,
                                arguments: DetailScreen(
                                  withoutNetworkImage: groupcoverpic,
                                )),
                        onTap: () => coverBottom(),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * .25,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.joinGroupModel!.cover.toString()),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: _grouptitle,
                  maxLines: null,
                  giveDefaultBorder: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_group_title');
                    }
                    if (val.length > 50) {
                      return translate(context, 'title_exceed_limit');
                    }
                    return null;
                  },
                  labelText: translate(context, 'your_group_title'),
                  hinttext: translate(context, 'enter_group_title'),
                  textinputaction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  giveDefaultBorder: true,
                  controller: _about,
                  maxLines: null,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return translate(context, 'enter_group_info');
                    }
                    return null;
                  },
                  hinttext: translate(context, 'enter_group_info'),
                  labelText: translate(context, 'your_group_info'),
                  textinputaction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  translate(context, 'privacy')!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                dropDwonPrivicy(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  translate(context, 'group_category')!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                dropDwonCategory(),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: translate(context, 'update_group')!,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateGroupDataFuntion(
                          groupTitle: _grouptitle!.text,
                          about: _about!.text,
                          privicy: privicyvalue,
                          coverPhoto: groupcoverpic,
                          category: groupdropindex,
                          subCategory: 4);
                    }
                  },
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
      isDismissible: true,
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
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              InkWell(
                  onTap: () {
                    groupCover("camera");
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Open Camera"),
                  )),
              InkWell(
                  onTap: () {
                    groupCover("gallery");
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Open Gallery"),
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
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? Text(
                          widget.joinGroupModel!.category ??
                              translate(context, 'select_category')!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          _dropDownValue!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
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
                        _dropDownValue = site!.groupCategories[val!];
                        groupdropindex = val;
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
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: privicyvalue == null
                      ? Text(
                          widget.joinGroupModel!.privacy ??
                              translate(context, 'select_privacy')!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          privicyvalue!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                  isExpanded: true,
                  iconSize: 30.0,
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
