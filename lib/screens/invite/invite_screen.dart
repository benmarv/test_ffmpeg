import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:link_on/consts/colors.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriend extends StatelessWidget {
  const InviteFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 25,
            )),
        title: Text(
          translate(context, AppString.invite_a_friend).toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          child: ListView(
            padding: EdgeInsets.all(8),
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset('assets/anim/invite.json', repeat: true),
              Text(
                translate(context, AppString.invite_your_friends).toString(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.only(right: 35, top: 30, left: 25),
                child: Text(
                  translate(context, AppString.invite_friend_body_text)
                      .toString(),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const Text(
                '',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Share.share(
                      '${translate(context, AppString.invite_text).toString()} \n https://play.google.com/store/apps/details?id=com.socioon.linkon&hl=en&gl=US');
                },
                child: Container(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width * .6,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.primaryColor),
                    child: Center(
                        child: Text(
                      translate(context, AppString.invite).toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ))),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
