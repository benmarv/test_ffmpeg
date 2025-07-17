// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final void Function()? onpress;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  const CustomButton(
      {super.key,
      required this.title,
      this.onpress,
      this.color,
      this.textColor,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AppButton(
      elevation: 0,
      width: width ?? size.width,
      height: height,
      text: title,
      color: color ?? AppColors.primaryColor,
      textColor: textColor ?? Colors.white,
      onTap: onpress,
    );
  }
}
