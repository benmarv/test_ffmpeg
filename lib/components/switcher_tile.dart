import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class SwitcherTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitcherTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15.0),
            ),
          ),
          Switch.adaptive(
            activeColor: AppColors.primaryColor,
            value: value,
            onChanged: onChanged,
          )
        ],
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 13.0),
            )
          : null,
    );
  }
}
