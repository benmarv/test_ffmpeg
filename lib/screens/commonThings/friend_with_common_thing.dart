import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/consts/text_constants.dart';
import 'package:link_on/controllers/common_things_provider/common_things_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/commonThings/common_thing_freind_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CommonThingFriends extends StatefulWidget {
  const CommonThingFriends({super.key});

  @override
  State<CommonThingFriends> createState() => _CommonThingFriendsState();
}

class _CommonThingFriendsState extends State<CommonThingFriends> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    final provider = Provider.of<CommonThingsProvider>(context, listen: false);

    provider.commonUsers.clear();
    provider.fetchCommonUsers(userId: getStringAsync("user_id"));
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          provider.isCommonUserLoading == false) {
        provider.fetchCommonUsers(
            userId: getStringAsync("user_id"),
            offset: provider.commonUsers.length);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(context, "common_things").toString(),
                    style: text4b,
                  ),
                  Text(translate(context, "meet_people_with").toString(),
                      style: text2),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<CommonThingsProvider>(
                builder: (context, provider, child) {
                  final commonUsers = provider.commonUsers;
                  if (provider.isCommonUserLoading == true) {
                    return Center(child: CircularProgressIndicator());
                  } else if (provider.commonUsers.isEmpty &&
                      provider.isCommonUserLoading == false) {
                    return Center(
                      child: Text("No data found."),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: commonUsers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.transparent,
                                            offset: Offset(2, 2),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: commonUsers[index].avatar,
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      commonUsers[index].firstName,
                                      style: text2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommonThingFrinedView(
                                  user: commonUsers[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
