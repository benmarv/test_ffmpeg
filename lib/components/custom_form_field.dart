// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final double? border;
  final String? label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool? isPasswordField;
  final TextEditingController? controller;
  final bool? enabled;
  final double? height;
  final int? maxLines;
  final Function? onTap;
  final bool readOnly;
  final bool isOutlineBorder;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? bottomPadding;
  final Widget? prefixIcon;
  final Color? color;
  final String? errortext;
  const CustomFormField({
    Key? key,
    this.hintText,
    this.labelText,
    this.color,
    this.label,
    this.icon,
    this.errortext = "",
    this.border = 15,
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
  }) : super(key: key);
  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.border!),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    );

    final underlineBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding!,
      ),
      child: TextFormField(
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText ?? "",
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          labelText: widget.labelText ?? '',
          labelStyle: TextStyle(
            color: FocusNode().hasFocus
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          focusedBorder: focusBorder,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: widget.prefixIcon ??
              (widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: Colors.grey,
                    )
                  : null),
          enabledBorder: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                )
              : underlineBorder,
          border: widget.isOutlineBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                )
              : underlineBorder,
          suffixIcon: widget.isPasswordField!
              ? _buildPasswordFieldVisibilityToggle()
              : null,
        ),
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        obscureText: widget.isPasswordField! ? _obscureText : false,
        controller: widget.controller,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        onTap: () => widget.onTap,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
      ),
    );
  }

  Widget _buildPasswordFieldVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
