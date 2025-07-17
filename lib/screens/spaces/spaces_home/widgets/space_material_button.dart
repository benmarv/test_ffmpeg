import 'package:flutter/material.dart';

class SpaceMaterialButton extends StatelessWidget {
  final void Function()? onPress;
  final Widget child;
  final double? width;
  final double? height;

  const SpaceMaterialButton({
    super.key,
    required this.onPress,
    required this.child,
    this.width = 130,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(100, height!),
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
      ),
      onPressed: onPress,
      child: child,
    );
  }
}
