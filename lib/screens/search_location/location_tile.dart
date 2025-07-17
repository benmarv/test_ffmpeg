import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final VoidCallback press;
  final String title;
  const LocationTile({
    super.key,
    required this.press,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: const Icon(Icons.location_pin),
      title: Text(title),
    );
  }
}
