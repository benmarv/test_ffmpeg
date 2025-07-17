import 'package:flutter/material.dart';
import 'package:link_on/utils/utils.dart';

class CountTile extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback? onTap;

  const CountTile({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              Utils.formatNumber(value),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
