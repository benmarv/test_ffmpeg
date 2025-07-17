import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class SimpleCustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;

  //onButtonClick 0=Negative, 1=Positive
  final Function onButtonClick;

  SimpleCustomDialog({
    required this.title,
    required this.message,
    required this.negativeText,
    required this.positiveText,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
 
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Center(
              child: Container(
                height: 300,
                width: 275,
                decoration: BoxDecoration(
                  color: Colors.white ,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                    
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Image(
                    //   image: AssetImage(
                    //     pro.isDark ? icLogo : icLogolight,
                    //   ),
                    //   height: 80,
                    // ),
                    Expanded(
                      child: Center(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                          
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              onTap: () {
                                onButtonClick(0);
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  negativeText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              onTap: () {
                                onButtonClick(1);
                              },
                              child: Center(
                                child: Text(
                                  positiveText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    
                                    decoration: TextDecoration.none,
                                    color:AppColors.primaryColor
                                       ,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
