import 'package:flutter/material.dart';
import 'package:link_on/screens/settings/widgets/settings_section.dart';

class ContentPrefSubPage extends StatelessWidget {
  const ContentPrefSubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child:const Column(
        children:  [
          SettingsSection(
            title: "Video Languages",
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Add Language",
                  style: TextStyle(fontSize: 14.0),
                ),
                subtitle: Text(
                  "Your language preference will help us customize your viewing experience",
                  style: TextStyle(fontSize: 13.0),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
