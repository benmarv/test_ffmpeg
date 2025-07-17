import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/screens/dating/swipe_stack.dart';
import 'package:link_on/models/usr.dart';
import 'package:nb_utils/nb_utils.dart';

class Info extends StatelessWidget {
  final Usr user;

  final GlobalKey<SwipeStackState>? swipeKey;
  Info(
    this.user,
    this.swipeKey,
  );

  @override
  Widget build(BuildContext context) {
    bool isMe = user.id == getStringAsync('user_id');
    bool isMatched = swipeKey == null;
    //  if()

    //matches.any((value) => value.id == user.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 500,
                    width: MediaQuery.sizeOf(context).width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return Hero(
                          tag: "abc",
                          child: CachedNetworkImage(
                            imageUrl: user.avatar!,
                            fit: BoxFit.cover,
                            useOldImageOnUrlChange: true,
                            placeholder: (context, url) =>
                                CupertinoActivityIndicator(
                              radius: 20,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        );
                      },
                      itemCount: 1,
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              activeSize: 13,
                              color: AppColors.secondaryColor,
                              activeColor: AppColors.primaryColor)),
                      control: new SwiperControl(
                        color: AppColors.primaryColor,
                        disableColor: AppColors.secondaryColor,
                      ),
                      loop: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text("${user.address}"),
                            title: Text(
                              "${user.firstName} ${user.lastName},",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: AppColors.primaryColor,
                                )),
                          ),
                          user.aboutYou != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.work,
                                      color: AppColors.primaryColor),
                                  title: Text(
                                    "${user.aboutYou}",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),

                          user.address != null
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(Icons.home,
                                      color: AppColors.primaryColor),
                                  title: Text(
                                    "${user.address}",
                                    style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          // !isMe
                          //     ? ListTile(
                          //         dense: true,
                          //         leading: Icon(
                          //           Icons.location_on,
                          //           color:  AppColors.primaryColor,
                          //         ),
                          //         title: Text(
                          //           "${user.editInfo!['DistanceVisible'] != null ? user.editInfo!['DistanceVisible'] ? 'Less than ${user.distanceBW} KM away' : 'Distance not visible' : 'Less than ${user.distanceBW} KM away'}",
                          //           style: TextStyle(
                          //               color:  AppColors.secondaryColor,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500),
                          //         ),
                          //       )
                          //     : Container(),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // user.editInfo!['about'] != null
                  //     ? Text(
                  //         "${user.editInfo!['about']}",
                  //         style: TextStyle(
                  //             color: AppColors.secondaryColor,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500),
                  //       )
                  //     : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  // user.editInfo!['about'] != null ? Divider() : Container(),
                  // !isMe
                  //     ? InkWell(
                  // onTap: () => showDialog(
                  //     barrierDismissible: true,
                  //     context: context,
                  //     builder: (context) => ReportUser(
                  //           currentUser: currentUser,
                  //           seconduser: user,
                  //         )),
                  //     child: Container(
                  //         width: MediaQuery.sizeOf(context).width,
                  //         child: Center(
                  //           child: Text(
                  //             "REPORT ${user.name}".toUpperCase(),
                  //             textAlign: TextAlign.center,
                  //             style: TextStyle(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: AppColors.secondaryColor),
                  //           ),
                  //         )),
                  //   )
                  // : Container(),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            !isMatched
                ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey!.currentState!.swipeLeft();
                              }),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey!.currentState!.swipeRight();
                              }),
                        ],
                      ),
                    ),
                  )
                : isMe
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {},
                              // onPressed: () => Navigator.pushReplacement(
                              //     context,
                              //     CupertinoPageRoute(
                              //         builder: (context) =>
                              //             EditProfile(user)))
                            )),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.message,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {},
                              // onPressed: () => Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(
                              //         builder: (context) => ChatPage(
                              //               sender: currentUser,
                              //               second: user,
                              //               chatId: chatId(user, currentUser),
                              //             )))
                            )),
                      )
          ],
        ),
      ),
    );
  }
}
