import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/openai/chatbot/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/localization/localization_constant.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final int index;

  const MessageCard({super.key, required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(15);

    return message.msgType == MessageType.bot

        // bot message
        ? Column(
            children: [
              Row(children: [
                const SizedBox(width: 6),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(LineIcons.robot, color: AppColors.primaryColor),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .6),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).height * .02,
                      left: MediaQuery.sizeOf(context).width * .02),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * .01,
                      horizontal: MediaQuery.sizeOf(context).width * .02),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: const BorderRadius.only(
                          topLeft: r, topRight: r, bottomRight: r)),
                  child: Text(
                    message.msg,
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
              Consumer<ChatController>(builder: (context, value, child) {
                return value.isLoading && index == value.list.length - 1
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 6),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(LineIcons.robot,
                                color: AppColors.primaryColor),
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * .6),
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.sizeOf(context).height * .02,
                                left: MediaQuery.sizeOf(context).width * .02),
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.sizeOf(context).height * .01,
                                horizontal:
                                    MediaQuery.sizeOf(context).width * .02),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: const BorderRadius.only(
                                    topLeft: r, topRight: r, bottomRight: r)),
                            // child: Text( translate(context, 'please_wait')!,),
                            child: AnimatedTextKit(animatedTexts: [
                              TypewriterAnimatedText(
                                translate(context, 'please_wait')!,
                                speed: const Duration(milliseconds: 100),
                              ),
                            ], repeatForever: true),
                          ),
                        ],
                      )
                    : const SizedBox.shrink();
              })
            ],
          )

        // user message
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * .6),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.sizeOf(context).height * .02,
                    right: MediaQuery.sizeOf(context).width * .02),
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * .01,
                    horizontal: MediaQuery.sizeOf(context).width * .02),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: r, topRight: r, bottomLeft: r)),
                child: Text(
                  message.msg,
                  textAlign: TextAlign.center,
                )),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
            const SizedBox(width: 6),
          ]);
  }
}
