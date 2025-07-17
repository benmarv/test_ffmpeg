import 'package:flutter/material.dart';
import 'package:link_on/components/switcher_tile.dart';

class DataSaverSubpage extends StatefulWidget {
  const DataSaverSubpage({super.key});

  @override
  _DataSaverSubpageState createState() => _DataSaverSubpageState();
}

class _DataSaverSubpageState extends State<DataSaverSubpage> {
  bool dataSaver = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Column(
        children: <Widget>[
          SwitcherTile(
            title: "Data Saver",
            subtitle:
                "Data saver will reduce your cellular data usage. Videos may be at a lower resolution or take longer to load. This won't apply when you are on Wi-Fi.",
            value: dataSaver,
            onChanged: (bool value) {
              setState(() {
                dataSaver = !dataSaver;
              });
            },
          ),
        ],
      ),
    );
  }
}
