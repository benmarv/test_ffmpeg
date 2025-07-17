import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class LoaderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
