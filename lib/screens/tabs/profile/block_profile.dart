import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';

class BlockProfile extends StatelessWidget {
  const BlockProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translate(context, 'cannot_access_profile')!,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                translate(context, 'go_back')!,
              ),
            )
          ],
        ),
      ),
    );
  }
}
