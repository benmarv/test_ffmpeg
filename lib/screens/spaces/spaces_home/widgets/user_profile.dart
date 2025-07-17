import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/usr.dart';
import 'package:link_on/screens/tabs/profile/report_user.dart';
import 'package:link_on/utils/Spaces/extensions/sizebox_extention.dart';
import 'package:link_on/viewModel/api_client.dart';

class UserProfile extends StatefulWidget {
  final String? id;
  const UserProfile({super.key, this.id});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    userdata();
  }

  bool data = false;
  Usr? usr;
  Future userdata() async {
    dynamic res = await apiClient.get_user_data(userId: widget.id);
    if (res["code"] == '200') {
      usr = Usr.fromJson(res["data"]);
      data = true;
      setState(() {});
    } else {
      data = true;
      toast('Error: user profile ${res['errors']['error_text']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return data
        ? Padding(
            padding: EdgeInsets.zero,
            child: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.antiAlias,
                children: [
                  Container(
                    height: 115,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(usr!.cover.toString()),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 75,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(usr!.avatar.toString()),
                                fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${usr!.firstName.toString()} ${usr!.lastName.toString()},",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                "@${usr!.username.toString()}",
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                usr!.aboutYou.toString(),
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              15.sh,
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             MessageDetailsPage(
                                  //               user: usr,
                                  //             )));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      color: Colors.grey.shade700,
                                    ),
                                    25.sw,
                                    Text(
                                      translate(
                                          context, 'send_direct_message')!,
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              14.sh,
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReportUser(user: widget.id)));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      color: Colors.grey.shade700,
                                    ),
                                    25.sw,
                                    Text(
                                      "${translate(context, 'report')} @${usr!.username.toString()}",
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              14.sh,
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            translate(
                                                context, 'block_user_title')!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            translate(
                                                context, 'block_user_message')!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                wordSpacing: 1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                translate(context, 'cancel')!,
                                                style: TextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                translate(context, 'block')!,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                // blockUser(
                                                //   widget.id ??
                                                //       getStringAsync("user_id"),
                                                // );
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.block,
                                      color: Colors.grey.shade700,
                                    ),
                                    25.sw,
                                    Text(
                                      "${translate(context, 'block')} @${usr!.username.toString()}",
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          )
        : Center(
            child: Column(
              children: [
                100.sh,
                const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          );
  }
}




// Future<void> blockUser(userid) async {
  //   Map<String, dynamic> dataArray = {
  //     "server_key": Constants.serverKey,
  //     "user_id": userid,
  //     "block_action": 'block',
  //   };
  //   dynamic res =
  //       await apiClient.callApi(apiPath: 'block-user', apiData: dataArray);
  //   if (res["api_status"] == 200) {
  //     toast("User Blocked");
  //   } else {
  //     toast('Error: block user ${res['errors']['error_text']}');
  //   }
  // }
