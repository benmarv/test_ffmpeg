// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Utils {
  static Widget verticalSpacer({double space = 20.0}) {
    return SizedBox(height: space);
  }

  static Widget horizontalSpacer({double space = 20.0}) {
    return SizedBox(width: space);
  }

  static String formatNumber(int value) {
    return NumberFormat.compact().format(value);
  }

  static String formatTimestamp(String apiTimestamp,
      {bool? isWithTime = false}) {
    String formattedTime;

    DateTime utcTime = DateTime.parse(apiTimestamp);
    DateTime localTime = utcTime.toLocal();
    if (isWithTime == true) {
      formattedTime = DateFormat('EEEE, dd - yyyy').format(localTime);
    } else {
      formattedTime = DateFormat('yyyy-MM-dd').format(localTime);
    }

    return formattedTime;
  }

  // static String? validateEmail(String value) {
  //   Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  //   RegExp regex = RegExp(pattern as String);
  //   if (!regex.hasMatch(value)) {
  //     return '🚩 Please enter a valid email address.';
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validateDropDefaultData(value) {
  //   if (value == null) {
  //     return 'Please select an item.';
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validatePassword(String value) {
  //   Pattern pattern = r'^.{6,}$';
  //   RegExp regex = RegExp(pattern as String);
  //   if (!regex.hasMatch(value)) {
  //     return '🚩 Password must be at least 6 characters.';
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validateName(String value) {
  //   if (value.length < 3) {
  //     return '🚩 Username is too short.';
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validateText(String value) {
  //   if (value.isEmpty) {
  //     return '🚩 Text is too short.';
  //   } else {
  //     return null;
  //   }
  // }

  // static String? validatePhoneNumber(String value) {
  //   if (value.length != 11) {
  //     return '🚩 Phone number is not valid.';
  //   } else {
  //     return null;
  //   }
  // }

  static Widget serchWaiting() {
    return Center(
      child: Lottie.asset(
        "assets/anim/serch_waiting.json",
        repeat: true,
        reverse: true,
        width: 130,
      ),
    );
  }

  static Widget live(width) {
    return Center(
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.modulate),
        child: Lottie.asset(
          "assets/anim/live.json",
          repeat: true,
          reverse: true,
          width: width,
        ),
      ),
    );
  }
}
