
import 'package:flutter/material.dart';
import 'package:link_on/utils/utils.dart';

class IconBtn extends StatelessWidget {
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final int? value;
  final VoidCallback? onTap;
  final Color? color;

  const IconBtn({
    Key? key,
    this.leadingIcon,
    this.trailingIcon,
    required this.value,
    this.onTap,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Visibility(
            visible: leadingIcon != null,
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                leadingIcon,
                color: color,
              ),
            ),
          ),
          Text(
            Utils.formatNumber(value!),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          Visibility(
            visible: trailingIcon != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(
                trailingIcon,
                color: color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
