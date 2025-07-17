import 'package:flutter/material.dart';
import 'package:link_on/screens/openai/openai_apis.dart';
import 'package:nb_utils/nb_utils.dart';

class Message {
  String msg;
  final MessageType msgType;

  Message({required this.msg, required this.msgType});
}

enum MessageType { user, bot }

class ChatController extends ChangeNotifier {
  final scrollC = ScrollController();

  void disposeScrollController() {
    scrollC.dispose();
    notifyListeners();
  }

  bool isLoading = false;
  List<Message> list = <Message>[
    Message(msg: 'Hello, How can I help you?', msgType: MessageType.bot)
  ];

  Future<void> askQuestion({required String textC}) async {
    if (textC.trim().isNotEmpty) {
      isLoading = true;
      notifyListeners();
      //user
      list.add(Message(msg: textC, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      _scrollDown();

      final res = await APIs.getAnswer(question: textC);

      //ai bot
      list.removeLast();
      list.add(Message(msg: res, msgType: MessageType.bot));
      _scrollDown();

      textC = '';
    } else {
      toast('Ask Something!');
    }
    isLoading = false;

    notifyListeners();
  }

  String aiPostText = '';
  Future<String> createAiTextPost(
      {required String textC, required BuildContext context}) async {
    if (textC.trim().isNotEmpty) {
      isLoading = true;
      notifyListeners();

      final aiPostText = await APIs.getAnswer(question: textC);
      Navigator.pop(context);
      isLoading = false;
      notifyListeners();
      return aiPostText;
    } else {
      toast('Ask Something!');
    }
    isLoading = false;
    notifyListeners();
    return aiPostText;
  }

  //for moving to end message
  void _scrollDown() {
    scrollC.animateTo(scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
