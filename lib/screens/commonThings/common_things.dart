import 'package:flutter/material.dart';
import 'package:link_on/screens/commonThings/friend_with_common_thing.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonThings extends StatelessWidget {
  const CommonThings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        title: Container(
          height: 20,
          width: 100,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(getStringAsync("appLogo")))),
        ),
      ),
      body: CommonThingFriends(),
    );
  }
}
