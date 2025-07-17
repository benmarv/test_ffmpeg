import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

Future showModelBottomSheet(
    {required context,
    required Widget widget,
    Color? colors,
    bool? isScroll,
    final double? initailSize}) {
  return showModalBottomSheet<void>(
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
    backgroundColor: colors ?? AppColors.primaryColor,
    builder: (BuildContext context) {
      return isScroll == true
          ? DraggableScrollableSheet(
              expand: false,
              initialChildSize: initailSize ?? 0.4,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder: (context, scrollController) => ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
                child: SingleChildScrollView(
                    controller: scrollController, child: widget),
              ),
            )
          : SingleChildScrollView(child: widget);
    },
  );
}
