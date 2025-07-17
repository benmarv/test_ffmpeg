import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textinputaction;
  final String? labelText;
  final bool readOnly;
  final bool giveDefaultBorder;
  final bool? isPhoneNumberField;
  final String? hinttext;
  final int? maxLines;
  final bool? isEnabled;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Widget? prefixIconTextField;
  final List<TextInputFormatter>? textinputformetter;
  final void Function()? ontap;
  final int? hintMaxLine;
  const CustomTextField({
    super.key,
    this.textinputformetter,
    this.isPhoneNumberField = false,
    this.prefixIconTextField,
    this.controller,
    this.keyboardType,
    this.labelText,
    this.hinttext,
    this.textinputaction,
    this.maxLines = 1,
    this.ontap,
    this.giveDefaultBorder = false,
    this.hintMaxLine,
    this.suffixIcon,
    this.readOnly = false,
    this.isEnabled,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.textinputformetter,
      onTap: widget.ontap ?? () {},
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      enabled: widget.isEnabled,
      controller: widget.controller,
      textInputAction: widget.textinputaction,
      keyboardType: widget.keyboardType,
      autocorrect: true,
      maxLength: widget.isPhoneNumberField! ? 15 : null,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
      validator: widget.validator,
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
        labelStyle: TextStyle(
          color: FocusNode().hasFocus
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        prefixIcon: widget.prefixIconTextField,
        contentPadding: const EdgeInsets.all(10),
        hintText: widget.hinttext,
        hintMaxLines: widget.hintMaxLine,
        border: widget.giveDefaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                ),
              )
            : InputBorder.none,
        enabledBorder: widget.giveDefaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                ),
              )
            : InputBorder.none,
        focusedBorder: widget.giveDefaultBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                ),
              )
            : InputBorder.none,
        labelText: widget.labelText,
        suffix: widget.suffixIcon,
      ),
    );
  }
}
