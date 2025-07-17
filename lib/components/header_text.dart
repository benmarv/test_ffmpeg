import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String? text;
  final bool isBig;
  final double? fontSize;
  final TextAlign? textAlign;

  const HeaderText({
    Key? key,
    required this.text,
    this.isBig = true,
    this.fontSize,
    this.textAlign,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final fontSize = this.fontSize ?? (isBig ? 20.0 : 15.0);
    final fontWeight = isBig ? FontWeight.w900 : FontWeight.w600;
    final color = isBig
        ? Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.7)
        : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8);

    return Text(
      text.toString(),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}
