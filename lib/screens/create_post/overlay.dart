import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:overlay_support/overlay_support.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/tabs/tabs.page.dart';
import 'package:link_on/localization/localization_constant.dart';

ValueNotifier<double> progressValue = ValueNotifier<double>(0.0);
overlayDisplay(BuildContext context) {
  return showSimpleNotification(
    Builder(builder: (context) {
      return ValueListenableBuilder<double>(
        valueListenable: progressValue,
        builder: (context, value, child) {
          if (value == 100.0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              progressValue.value = 0.0;
              // toast("Post uploaded successfully");
              return OverlaySupportEntry.of(context)!.dismiss();
            });
          }

          return Center(
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey,
              color: AppColors.primaryColor,
              value: value / 100,
            ),
          );
        },
        child: const SizedBox.shrink(),
      );
    }),
    context: nb_utils.navigatorKey.currentContext,
    subtitle: ValueListenableBuilder<double>(
        valueListenable: progressValue,
        builder: (context, value, child) {
          return Text(
            "${translate(context, 'uploading_post').toString()}, $value%",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        }),
    trailing: Builder(builder: (context) {
      return TextButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              progressValue.value == 100 ? null : cancelToken.cancel();
              progressValue.value = 0.0;
              nb_utils.toast(translate(context, 'cancel').toString());
              return OverlaySupportEntry.of(context)!.dismiss();
            });
          },
          child: Text(translate(context, 'cancel').toString(),
              style: TextStyle(color: AppColors.primaryColor)));
    }),
    autoDismiss: false,
    slideDismissDirection: DismissDirection.none,
  );
}
