import 'package:link_on/screens/settings/widgets/settings_section.dart';
import 'package:flutter/material.dart';

class LanguageSubpage extends StatelessWidget {
  const LanguageSubpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child:const  Column(
        children:  <Widget>[
          SettingsSection(
            title: "App Language",
            children: <Widget>[
              SizedBox(height: 10.0),
              Text("English")
            ],
          )
        ],
      ),
    );
  }
}
