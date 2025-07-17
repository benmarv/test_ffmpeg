import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/controllers/PageProvider/delet_page.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:provider/provider.dart';

deletDialouge({context, id, title}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Provider.of<DeletePageProvider>(context, listen: false)
                  .deletPage(pageId: id, context: context);
            },
            isDefaultAction: true,
            child: Text(
              translate(context, 'delete')
                  .toString(), // Translated text for "Delete"
              style: const TextStyle(color: Colors.red),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              translate(context, 'go_back')
                  .toString(), // Translated text for "Go back"
            ),
          )
        ],
      );
    },
  );
}
