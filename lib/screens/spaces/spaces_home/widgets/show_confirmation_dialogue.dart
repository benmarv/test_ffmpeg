import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String yesText,
  required String noText,
  required VoidCallback onYes,
  required VoidCallback onNo,
}) async {
  await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
            onPressed: onYes,
            child: Text(
              yesText,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: onNo,
            child: Text(
              noText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
  );
}
