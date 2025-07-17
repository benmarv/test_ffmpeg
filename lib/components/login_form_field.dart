import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginFormField extends StatefulWidget {
  const LoginFormField({
    super.key,
    required this.controller,
    this.isPasswordField = false,
    this.isEnabled = true,
    this.validator,
    this.hintText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? isPasswordField;
  final bool? isEnabled;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? suffixIcon;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  bool _obscureText = true;
  Widget _buildPasswordFieldVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? LineIcons.eye_slash : LineIcons.eye,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: 1,
      enabled: widget.isEnabled,
      validator: ((value) => widget.validator!(value!)),
      keyboardType: widget.keyboardType,
      obscureText: widget.isPasswordField! ? _obscureText : false,
      decoration: InputDecoration(
        suffixIcon: widget.isPasswordField!
            ? _buildPasswordFieldVisibilityToggle()
            : widget.suffixIcon != null
                ? widget.suffixIcon
                : null,
        hintText: widget.hintText ?? "",
        hintStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
