import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class CustomInputTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final dynamic keyboardType;
  final Text? label;
  const CustomInputTextFiled(
      {super.key, this.controller, this.label, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primaryColor,
      minLines: 1,
      maxLines: 3,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
