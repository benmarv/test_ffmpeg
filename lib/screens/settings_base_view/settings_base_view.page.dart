import 'package:flutter/material.dart';
import 'package:link_on/models/settings_base_view.dart';

class SettingsBaseViewPage extends StatelessWidget {
  final SettingsBaseView baseView;

  const SettingsBaseViewPage({
    Key? key,
    required this.baseView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Text(
          baseView.title!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevation: 1,
      ),
      body: baseView.body,
    );
  }
}
