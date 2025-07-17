import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/components/custom_button.dart';
import 'package:link_on/components/custom_form_field.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/custom_loader.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/page_data.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';

class UpdatePage extends StatefulWidget {
  final PageData? pageData;

  const UpdatePage({super.key, this.pageData});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  File? pageavatar;
  String? dropindex;
  File? pagecoverpic;

  final _formKey = GlobalKey<FormState>();

  Future pageAvatar(type) async {
    XFile? pageimage;
    if (type == "camera") {
      pageimage = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      pageimage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    if (pageimage != null) {
      setState(() {
        widget.pageData?.avatar = null;
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
        widget.pageData?.cover = null;
        pagecoverpic = File(pagecover!.path);
      });
    }
  }

  TextEditingController? _pagetitle;
  TextEditingController? _aboutpage;
  TextEditingController? _location;
  TextEditingController? _website;

  String? _dropDownValue;

  Future updatePageData({mapData}) async {
    customDialogueLoader(context: context);
    dynamic res = await apiClient.callApiCiSocial(
        apiData: mapData, apiPath: "update-page");
    if (res["code"] == '200') {
      toast("${res['message']}");

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ExplorePages(),
            ));
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      toast('Something Went Wrong');
    }
  }

  SiteSetting? site;

  @override
  void initState() {
    super.initState();

    site = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));

    _pagetitle =
        TextEditingController(text: widget.pageData!.pageTitle.toString());

    _aboutpage = TextEditingController(
        text: widget.pageData!.pageDescription.toString());
    _location = TextEditingController(
      text: widget.pageData!.address.toString(),
    );

    _website = TextEditingController(text: widget.pageData?.website.toString());
  }

  @override
  Widget build(BuildContext context) {
    final pagetitle = CustomFormField(
      labelText: translate(context, 'your_page_title')!,
      hintText: translate(context, 'enter_your_page_title')!,
      isOutlineBorder: true,
      validator: (val) {
        if (val!.isEmpty) {
          return translate(context, 'enter_your_page_title')!;
        }
        return null;
      },
      controller: _pagetitle,
      color: Theme.of(context).colorScheme.onSurface,
      keyboardType: TextInputType.name,
    );

    final about = CustomFormField(
      labelText: translate(context, 'your_page_info')!,
      hintText: translate(context, 'enter_your_page_info')!,
      isOutlineBorder: true,
      controller: _aboutpage,
      validator: (val) {
        if (val!.isEmpty) {
          return translate(context, 'enter_your_page_info')!;
        }
        return null;
      },
      color: Theme.of(context).colorScheme.onSurface,
      maxLines: null,
    );

    final location = CustomFormField(
      hintText: translate(context, 'enter_your_address')!,
      controller: _location,
      isOutlineBorder: true,
      color: Colors.black,
      labelText: translate(context, 'your_address')!,
      keyboardType: TextInputType.streetAddress,
    );

    final website = CustomFormField(
      hintText: translate(context, 'enter_your_website_link')!,
      controller: _website,
      isOutlineBorder: true,
      color: Colors.black,
      labelText: translate(context, 'your_website_link')!,
      keyboardType: TextInputType.url,
    );

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          title: Text(
            translate(context, 'update_page')!,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translate(context, 'page_avatar_photo')!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                pageavatar == null
                    ? widget.pageData?.avatar != null &&
                            widget.pageData?.avatar != ""
                        ? GestureDetector(
                            onDoubleTap: () => Navigator.pushNamed(
                                context, AppRoutes.imageDetail,
                                arguments: DetailScreen(
                                  image: widget.pageData!.avatar,
                                )),
                            onTap: () {
                              avatarBottom(context);
                            },
                            child: Center(
                              child: CircleAvatar(
                                radius: 90,
                                backgroundColor: AppColors.bgcolor,
                                backgroundImage: NetworkImage(
                                  widget.pageData!.avatar.toString(),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              avatarBottom(context);
                            },
                            child: Center(
                              child: Container(
                                height: 170,
                                width: 170,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.bgcolor,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.collections,
                                        size: 40,
                                      ),
                                      Text(
                                        translate(context, 'select_photo')!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                    : GestureDetector(
                        onDoubleTap: () =>
                            Navigator.pushNamed(context, AppRoutes.imageDetail,
                                arguments: DetailScreen(
                                  withoutNetworkImage: pageavatar,
                                )),
                        onTap: () {
                          avatarBottom(context);
                        },
                        child: Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: AppColors.bgcolor,
                            backgroundImage: FileImage(pageavatar!),
                          ),
                        ),
                      ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translate(context, 'page_cover_photo')!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                pagecoverpic == null
                    ? widget.pageData?.cover != null &&
                            widget.pageData?.cover != ""
                        ? GestureDetector(
                            onDoubleTap: () => Navigator.pushNamed(
                                context, AppRoutes.imageDetail,
                                arguments: DetailScreen(
                                  image: widget.pageData!.cover,
                                )),
                            onTap: () {
                              coverBottom(context);
                            },
                            child: Container(
                              height: MediaQuery.sizeOf(context).height * .25,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      widget.pageData!.cover.toString()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin:
                                const EdgeInsets.only(top: 5.0, bottom: 20.0),
                            height: MediaQuery.sizeOf(context).height * .25,
                            width: MediaQuery.sizeOf(context).width,
                            decoration:
                                const BoxDecoration(color: AppColors.bgcolor),
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
                                  ),
                                ],
                              ),
                            ),
                          )
                    : GestureDetector(
                        onDoubleTap: () =>
                            Navigator.pushNamed(context, AppRoutes.imageDetail,
                                arguments: DetailScreen(
                                  withoutNetworkImage: pagecoverpic,
                                )),
                        onTap: () {
                          coverBottom(context);
                        },
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * .25,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(pagecoverpic!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 25),
                pagetitle,
                const SizedBox(height: 5),
                about,
                Text(translate(context, 'category')!),
                const SizedBox(height: 10),
                dropDwonCategory(context),
                const SizedBox(height: 20),
                website,
                location,
                CustomButton(
                  text: translate(context, 'update_page'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await updatePageFunction();
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

  Future updatePageFunction() async {
    Map<String, dynamic> mapData = {
      "page_id": widget.pageData!.id,
    };
    if (pageavatar != null) {
      String? mimeType = mime(pageavatar!.path);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      mapData["avatar"] = await MultipartFile.fromFile(pageavatar!.path,
          filename: pageavatar?.path.split("/").last,
          contentType: MediaType(mimee, type));
    }
    if (pagecoverpic != null) {
      String? mimeType = mime(pagecoverpic!.path);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      mapData["cover"] = await MultipartFile.fromFile(pagecoverpic!.path,
          filename: pagecoverpic?.path.split("/").last,
          contentType: MediaType(mimee, type));
    }
    if (_pagetitle!.text.isNotEmpty) {
      mapData["page_title"] = _pagetitle!.text;
    }

    if (_location!.text.isEmpty) {
      mapData["address"] = _location!.text;
    }

    if (_location!.text.isNotEmpty) {
      mapData["address"] = _location!.text;
    }
    if (_aboutpage!.text.isNotEmpty) {
      mapData["page_description"] = _aboutpage!.text;
    }
    if (dropindex != null) {
      mapData["page_category"] = dropindex;
    }

    if (_website!.text.isNotEmpty) {
      mapData["website"] = _website!.text;
    }

    if (_website!.text.isEmpty) {
      mapData['website'] = _website!.text;
    }
    await updatePageData(mapData: mapData);
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
                  color: Colors.grey.withOpacity(0.5),
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
                  )),
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
                  )),
            ],
          ),
        );
      },
    );
  }

  coverBottom(BuildContext context) {
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
                    leading: Icon(Icons.camera_alt),
                    title: Text(translate(context, "open_camera")!),
                  )),
              InkWell(
                  onTap: () {
                    pageCover("gallery");
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text(translate(context, "open_gallery")!),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget dropDwonCategory(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? Text(
                          translate(context, 'select_category')!,
                        )
                      : Text(
                          _dropDownValue!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
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
