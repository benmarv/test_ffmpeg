import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'button.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key, this.onPress});
  final void Function()? onPress;

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              "assets/images/no internet.json",
              repeat: true,
              reverse: true,
            ),
          ),
          const HeaderText(text: "Oops!"),
          20.sh,
          Text(
            translate(context, "check_internet_connection").toString(),
          ),
          20.sh,
          custonButton(onPressed: widget.onPress, context: context),
        ],
      ),
    );
  }
}
