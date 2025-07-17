// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

import 'package:http_parser/http_parser.dart';

class CreateProducts extends StatefulWidget {
  final bool? isFromTimeline;
  const CreateProducts({super.key, this.isFromTimeline = false});

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDiscription = TextEditingController();
  final TextEditingController _productCurrency = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productType = TextEditingController();
  final TextEditingController _productLocation = TextEditingController();
  final TextEditingController _productCategory = TextEditingController();
  final TextEditingController _productUnit = TextEditingController();
  late SiteSetting siteSetting;
  dynamic dropDownCurrencyValue;
  @override
  void initState() {
    super.initState();
    siteSetting = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
  }

  @override
  void dispose() {
    super.dispose();
    _productName.dispose();
    _productDiscription.dispose();
    _productCurrency.dispose();
    _productPrice.dispose();
    _productType.dispose();
    _productLocation.dispose();
    _productCategory.dispose();
    _productUnit.dispose();
  }

  File? productPic;
  List<File> multiImage = [];
  Future groupCover(
    type,
  ) async {
    XFile? image;
    List<XFile> images = [];
    if (type == "camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      images = await ImagePicker().pickMultiImage();
    }
    if (image != null) {
      setState(() {
        multiImage.add(File(image!.path));
      });
    } else if (images.isNotEmpty == true) {
      for (int i = 0; i < images.length; i++) {
        multiImage.add(File(images[i].path));
      }
      setState(() {});
    } else {
      toast("Image not selected select again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                )),
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Text(
              translate(context, 'add_product').toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    multiImage.isNotEmpty
                        ? multiImage.length > 1
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 2.0),
                                itemCount: multiImage.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return InkWell(
                                    onTap: () {
                                      coverBottom();
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              .27,
                                      width: MediaQuery.sizeOf(context).width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(5.0),
                                          topLeft: Radius.circular(5.0),
                                        ),
                                        image: DecorationImage(
                                            image: FileImage(multiImage[i]),
                                            fit: BoxFit.cover),
                                      ),
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            multiImage.removeAt(i);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.1, 1),
                                                  blurRadius: 15.0),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              )
                            : InkWell(
                                onTap: () {
                                  coverBottom();
                                },
                                child: PhysicalModel(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  elevation: 0.0,
                                  child: Container(
                                    height: 200,
                                    width: MediaQuery.sizeOf(context).width,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.file(
                                      multiImage[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                        : InkWell(
                            onTap: () {
                              coverBottom();
                            },
                            child: Container(
                              height: 200,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xff505666).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                  Text(
                                    translate(context, 'choose_image')
                                        .toString(),
                                  )
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      controller: _productName,
                      labelText: translate(context, 'product_name').toString(),
                      hinttext:
                          translate(context, 'enter_product_name').toString(),
                      maxLines: 1,
                      // validator: (val) {
                      //   if (val!.trim().isEmpty) {
                      //     return translate(context, 'enter_product_name')
                      //         .toString();
                      //   }
                      //   return null;
                      // },
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_product_name')
                              .toString();
                        }

                        // Basic validation regex for alphanumeric characters and spaces
                        final RegExp productNameRegex =
                            RegExp(r'^[a-zA-Z\s]+$', caseSensitive: false);

                        if (!productNameRegex.hasMatch(val)) {
                          return translate(context, 'invalid_characters')
                              .toString();
                        }

                        return null;
                      },
                      giveDefaultBorder: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      labelText:
                          translate(context, 'product_description').toString(),
                      controller: _productDiscription,
                      keyboardType: TextInputType.multiline,
                      giveDefaultBorder: true,
                      hinttext: translate(context, 'enter_product_description')
                          .toString(),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_product_description')
                              .toString();
                        }
                        final RegExp descriptionRegex =
                            RegExp(r'^[a-zA-Z0-9\s,.]+$');

                        if (!descriptionRegex.hasMatch(val)) {
                          return translate(
                                  context, 'invalid_description_format')
                              .toString();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                      controller: _productPrice,
                      labelText: translate(context, 'product_price').toString(),
                      hinttext:
                          translate(context, 'enter_product_price').toString(),
                      giveDefaultBorder: true,
                      maxLines: 1,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return translate(context, 'enter_product_price')
                              .toString();
                        }
                        final RegExp priceRegex = RegExp(r'^\d+(\.\d{1,2})?$');

                        if (!priceRegex.hasMatch(val)) {
                          return translate(context, 'invalid_price_format')
                              .toString();
                        }

                        // Convert string to double for comparison
                        final double price = double.parse(val);

                        if (price <= 0 || price > 99999999.99) {
                          return translate(context, 'price_out_of_range')
                              .toString();
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            currncyDropDown(),
                          ],
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              productTypeDropDown(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: _productLocation,
                                giveDefaultBorder: true,
                                labelText:
                                    translate(context, 'location').toString(),
                                maxLines: 1,
                                keyboardType: TextInputType.name,
                                hinttext: translate(context, 'location_hint')
                                    .toString(),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return translate(context, 'required')
                                        .toString();
                                  }
                                  final RegExp locationRegex =
                                      RegExp(r'^[a-zA-Z\s-]+$');

                                  if (!locationRegex.hasMatch(val)) {
                                    return translate(context, 'invalid')
                                        .toString();
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                giveDefaultBorder: true,
                                controller: _productUnit,
                                labelText: translate(context, 'total_item_unit')
                                    .toString(),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return translate(context, 'required')
                                        .toString();
                                  }

                                  // Basic validation regex for positive integer
                                  final RegExp integerRegex = RegExp(r'^\d+$');

                                  if (!integerRegex.hasMatch(val)) {
                                    return translate(context, 'invalid_integer')
                                        .toString();
                                  }

                                  // Convert string to int for comparison
                                  final int itemCount = int.parse(val);

                                  if (itemCount <= 0 || itemCount > 1000000) {
                                    return translate(context, 'invalid')
                                        .toString();
                                  }

                                  return null;
                                },
                                maxLines: 1,
                                hinttext:
                                    translate(context, 'total_item_unit_hint')
                                        .toString(),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    25.sh,
                    productCategoryDropDown(),
                    const SizedBox(
                      height: 15,
                    ),
                    AppButton(
                      elevation: 0,
                      width: MediaQuery.sizeOf(context).width,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: AppColors.primaryColor,
                      textColor: Colors.white,
                      text: translate(context, 'publish').toString(),
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if ((productPic == null && multiImage.isEmpty)) {
                            toast(translate(context, 'select_product_image')
                                .toString());
                          } else if (dropDownCurrencyValue == null) {
                            toast(translate(context, 'enter_product_currency')
                                .toString());
                          } else if (productType == null) {
                            toast(translate(context, 'enter_product_type')
                                .toString());
                          } else if (category == null) {
                            toast(translate(context, 'enter_product_category')
                                .toString());
                          } else {
                            Map<String, dynamic> mapData = {
                              "product_name": _productName.text,
                              "product_description": _productDiscription.text,
                              "category": category,
                              "price": _productPrice.text,
                              "location": _productLocation.text,
                              "type": productType,
                              "currency": dropDownCurrencyValue,
                              "units": _productUnit.text
                            };
                            if (productPic != null) {
                              String? mimeType1 = mime(productPic!.path);
                              String mimee1 = mimeType1!.split('/')[0];
                              String type1 = mimeType1.split('/')[1];

                              mapData["images[]"] =
                                  await MultipartFile.fromFile(
                                productPic!.path,
                                contentType: MediaType(mimee1, type1),
                              );
                            } else {
                              List<MultipartFile> multiPartList = [];
                              for (int i = 0; i < multiImage.length; i++) {
                                multiPartList.add(await MultipartFile.fromFile(
                                    multiImage[i].path));
                              }
                              mapData["images[]"] = multiPartList;
                            }

                            Provider.of<GetProductProvider>(context,
                                    listen: false)
                                .createProduct(
                              context: context,
                              mapData: mapData,
                              isFromTimeline: widget.isFromTimeline,
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  coverBottom({int? index}) {
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
                  groupCover("camera");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(translate(context, 'open_camera')!),
                ),
              ),
              InkWell(
                onTap: () {
                  groupCover("gallery");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(translate(context, 'open_gallery')!),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget currncyDropDown() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: DropdownButton(
        hint: dropDownCurrencyValue == null
            ? Text(
                translate(context, 'currency').toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              )
            : Text(
                dropDownCurrencyValue!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
        isExpanded: true,
        value: dropDownCurrencyValue,
        dropdownColor: Theme.of(context).colorScheme.secondary,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        underline: const SizedBox.shrink(),
        items: siteSetting.currecyArray.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            dropDownCurrencyValue = value;
          });
        },
      ),
    );
  }

  List<String> productTypeList = ["used", "new"];
  var productType;

  Widget productTypeDropDown() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: Colors.grey.withOpacity(.5)),
      ),
      child: DropdownButton(
        hint: productType == null
            ? Text(
                translate(context, 'product_type').toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              )
            : Text(
                productType!,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        dropdownColor: Theme.of(context).colorScheme.secondary,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        value: productType,
        items: productTypeList.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              translate(context, item).toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            productType = value;
          });
        },
      ),
    );
  }

  var category;

  Widget productCategoryDropDown() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: Colors.grey.withOpacity(.5),
        ),
      ),
      child: DropdownButton(
        hint: category == null
            ? Text(
                translate(context, 'category').toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              )
            : Text(
                category!,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
        underline: const SizedBox.shrink(),
        isExpanded: true,
        dropdownColor: Theme.of(context).colorScheme.secondary,
        value: category,
        style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        items: siteSetting.productCategories.entries.map(
          (val) {
            return DropdownMenuItem<String>(
              value: val.key,
              child: Text(
                val.value,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          },
        ).toList(),
        onChanged: (value) {
          setState(() {
            category = value;
          });
        },
      ),
    );
  }
}
