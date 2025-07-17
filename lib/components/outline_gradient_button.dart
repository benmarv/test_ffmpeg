import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';

class OutlineGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const OutlineGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _GradientPainter painter = _GradientPainter(
      strokeWidth: 1,
      radius: 10.0,
      gradient: const LinearGradient(
        colors: [AppColors.primaryColor, AppColors.primaryColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );

    return CustomPaint(
      painter: painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          constraints: const BoxConstraints(minWidth: 88, minHeight: 35),
          child: Padding(
            padding: padding,
            child: Center(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    _paint.shader = gradient.createShader(outerRect);
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
