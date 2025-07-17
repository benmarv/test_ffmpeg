import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/posts.dart';
import 'package:link_on/screens/tabs/profile/profile.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/utils/Spaces/sheet_top.dart';


class PostTaggedPeoples extends StatelessWidget {
  const PostTaggedPeoples({super.key, required this.taggedUsers});
  final List<User> taggedUsers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.sh,
        bottomSheetTopDivider(color: AppColors.primaryColor),
        10.sh,
        Expanded(
          child: ListView.builder(
            itemCount: taggedUsers.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileTab(
                          userId: taggedUsers[index].id,
                        ),
                      ));
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(taggedUsers[index].avatar!)),
                title: Text(
                    "${taggedUsers[index].firstName} ${taggedUsers[index].lastName}"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              );
            },
          ),
        ),
      ],
    );
  }
}
