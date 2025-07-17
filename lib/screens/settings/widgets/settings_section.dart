import 'package:flutter/material.dart';
import 'package:link_on/screens/settings/widgets/header.dart';

class SettingsSection extends StatelessWidget {
  final String? title;
  final List<Widget>? children;


  const SettingsSection({
    Key? key,
    this.title,
    this.children,
   
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            text: title!,
          ),
          Column(
            children: children!,
          ),
        ],
      ),
    );
  }
}
