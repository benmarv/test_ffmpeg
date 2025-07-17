import 'package:flutter/material.dart';

textWidget({color, required title, textAlign,fontsize,fontWeight}) {
  return Text(
    title,
    textAlign: textAlign ?? TextAlign.start,
    style: TextStyle(
      fontSize: fontsize,
      fontWeight: fontWeight,
        overflow: TextOverflow.clip,
         color: color ?? Colors.black),
  );
}
