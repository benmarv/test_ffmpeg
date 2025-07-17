import 'package:flutter/material.dart';
import 'package:link_on/components/spaces_widgets/custom_button.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/text_widget.dart';

class CustomEventTile extends StatelessWidget {
  const CustomEventTile({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: textWidget(title: "6:00 pm", color: Colors.white)),
                CustomButton(
                  title: "Edit",
                  width: 50,
                  onpress: () {},
                ),
              ],
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const SizedBox(
                  child: CircleAvatar(
                radius: 20,
              )),
              title: textWidget(title: "Abdul Wahab", color: Colors.white),
            ),
            2.sh,
            textWidget(
                title: "Title",
                color: Colors.white,
                fontWeight: FontWeight.w600),
            2.sh,
            PhysicalModel(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: size.width,
                // height: 60,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: textWidget(title: "My firs event is comming"),
                ),
              ),
            ),
            4.sh,
            textWidget(
                title: "Discription",
                color: Colors.white,
                fontWeight: FontWeight.w600),
            2.sh,
            PhysicalModel(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: size.width,
                // height: 60,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: textWidget(
                      title:
                          "Stay tune with me.Good luck,Stay tune with me.Good luck,Stay tune with me.Good luck"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
