import 'package:flutter/material.dart';

class AddSpaceTextField extends StatelessWidget {
  final String hintText;
  final bool isReadOnly;
  final TextEditingController? controller;
  final int? maxLines;
  final bool? isEnabled;
  final IconButton? icon;
  final String? Function(String?)? validator;
  const AddSpaceTextField({
    super.key,
    required this.hintText,
    this.isEnabled,
    this.isReadOnly = false,
    this.maxLines,
    this.validator,
    this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      maxLines: maxLines,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        suffixIcon: icon,
      ),
    );
  }
}
