import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String image;
  final double size;

  const CircularImage({
    Key? key,
    required this.image,
    this.size = 60.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CircularImageNetwork extends StatelessWidget {
  final String image;
  final double size;

  const CircularImageNetwork({
    Key? key,
    required this.image,
    this.size = 60.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      elevation: 1,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade500,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade400,
          ),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
