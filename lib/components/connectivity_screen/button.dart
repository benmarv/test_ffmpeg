import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';

custonButton(
    {required void Function()? onPressed, required BuildContext context}) {
  return OutlinedButton(
    onPressed: onPressed,
    child: Text(
      translate(context, "try_again").toString(),
      style: TextStyle(color: AppColors.primaryColor),
    ),
  );
}
