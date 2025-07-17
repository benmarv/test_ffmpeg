import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/models/usr.dart';

// Initialize a ValueNotifier to hold the user data by decoding a JSON string from storage
ValueNotifier<Usr> getUserData = ValueNotifier(
  Usr.fromJson(
    jsonDecode(
      getStringAsync("userData"),
    ),
  ),
);
