import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';

class CustomShare extends StatefulWidget {
  final Posts? post;
  const CustomShare({super.key, this.post});
  @override
  State<CustomShare> createState() => _CustomShareState();
}

class _CustomShareState extends State<CustomShare> {
  Usr getUsrData = Usr();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsrData = Usr.fromJson(jsonDecode(getStringAsync("userData")));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.sh,
          bottomSheetTopDivider(color: AppColors.primaryColor),
          20.sh,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              translate(context, 'share_on_timeline')!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          10.sh,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            color: Theme.of(context).colorScheme.surface,
            width: size.width,
            child: Column(
              children: [
                _header(user: getUsrData),
                20.sh,
                _textField(
                    callback: () {
                      if (_controller.text.isEmpty) {
                        toast(translate(context, 'write_something'));
                      } else {
                        context.read<PostProvider>().sharePostonTimeLine(
                            context: context,
                            post: widget.post!,
                            text: _controller.text);
                      }
                    },
                    controller: _controller,
                    context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_header({required Usr user}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.primaryColor,
        backgroundImage: NetworkImage(user.avatar!),
      ),
      10.sw,
      Text(
        user.username.toString(),
        style: const TextStyle(fontWeight: FontWeight.w700),
      )
    ],
  );
}

_textField(
    {required void Function()? callback,
    TextEditingController? controller,
    context}) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
          child: TextField(
            cursorColor: AppColors.primaryColor,
            controller: controller,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: translate(context, 'write_something'),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
              )),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: MaterialButton(
            shape: const StadiumBorder(),
            color: AppColors.primaryColor,
            onPressed: callback,
            child: Text(
              translate(context, 'share_now')!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}
