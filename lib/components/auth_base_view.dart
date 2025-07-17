import 'package:flutter/material.dart';

class AuthBaseView extends StatelessWidget {
  final Widget body;

  const AuthBaseView({
    Key? key,
    required this.body,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: body,
      ),
    );
  }
}
