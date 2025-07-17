import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:mime_type/mime_type.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/components/custom_text_field.dart';
import 'package:link_on/models/product_model/product_model.dart' as product;
import 'package:link_on/models/site_setting.dart';
import 'package:link_on/controllers/product/get_product_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:developer' as dev;

class EditProduct extends StatefulWidget {
  final String? id;
  const EditProduct({super.key, this.id, required this.productModel});
  final product.ProductsModel? productModel;
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late final TextEditingController _productName;
  late final TextEditingController _productDiscription;
  late final TextEditingController _productCurrency;
  late final TextEditingController _productPrice;
  late final TextEditingController _productLocation;
  late final TextEditingController _productCategory;
  late final TextEditingController _productUnit;
  late SiteSetting siteSetting;
  var dropDownCurrencyValue;

  @override
  void initState() {
    super.initState();
    siteSetting = SiteSetting.fromJson(jsonDecode(getStringAsync("config")));
    _initializeValue();
  }

  void _initializeValue() {
    if (widget.productModel?.images.isNotEmpty == true) {
      for (product.Image image in widget.productModel!.images) {
        multiImage.add({
          "id": image.id,
          "path": image.image,
        });
      }
    }

    _productName =
        TextEditingController(text: widget.productModel?.productName);
    _productDiscription =
        TextEditingController(text: widget.productModel?.productDescription);
    _productCurrency =
        TextEditingController(text: widget.productModel?.currency);
    _productPrice = TextEditingController(text: widget.productModel?.price);

    _productLocation =
        TextEditingController(text: widget.productModel?.location);
    _productCategory =
        TextEditingController(text: widget.productModel?.category);
    _productUnit = TextEditingController(text: widget.productModel?.units);
    categoryValue = widget.productModel!.category;

    log('Product type is ${widget.productModel!.type}');

    productType = widget.productModel!.type == 1 ? 'new' : 'used';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _productName.dispose();
    _productDiscription.dispose();
    _productCurrency.dispose();
    _productPrice.dispose();
    _productLocation.dispose();
    _productCategory.dispose();
    _productUnit.dispose();
  }

  List<Map<String, dynamic>> multiImage = [];
  List<String> imagesIds = [];
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
        multiImage.add({"id": null, "path": image!.path});
      });
    } else if (images.length > 12) {
      toast("Selected image length must be less than 12");
    } else if (images.isNotEmpty == true) {
      for (int i = 0; i < images.length; i++) {
        multiImage.add({"id": null, "path": images[i].path});
      }
      setState(() {});
    } else {
      toast("Image not selected select again");
    }
  }

  String? categoryValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          translate(context, "edit_product").toString(),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  multiImage.isNotEmpty
                      ? multiImage.length > 1
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 2.0,
                              ),
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
                                        MediaQuery.sizeOf(context).height * .27,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0),
                                      ),
                                      image: multiImage[i]['path']
                                                  .startsWith("https") ==
                                              true
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  multiImage[i]["path"]),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: FileImage(
                                                  File(multiImage[i]["path"])),
                                              fit: BoxFit.cover),
                                    ),
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          if (multiImage[i]['id'] != null) {
                                            imagesIds.add(multiImage[i]["id"]);
                                          }
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
                                              blurRadius: 15.0,
                                            ),
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
                                borderRadius: BorderRadius.circular(4),
                                elevation: 0.0,
                                child: SizedBox(
                                  height: 200,
                                  width: MediaQuery.sizeOf(context).width,
                                  child: multiImage[0]['path']
                                              .startsWith("https") ==
                                          true
                                      ? Image.network(multiImage[0]['path'])
                                      : Image.file(
                                          File(multiImage[0]['path']),
                                          fit: BoxFit.contain,
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
                            color: Colors.black12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                                Text(translate(context, 'choose_image')
                                        .toString() // Translated text
                                    )
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    labelText: translate(
                        context, 'your_product_name'), // Translated label
                    controller: _productName,
                    hinttext: translate(context,
                        'enter_your_product_name'), // Translated hint text
                    giveDefaultBorder: true,
                    maxLines: null,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return translate(context,
                            'enter_your_product_name'); // Translated validation message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    labelText: translate(context,
                        'your_product_description'), // Translated label
                    controller: _productDiscription,
                    giveDefaultBorder: true,
                    keyboardType: TextInputType.multiline,
                    hinttext: translate(context,
                        'enter_your_product_description'), // Translated hint text
                    validator: (val) {
                      if (val!.isEmpty) {
                        return translate(context,
                            'enter_your_product_description'); // Translated validation message
                      }
                      return null;
                    },
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
                              labelText: translate(context,
                                  'your_product_price'), // Translated label
                              controller: _productPrice,
                              giveDefaultBorder: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context,
                                      'required'); // Translated validation message
                                }
                                return null;
                              },
                              maxLines: null,
                              hinttext: translate(context,
                                  'enter_price'), // Translated hint text
                              keyboardType: TextInputType.number,
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
                              labelText: translate(context,
                                  'your_address'), // Use translated text
                              controller: _productLocation,
                              giveDefaultBorder: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context,
                                      'required'); // Translated validation message
                                }
                                return null;
                              },
                              maxLines: null,
                              keyboardType: TextInputType.name,
                              hinttext: translate(context,
                                  'your_address'), // Use translated text
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
                              labelText: translate(context,
                                  'total_item_unit'), // Use translated text
                              controller: _productUnit,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return translate(context,
                                      'required'); // Translated validation message
                                }
                                return null;
                              },
                              maxLines: null,
                              hinttext: translate(context,
                                  'total_item_unit'), // Use translated text
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  productCategoryDropDown(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: AppButton(
                        color: AppColors.primaryColor,
                        text: translate(context, 'update'),
                        textColor: Colors.white,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await _update();
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _update() async {
    if (productType == null) {
      toast(translate(context, 'enter_product_type'));
    } else if (category == null && _productCategory.text.isEmpty) {
      toast(translate(context, 'enter_product_category'));
    } else if (multiImage.isEmpty) {
      toast(translate(context, 'select_product_image'));
    } else {
      Map<String, dynamic> mapData = {
        "product_id": widget.id.toInt(),
        "product_name": _productName.text,
        "product_description": _productDiscription.text,
        "category": category,
        "price": _productPrice.text,
        "location": _productLocation.text,
        "type": productType,
        "units": _productUnit.text,
      };

      List<MultipartFile> multiPartList = [];
      for (int i = 0; i < multiImage.length; i++) {
        String? mimeType = mime(multiImage[i]["path"]);
        String mimee = mimeType!.split('/')[0];
        String type = mimeType.split('/')[1];
        if (multiImage[i]['id'] == null) {
          multiPartList.add(
            await MultipartFile.fromFile(multiImage[i]["path"],
                filename: multiImage[i]["path"].split('/').last,
                contentType: MediaType(mimee, type)),
          );
        }
      }
      mapData["images[]"] = multiPartList;
      if (imagesIds.isNotEmpty) {
        String data =
            imagesIds.toString().replaceAll('[', '').replaceAll(']', '');
        dev.log("===>> $data");
        mapData['deleted_image_ids'] = data;
      }

      // ignore: use_build_context_synchronously
      context
          .read<GetProductProvider>()
          .editProduct(context: context, mapData: mapData);
    }
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
                    leading: Icon(Icons.camera_alt),
                    title: Text(
                      translate(context, "open_camera").toString(),
                    ),
                  )),
              InkWell(
                onTap: () {
                  groupCover("gallery");
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(
                    translate(context, "open_gallery").toString(),
                  ),
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
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
        hint: dropDownCurrencyValue == null
            ? Text(
                translate(context, 'currency').toString(),
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              )
            : Text(
                dropDownCurrencyValue!,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
        isExpanded: true,
        value: dropDownCurrencyValue,
        style: const TextStyle(
            color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
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

  String? productType;

  Widget productTypeDropDown() {
    List<String> productTypeList = [
      'new',
      'used',
    ];
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            translate(context, 'status').toString(),
          ),
          DropdownButton(
            hint: productType == null
                ? Text(
                    productType ??
                        translate(context, 'product_type').toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  )
                : Text(
                    productType.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
            dropdownColor: Theme.of(context).colorScheme.secondary,
            underline: const SizedBox.shrink(),
            isExpanded: true,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            value: productType,
            items: productTypeList.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  translate(context, item).toString(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                int indexx = productTypeList.indexOf(value!);

                productType = productTypeList[indexx];
              });
            },
          ),
        ],
      ),
    );
  }

  var category;
  Widget productCategoryDropDown() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            translate(context, 'select_category').toString(),
          ),
          DropdownButton(
            hint: categoryValue == null
                ? Text(
                    categoryValue ??
                        translate(context, 'select_category').toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  )
                : Text(
                    categoryValue!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
            underline: const SizedBox.shrink(),
            isExpanded: true,
            dropdownColor: Theme.of(context).colorScheme.secondary,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            items: siteSetting.productCategories.entries.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val.key,
                  child: Text(
                    val.value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(
                () {
                  category = value;

                  categoryValue = siteSetting.productCategories[value];
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
