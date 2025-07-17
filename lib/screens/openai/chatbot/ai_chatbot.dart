import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/openai/chatbot/chat_controller.dart';
import 'package:link_on/screens/openai/chatbot/message_card.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AiChatBot extends StatefulWidget {
  const AiChatBot({super.key});

  @override
  State<AiChatBot> createState() => _AiChatBotState();
}

class _AiChatBotState extends State<AiChatBot> {
  final TextEditingController textC = TextEditingController();

  @override
  void dispose() {
    textC.dispose();
    Provider.of<ChatController>(context, listen: false)
        .disposeScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, _c, child) => Scaffold(
        //app bar
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                height: 20,
                width: 100,
                child: Image(
                  image: NetworkImage(
                    getStringAsync("appLogo"),
                  ),
                ),
              ),
              Text(
                translate(context, "chatbot")!,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        //send message field & btn
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              //text input field
              Expanded(
                  child: TextFormField(
                controller: textC,
                onTapOutside: (e) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                    suffixIcon: _c.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: () {
                              _c.askQuestion(textC: textC.text);
                              textC.clear();
                            },
                            icon: const Icon(Icons.send,
                                color: AppColors.primaryColor, size: 28),
                          ),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    isDense: true,
                    hintText: translate(context, 'ask_me_anything'),
                    hintStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
              )),
            ],
          ),
        ),

        //body
        body: ListView.builder(
          itemBuilder: (context, index) {
            return MessageCard(
              message: _c.list[index],
              index: index,
            );
          },
          itemCount: _c.list.length,
          physics: const BouncingScrollPhysics(),
          controller: _c.scrollC,
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * .02,
              bottom: MediaQuery.sizeOf(context).height * .1),
        ),
      ),
    );
  }
}
