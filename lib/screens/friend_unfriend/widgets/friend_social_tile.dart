import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';

class FriendSocialTile extends StatelessWidget {
  final IconData? icon;
  final String? name;
  final Color? backgroundColor;

  const FriendSocialTile({
    Key? key,
    this.icon,
    this.name,
    this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final icon = Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(
        this.icon,
        color: backgroundColor,
      ),
    );
    final name = Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Text(
        this.name.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    final connect = Container(
        child: Text(
      translate(context, 'connect')!,
      style: const TextStyle(color: Colors.white54),
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 10.0, bottom: 5),
      child: MaterialButton(
        minWidth: MediaQuery.sizeOf(context).width * 0.4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: () {},
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            name,
            connect,
          ],
        ),
      ),
    );
  }
}
