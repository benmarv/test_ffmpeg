import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

customDialogueLoader({context}) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Center(
              child: Loader(),
            ),
          );
        });
  }
