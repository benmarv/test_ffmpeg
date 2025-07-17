import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';

class CreatRoom extends StatelessWidget {
  final void Function()? onPresses;
  const CreatRoom({super.key, this.onPresses});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPresses,
      child: PhysicalModel(
        elevation: 0.5,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0.1, 0.5),
                      color: Colors.grey.shade300)
                ]),
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5.0),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.add_circled,
                  color: Colors.white,
                  size: 20,
                ),
                4.sw,
                const Text(
                  "Space",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )),
      ),
    );
  }
}
