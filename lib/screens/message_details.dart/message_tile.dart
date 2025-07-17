import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/chats_provider/get_all_chats.dart';
import 'package:link_on/screens/ChatsScreens/all_user.dart';
import 'package:link_on/screens/message_details.dart/messaging_with_agora.dart';
import 'package:link_on/screens/pages/explore_pages.dart';

class MessagTile extends StatefulWidget {
  const MessagTile({super.key});

  @override
  State<MessagTile> createState() => _MessagTileState();
}

class _MessagTileState extends State<MessagTile> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<GetAllChatProvider>(context, listen: false);
    pro.getAllChat();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          pro.isLoading == false) {
        pro.getAllChat(
          offset: pro.chatList.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllUser(),
              ));
        },
      ),
      body: Consumer<GetAllChatProvider>(builder: (context, value, child) {
        return value.isLoading == true && value.chatList.isEmpty
            ? Center(
                child: Loader(),
              )
            : value.isLoading == false && value.chatList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Text(
                        translate(context, 'your_chat_list_is_empty')!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                        color: AppColors.primaryColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllUser(),
                              ));
                        },
                        child: Text(
                          translate(context, 'start_new_chat')!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: value.chatList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgoraMessaging(
                                    userId: value.chatList[index].id,
                                    userAvatar: value.chatList[index].avatar,
                                    userFirstName:
                                        value.chatList[index].firstName,
                                    userLastName:
                                        value.chatList[index].lastName,
                                  ),
                                ),
                              );
                            },
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              image:
                                                  value.chatList[index].avatar,
                                            )));
                              },
                              child: CircularImage(
                                image: value.chatList[index].avatar.toString(),
                                size: 60.0,
                              ),
                            ),
                            title: Text(
                              "${value.chatList[index].firstName} ${value.chatList[index].lastName}",
                            ),
                            subtitle:
                                Text('${value.chatList[index].lastMessage}'),
                            trailing: value.chatList[index].isMessageSeen == '0'
                                ? Icon(
                                    Icons.circle,
                                    color: AppColors.primaryColor,
                                    size: 12,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  );
      }),
    );
  }
}
