import 'package:flutter/cupertino.dart';
import 'package:link_on/screens/real_estate/theme/color.dart';

class DataNotFound extends StatelessWidget {
  final bool? flag;
  final String? text;
  final void Function()? onTap;

  // Constructor for DataNotFound widget
  DataNotFound({this.flag, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(
            //   height: 70,
            //   image: AssetImage(
            //     pro.isDark ? icLogo : icLogolight,
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Text(
              'Data Not Found...!',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            // Conditionally display a CupertinoButton if 'flag' is true
            if (flag == true) ...[
              CupertinoButton(
                color: AppColor.primary,
                child: Text(
                  text ?? "",
                  style: TextStyle(),
                ),
                onPressed: onTap,
              )
            ],
          ],
        ),
      ),
    );
  }
}
