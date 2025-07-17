import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:link_on/screens/reactionlist/reaction_list_controller.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:provider/provider.dart';

class WowReaction extends StatefulWidget {
  const WowReaction({super.key});

  @override
  State<WowReaction> createState() => _WowReactionState();
}

class _WowReactionState extends State<WowReaction> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReactionListController>(
      builder: ((context, value, child) => value.isdata == false &&
              value.reactionlist4.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : value.isdata != false && value.reactionlist4.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loading(),
                      Text(
                        translate(context, 'no_data_found')!,
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    itemCount: value.reactionlist4.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: PhysicalModel(
                          color: Colors.white,
                          elevation: 1,
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage: NetworkImage(
                                value.reactionlist4[index].avatar!,
                              ),
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              value.reactionlist4[index].username.toString(),
                              style: const TextStyle(fontSize: 15),
                            ),
                            4.sw,
                            value.reactionlist4[index].isVerified == "1"
                                ? verified()
                                : const SizedBox.shrink(),
                          ],
                        ),
                      );
                    },
                  ),
                )),
    );
  }
}
