// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_on/consts/colors.dart';

class CustomFormFieldAlt extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool? isPasswordField;
  final TextEditingController? controller;
  final bool? enabled;
  final double? height;
  final int? maxLines;
  final Function? onTap;
  final bool? readOnly;
  final bool? isOutlineBorder;
  final List<TextInputFormatter>? inputFormatters;
  final String Function(String)? validator;
  final Function(String)? onChanged;
  final double? bottomPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextStyle? hintTextStyle;

  const CustomFormFieldAlt({
    Key? key,
    this.hintText,
    this.labelText,
    this.label,
    this.icon,
    this.hintTextStyle,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.controller,
    this.enabled = true,
    this.height,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.isOutlineBorder = true,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.bottomPadding = 20.0,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
  }) : super(key: key);

  @override
  _CustomFormFieldAltState createState() => _CustomFormFieldAltState();
}

class _CustomFormFieldAltState extends State<CustomFormFieldAlt> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: const BorderSide(),
    );

    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: const BorderSide(),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding!,
      ),
      child: TextFormField(
        validator: ((value) => widget.validator!(value!)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: AppColors.primaryColor),
          hintText: widget.hintText,
          hintStyle: widget.hintTextStyle ??
              const TextStyle(
                fontWeight: FontWeight.normal,
              ),
          prefixIcon: widget.prefixIcon ??
              (widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: AppColors.primaryColor,
                      size: 26,
                    )
                  : null),
          enabledBorder: outlineBorder,
          focusedBorder: focusBorder,
          border: outlineBorder,
          suffixIcon: widget.suffixIcon ??
              (widget.isPasswordField!
                  ? _buildPasswordFieldVisibilityToggle()
                  : null),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
        keyboardType: widget.keyboardType,
        cursorColor: AppColors.primaryColor,
        obscureText: widget.isPasswordField! ? _obscureText : false,
        controller: widget.controller,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        onTap: (() => widget.onTap),
        readOnly: widget.readOnly!,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
      ),
    );
  }

  Widget _buildPasswordFieldVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: AppColors.primaryColor,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
