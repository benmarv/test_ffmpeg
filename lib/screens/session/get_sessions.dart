// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/app_string.dart';
import 'package:link_on/controllers/session_provider/sessionprovider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/routes.dart';

class SessionList extends StatefulWidget {
  const SessionList({super.key});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SessionProvider>(context, listen: false).makeListEmpty();
    Provider.of<SessionProvider>(context, listen: false)
        .sessionlist(context: context);
  }

  logOutCurrentSession() async {
    await removeKey("access_token");
    await removeKey("userData");
    await removeKey('access_token');

    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: Text(
            translate(context, AppString.manage_sessions).toString(),
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Consumer<SessionProvider>(builder: (context, value, child) {
          return value.isdata
              ? ListView.builder(
                  itemCount: value.sessionList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                ),
                                child: Center(
                                    child: Text(
                                  value.sessionList[index].deviceType
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                )),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        translate(
                                                context, AppString.device_model)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.22,
                                        child: Text(
                                          "${value.sessionList[index].deviceModel}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        translate(context, AppString.location)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "${value.sessionList[index].ipAddress}"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate(
                                                context, AppString.last_active)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                .22,
                                        child: Text(
                                          value.sessionList[index].createdAt!
                                              .timeAgo,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              (value.sessionList[index].token !=
                                      getStringAsync('access_token'))
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: Text(
                                                  translate(
                                                          context,
                                                          AppString
                                                              .link_on_social)
                                                      .toString(),
                                                ),
                                                content: Text(
                                                  translate(
                                                          context,
                                                          AppString
                                                              .logout_message)
                                                      .toString(),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      translate(context,
                                                              AppString.cancel)
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      translate(context,
                                                              AppString.log_out)
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      if (value
                                                              .sessionList[
                                                                  index]
                                                              .token ==
                                                          getStringAsync(
                                                              'access_token')) {
                                                        logOutCurrentSession();
                                                      }
                                                      Provider.of<SessionProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteSession(value
                                                              .sessionList[
                                                                  index]
                                                              .id);

                                                      Provider.of<SessionProvider>(
                                                              context,
                                                              listen: false)
                                                          .removeSession(index);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.delete,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        translate(context, AppString.you)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                            ],
                          )),
                          const Divider(
                            color: Colors.black26,
                          )
                        ],
                      ),
                    );
                  })
              : const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
        }));
  }
}
