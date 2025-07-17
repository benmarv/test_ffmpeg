import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/controllers/profile_post_provider.dart/userdata_notifier.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class AccountSubpage extends StatefulWidget {
  final String? id;
  const AccountSubpage({super.key, this.id});
  @override
  _AccountSubpageState createState() => _AccountSubpageState();
}

class _AccountSubpageState extends State<AccountSubpage> {
  final _formKey = GlobalKey<FormState>();

  bool isFormValid = false;

  String? dropdwonrelation;
  int? relationindex;
  Usr getUsrData = Usr();
  @override
  void initState() {
    super.initState();
    getUsrData = Usr.fromJson(
      jsonDecode(
        getStringAsync("userData"),
      ),
    );
  }

  List relation = ["none", "single", "in_a_relationship", "married", "engaged"];
  final TextEditingController _working =
      TextEditingController(text: getUserData.value.working);
  final TextEditingController _about =
      TextEditingController(text: getUserData.value.aboutYou);
  final TextEditingController _city =
      TextEditingController(text: getUserData.value.city);
  final TextEditingController _firstName =
      TextEditingController(text: getUserData.value.firstName);
  final TextEditingController _lastName =
      TextEditingController(text: getUserData.value.lastName);
  final TextEditingController _phoneNumber =
      TextEditingController(text: getUserData.value.phone);
  final TextEditingController _facebook =
      TextEditingController(text: getUserData.value.facebook);
  final TextEditingController _youtube =
      TextEditingController(text: getUserData.value.youtube);
  final TextEditingController _instagram =
      TextEditingController(text: getUserData.value.instagram);

  Future<void> updateUserData({cover, profile, id}) async {
    customDialogueLoader(context: context);

    Map<String, dynamic> dataArray = {};

    if (cover != null && cover != "") {
      String? mimeType = mime(cover);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      dataArray['cover'] = await MultipartFile.fromFile(cover,
          filename: cover.split('/').last, contentType: MediaType(mimee, type));
    }

    if (profile != null && profile != "") {
      String? mimeType1 = mime(profile);
      String mimee1 = mimeType1!.split('/')[0];
      String type1 = mimeType1.split('/')[1];
      dataArray['avatar'] = await MultipartFile.fromFile(profile,
          filename: profile.split('/').last,
          contentType: MediaType(mimee1, type1));
    }

    if (relationindex != null) {
      dataArray['relation_id'] = relationindex;
    }

    dataArray['working'] = _working.text;

    dataArray['about_you'] = _about.text;

    dataArray['city'] = _city.text;

    if (_firstName.text != "") {
      dataArray['first_name'] = _firstName.text;
    }
    if (_lastName.text != "") {
      dataArray['last_name'] = _lastName.text;
    }

    dataArray['phone'] = _phoneNumber.text;

    dataArray['facebook'] = _facebook.text;

    dataArray['instagram'] = _instagram.text;

    dataArray['youtube'] = _youtube.text;

    dynamic res = await apiClient.callApiCiSocial(
        apiPath: 'update-user-profile', apiData: dataArray);

    if (res["code"] == '200') {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileTab(
              userId: id,
            ),
          ),
        );
      }
      toast(res['message']);

      getUserDataFunc(id);
      setState(() {});
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> getUserDataFunc(userid) async {
    dynamic res = await apiClient.get_user_data(userId: userid);
    if (res["code"] == '200') {
      await setValue("userData", res["data"]);
      getUserData.value = Usr.fromJson(
        jsonDecode(
          getStringAsync("userData"),
        ),
      );
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.tabs, (Route<dynamic> route) => false);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            translate(context, AppString.update_profile).toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  updateUserData(
                    id: widget.id,
                    cover: coverpic?.path,
                    profile: profilepic?.path,
                  );
                }
              },
              child: Row(
                children: [
                  Text(
                    translate(context, AppString.publish).toString(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate(
                                context, AppString.change_your_profile_picture)
                            .toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      profileBottom();
                    },
                    child: profilepic == null
                        ? Container(
                            height: MediaQuery.sizeOf(context).height * .15,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black.withOpacity(0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                  spreadRadius: 5,
                                )
                              ],
                              image: DecorationImage(
                                image: NetworkImage(getUsrData.avatar!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        : Container(
                            height: MediaQuery.sizeOf(context).height * .15,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black12.withOpacity(0.05),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                    spreadRadius: 5,
                                  )
                                ],
                                image: DecorationImage(
                                    image: FileImage(profilepic!),
                                    fit: BoxFit.cover)),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translate(context, AppString.change_your_cover_photo)
                            .toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // site!.chckProfileBack == '1'
                      //     ?
                      coverBottom();
                      // : toast('You Can\'t Change Your Cover');
                    },
                    child: coverpic == null
                        ? Container(
                            height: MediaQuery.sizeOf(context).height * .20,
                            width: MediaQuery.sizeOf(context).width * 0.95,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.1),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(getUsrData.cover!),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            height: MediaQuery.sizeOf(context).height * .20,
                            width: MediaQuery.sizeOf(context).width * 0.95,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.1),
                              ),
                              image: DecorationImage(
                                image: FileImage(coverpic!),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Your First Name';
                      } else {
                        return null;
                      }
                    },
                    giveDefaultBorder: true,
                    controller: _firstName,
                    maxLines: 1,
                    hinttext:
                        translate(context, AppString.enter_your_first_name),
                    labelText: translate(context, AppString.your_first_name),
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _lastName,
                    maxLines: 1,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter Your Last Name';
                      } else {
                        return null;
                      }
                    },
                    hinttext:
                        translate(context, AppString.enter_your_last_name),
                    labelText: translate(context, AppString.your_last_name),
                    giveDefaultBorder: true,
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: _city,
                    maxLines: null,
                    giveDefaultBorder: true,
                    labelText: translate(context, AppString.your_address),
                    hinttext: translate(context, AppString.enter_your_address),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Address is required';
                      }
                      // Corrected regular expression to allow letters, numbers, spaces, and , - #
                      if (RegExp(r'[^a-zA-Z0-9\s,#-]').hasMatch(val)) {
                        return 'Only letters, numbers, spaces, commas (,), hyphens (-), and hashes (#) are allowed';
                      }
                      return null;
                    },
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    isPhoneNumberField: true,
                    keyboardType: TextInputType.number,
                    controller: _phoneNumber,
                    maxLines: 1,
                    giveDefaultBorder: true,
                    labelText: translate(context, AppString.your_phone_number),
                    hinttext:
                        translate(context, AppString.enter_your_phone_number),
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _working,
                    maxLines: 1,
                    // validator: (val) {
                    //   if (val!.isEmpty) {
                    //     return 'Put Your Workplace';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    giveDefaultBorder: true,
                    hinttext:
                        translate(context, AppString.enter_your_workplace),
                    labelText: translate(context, AppString.your_workplace),
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _about,
                    maxLines: null,
                    // validator: (val) {
                    //   if (val!.isEmpty) {
                    //     return 'Enter Your About Info';
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    giveDefaultBorder: true,
                    hinttext:
                        translate(context, AppString.enter_your_about_info),
                    labelText: translate(context, AppString.your_about),
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(translate(context, AppString.relationship_status)
                          .toString()),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Center(
                          child: dropDwonRelation(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _facebook,
                    maxLines: 1,
                    hinttext:
                        translate(context, AppString.enter_your_facebook_link)
                            .toString(),
                    labelText: translate(context, AppString.facebook_link),
                    giveDefaultBorder: true,
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _instagram,
                    maxLines: 1,
                    giveDefaultBorder: true,
                    hinttext:
                        translate(context, AppString.enter_your_instagram_link),
                    labelText: translate(context, AppString.instagram_link),
                    textinputaction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    controller: _youtube,
                    maxLines: 1,
                    giveDefaultBorder: true,
                    hinttext:
                        translate(context, AppString.enter_your_youtube_link),
                    labelText: translate(context, AppString.youtube_link),
                    textinputaction: TextInputAction.next,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDwonRelation() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Theme.of(context).colorScheme.secondary,
            hint: dropdwonrelation == null
                ? Text(
                    translate(
                            context,
                            relation[
                                int.parse(getUserData.value.relationId!)]) ??
                        translate(context, 'relationship_status')!,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  )
                : Text(
                    dropdwonrelation!,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
            items: relation.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    translate(context, val)!,
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
                  dropdwonrelation = translate(context, val!);
                  relationindex = relation.indexOf(val);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  coverBottom() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).colorScheme.secondary,
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
                    coverPhoto("camera");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: Text(translate(context, 'open_camera')!),
                  )),
              InkWell(
                  onTap: () {
                    coverPhoto("gallery");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.photo),
                    title: Text(translate(context, 'open_gallery')!),
                  )),
            ],
          ),
        );
      },
    );
  }

  profileBottom() {
    return showModalBottomSheet(
      isDismissible: true, // Set to true to allow dismissing on tap outside

      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Theme.of(context).colorScheme.secondary,
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
                    profilePhoto("camera");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text(translate(context, 'open_camera')!),
                  )),
              InkWell(
                  onTap: () {
                    profilePhoto("gallery");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text(translate(context, 'open_gallery')!),
                  )),
            ],
          ),
        );
      },
    );
  }

  File? coverpic;
  File? profilepic;

  Future coverPhoto(type) async {
    XFile? groupcover;
    if (type == "camera") {
      groupcover = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      groupcover = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (groupcover != null) {
      setState(() {
        coverpic = File(groupcover!.path);
      });
    }
  }

  Future profilePhoto(type) async {
    XFile? groupcover;
    if (type == "camera") {
      groupcover = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      groupcover = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (groupcover != null) {
      setState(() {
        profilepic = File(groupcover!.path);
      });
    }
  }
}
