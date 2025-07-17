import 'package:flutter/material.dart';

bottomSheetTopDivider({Color? color}) {
return  Center(
  child:   Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
          color:color?? Colors.white, borderRadius: BorderRadius.circular(5)),
    ),
);
}
