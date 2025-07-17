import 'package:intl/intl.dart';
import 'package:link_on/components/cached_image.dart';
import 'package:link_on/components/details_image.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/movies/movie_play.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:link_on/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final List<MessageModel>? messages;
  final int? index;

  const ChatBubble({Key? key, this.messages, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime currentMessageDateTime = DateTime.parse(messages![index!].time!);

    DateTime? nextMessageDateTime;
    if (index! < messages!.length - 1) {
      nextMessageDateTime = DateTime.parse(messages![index! + 1].time!);
    }

    // Check if the current message's date is different from the next message's date
    bool showDateDivider = nextMessageDateTime == null ||
        currentMessageDateTime.day != nextMessageDateTime.day ||
        currentMessageDateTime.month != nextMessageDateTime.month ||
        currentMessageDateTime.year != nextMessageDateTime.year;

    Widget dateDivider = showDateDivider
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              DateFormat('EEEE, MMM d, yyyy').format(currentMessageDateTime),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          )
        : const SizedBox.shrink();
    String formatTime(DateTime dateTime) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String hour = twoDigits(dateTime.hour);
      String minute = twoDigits(dateTime.minute);

      return '$hour:$minute';
    }

    return Column(
      children: [
        dateDivider,
        Align(
          alignment: messages![index!].fromId == getStringAsync("user_id")
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                messages![index!].fromId == getStringAsync("user_id")
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.5,
                ),
                decoration: BoxDecoration(
                  gradient:
                      messages![index!].fromId == getStringAsync("user_id")
                          ? const LinearGradient(colors: [
                              AppColors.scaffoldColorDark,
                              AppColors.scaffoldColorDark,
                            ])
                          : const LinearGradient(colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor,
                            ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: messages![index!].type == '0'
                    ? const EdgeInsets.all(15.0)
                    : const EdgeInsets.all(2.0),
                child: messages![index!].type == '1'
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                image: messages![index!].media,
                              ),
                            ),
                          );
                        },
                        child: CachedImage(url: messages![index!].media),
                      )
                    : messages![index!].type == '2'
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoviePlay(
                                    url: messages![index!].media!,
                                  ),
                                ),
                              );
                            },
                            child: CachedImage(
                              url: messages![index!].videoThumbail,
                              isVideo: true,
                            ),
                          )
                        : Text(
                            messages![index!].text!.trim().toString(),
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 2, left: 10),
                child: Text(
                  formatTime(currentMessageDateTime),
                  style: const TextStyle(
                    fontSize: 8.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
