import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/block_user_provider/block_user_provier.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/tabs/home/verified_user.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/screens/pages/explore_pages.dart';
import 'package:provider/provider.dart';

class BlockUsers extends StatefulWidget {
  const BlockUsers({super.key});

  @override
  State<BlockUsers> createState() => _BlockUsersState();
}

class _BlockUsersState extends State<BlockUsers> {
  @override
  void initState() {
    super.initState();
    Provider.of<BlockUserProvider>(context, listen: false)
        .getBlockUsers(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            translate(context, AppString.blocked_users).toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        body: Consumer<BlockUserProvider>(
          builder: (context, value, child) => value.check == true
              ? value.blockeduser.isNotEmpty
                  ? ListView.builder(
                      itemCount: value.blockeduser.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(value
                                                      .blockeduser[index].avatar
                                                      .toString()))),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              value.blockeduser[index].username
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            4.sw,
                                            value.blockeduser[index]
                                                        .isVerified ==
                                                    "1"
                                                ? verified()
                                                : const SizedBox.shrink()
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              backgroundColor:
                                                  AppColors.primaryColor),
                                          onPressed: () {
                                            showDialog<bool>(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text(
                                                    translate(context,
                                                        'unblock_confirmation')!,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        isDestructiveAction:
                                                            true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          value.blockUser(
                                                              index: index,
                                                              userid: value
                                                                  .blockeduser[
                                                                      index]
                                                                  .id);
                                                        },
                                                        child: Text(
                                                          translate(
                                                              context, 'yes')!,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )),
                                                    CupertinoDialogAction(
                                                        isDestructiveAction:
                                                            true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          translate(
                                                              context, 'no')!,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        )),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            translate(context, 'unblock')!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading(),
                        Text(
                          translate(context, AppString.no_members_to_show)
                              .toString(),
                        ),
                      ],
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Loader()],
                ),
        ));
  }
}
