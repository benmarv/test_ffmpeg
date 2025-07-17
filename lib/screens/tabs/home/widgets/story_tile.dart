import 'package:flutter/material.dart';
import 'package:link_on/components/circular_image.dart';
import 'package:link_on/consts/routes.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

class StoryTile extends StatelessWidget {
  final Usr? user;

  const StoryTile({
    Key? key,
    @required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<bool> status = [false, true, true];
    status.shuffle();
    bool currentStatus = status[0];

    final userImage = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          height: 65.0,
          width: 65.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircularImage(image: user!.avatar!),
        ),
        Visibility(
          visible: currentStatus,
          child: Positioned(
            bottom: 0.0,
            child: Container(
              height: 24.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    LineIcons.video,
                    color: Colors.white,
                    size: 15.0,
                  ),
                  Utils.horizontalSpacer(space: 5),
                  Text(
                    translate(context, 'live')!,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );

    final firstName = Text(
      user!.firstName!,
      style: Theme.of(context).textTheme.bodyLarge,
    );

    return MaterialButton(
      onPressed: () => Navigator.pushNamed(
        context,
        AppRoutes.storyView,
        arguments: user,
      ),
      child: Container(
        child: Column(
          children: [
            userImage,
            firstName,
          ],
        ),
      ),
    );
  }
}
