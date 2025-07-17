import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const IconTile({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: listTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  listTile({
    required Widget leading,
    required Widget title,
  }) {
    return ListTile(
      leading: leading,
      title: title,
    );
  }
}
