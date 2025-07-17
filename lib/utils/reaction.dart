import 'package:flutter/material.dart';

class SetValuesReactions {
  static checkTypeReaction(type) {
    String path = "";
    if (type == '1') {
      path = "assets/fbImages/ic_like_fill.png";
    } else if (type == '2') {
      path = "assets/fbImages/love2.png";
    } else if (type == '3') {
      path = "assets/fbImages/haha2.png";
    } else if (type == '4') {
      path = "assets/fbImages/wow2.png";
    } else if (type == '5') {
      path = "assets/fbImages/sad2.png";
    } else if (type == '6') {
      path = "assets/fbImages/angry2.png";
    } else {
      path = "assets/fbImages/ic_like.png";
    }
    return path;
  }

  static checkTypeText(type) {
    String text = "";
    if (type == '1') {
      text = "Liked";
    } else if (type == '2') {
      text = "Love";
    } else if (type == '3') {
      text = "Haha";
    } else if (type == '4') {
      text = "Wow";
    } else if (type == '5') {
      text = "Sad";
    } else if (type == '6') {
      text = "Angry";
    } else {
      text = "Like";
    }
    return text;
  }

  static checkTypeColor(type) {
    Color? textColor;
    if (type == '1') {
      textColor = const Color(0xff037aff);
    } else if (type == '2') {
      textColor = const Color(0xffED5167);
    } else if (type == '3') {
      textColor = const Color(0xffFFD96A);
    } else if (type == '4') {
      textColor = const Color(0xffFFD96A);
    } else if (type == '5') {
      textColor = const Color(0xffFFD96A);
    } else if (type == '6') {
      textColor = const Color(0xffF6876B);
    } else {
      textColor = Colors.black87;
    }
    return textColor;
  }
}
