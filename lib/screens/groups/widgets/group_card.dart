import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/models/join_group_model.dart';
import 'package:link_on/screens/groups/group_details.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, this.joinGroupModel, this.index, this.flag});
  final JoinGroupModel? joinGroupModel;
  final int? index;
  final bool? flag;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsGroup(
                        joinGroupModel: joinGroupModel,
                        index: index,
                      )));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: MediaQuery.sizeOf(context).width * .20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image:
                        NetworkImage(joinGroupModel!.cover.toString().trim()),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .55,
                  child: Text(
                    joinGroupModel!.groupTitle.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 11,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${joinGroupModel?.membersCount} ${translate(context, 'members')}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                if (joinGroupModel!.category != " " &&
                    joinGroupModel!.category != "")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: Icon(
                          Icons.local_offer,
                          size: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .55,
                        child: Text(
                          joinGroupModel!.category.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
