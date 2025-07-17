import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:link_on/components/connectivity_screen/button.dart';
import 'package:link_on/components/header_text.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class Timeout extends StatefulWidget {
  const Timeout({super.key,required this.onPress});
  final void Function()? onPress;
  @override
  State<Timeout> createState() => _TimeoutState();
}

class _TimeoutState extends State<Timeout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset(
              "assets/images/timeout.json",
              repeat: true,
              reverse: true,
            ),
          ),
          const HeaderText(text: "Oops!"),
          20.sh,
          const Text(
            "Request Timeout",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
          ),
      
          20.sh,
          custonButton(context: context, onPressed: widget.onPress),
        
        ],
      ),
    );
  }
}
