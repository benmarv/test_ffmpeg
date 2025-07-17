import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool? isGradient;
  final bool? wrap;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isGradient = true,
    this.wrap = false,
  });
  @override
  Widget build(BuildContext context) {
    const double btnSize = 50.0;

    final btnText = Text(
      text!.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor ?? Colors.white,
      ),
    );

    final materialBtn = MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: btnSize,
      color: color ?? Theme.of(context).primaryColor,
      elevation: 4.0,
      onPressed: onPressed,
      child: Center(
        child: btnText,
      ),
    );

    final gradientBtn = SizedBox(
      height: wrap! ? null : btnSize,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.0),
          ),
          padding: const EdgeInsets.all(0.0),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            constraints: wrap!
                ? const BoxConstraints(
                    minHeight: 35,
                  )
                : const BoxConstraints(
                    minHeight: 50.0,
                  ),
            alignment: Alignment.center,
            child: btnText,
          ),
        ),
      ),
    );

    return isGradient! ? gradientBtn : materialBtn;
  }
}
