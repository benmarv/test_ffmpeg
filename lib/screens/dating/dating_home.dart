import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/dating/swipe_stack.dart';
import 'package:link_on/screens/dating/user_detail.dart';
import 'package:link_on/models/usr.dart';

List userRemoved = [];
int countswipe = 1;

class CardPictures extends StatefulWidget {
  final List<Usr> users;
  final Usr currentUser;
  final int swipedcount;

  CardPictures(
    this.currentUser,
    this.users,
    this.swipedcount,
  );

  @override
  _CardPicturesState createState() => _CardPicturesState();
}

class _CardPicturesState extends State<CardPictures>
    with AutomaticKeepAliveClientMixin<CardPictures> {
  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    int freeSwipe = 10;
    bool exceedSwipes = widget.swipedcount >= freeSwipe;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: exceedSwipes,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      height: MediaQuery.sizeOf(context).height * .78,
                      width: MediaQuery.sizeOf(context).width,
                      child: widget.users.length == 0
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor,
                                      radius: 40,
                                    ),
                                  ),
                                  Text(
                                    translate(context, 'no_one_around')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.none,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            )
                          : SwipeStack(
                              key: swipeKey,
                              children: widget.users.map((index) {
                                return SwiperItem(builder:
                                    (SwiperPosition position, double progress) {
                                  return Material(
                                      elevation: 5,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Container(
                                        child: Stack(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              child: Swiper(
                                                customLayoutOption:
                                                    CustomLayoutOption(
                                                  stateCount: 0,
                                                  startIndex: 0,
                                                ),
                                                key: UniqueKey(),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index2) {
                                                  return Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        .78,
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://www.shutterstock.com/shutterstock/photos/2200214153/display_1500/stock-photo-confident-rich-eastern-indian-business-man-executive-standing-in-modern-big-city-looking-and-2200214153.jpg',
                                                      fit: BoxFit.cover,
                                                      useOldImageOnUrlChange:
                                                          true,
                                                      placeholder: (context,
                                                              url) =>
                                                          CupertinoActivityIndicator(
                                                        radius: 20,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  );
                                                },
                                                itemCount: 1,
                                                pagination: SwiperPagination(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    builder:
                                                        DotSwiperPaginationBuilder(
                                                            activeSize: 13,
                                                            color: AppColors
                                                                .secondaryColor,
                                                            activeColor: AppColors
                                                                .primaryColor)),
                                                control: SwiperControl(
                                                  color: AppColors.primaryColor,
                                                  disableColor:
                                                      AppColors.secondaryColor,
                                                ),
                                                loop: false,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(48.0),
                                              child: position.toString() ==
                                                      "SwiperPosition.Left"
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Transform.rotate(
                                                        angle: pi / 8,
                                                        child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                      .red)),
                                                          child: Center(
                                                            child: Text(
                                                                translate(
                                                                    context,
                                                                    'nope')!,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        32)),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : position.toString() ==
                                                          "SwiperPosition.Right"
                                                      ? Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child:
                                                              Transform.rotate(
                                                            angle: -pi / 8,
                                                            child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .lightBlueAccent)),
                                                              child: Center(
                                                                child: Text(
                                                                    translate(
                                                                        context,
                                                                        'like')!,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightBlueAccent,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            32)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: ListTile(
                                                      onTap: () {
                                                        showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) {
                                                              return Info(
                                                                  widget
                                                                      .currentUser,
                                                                  swipeKey);
                                                            });
                                                      },
                                                      title: Text(
                                                        "Abdul Rauf, 22 ${translate(context, 'years')}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        translate(context,
                                                            'user_location')!,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                        ),
                                                      ))),
                                            ),
                                          ],
                                        ),
                                      ));
                                });
                              }).toList(growable: true),
                              threshold: 30,
                              maxAngle: 100,
                              visibleCount: 5,
                              historyCount: 1,
                              stackFrom: StackFrom.Right,
                              translationInterval: 5,
                              scaleInterval: 0.08,
                              onSwipe:
                                  (int index, SwiperPosition position) async {
                                _adsCheck(countswipe);
                                print(position);
                                print(widget.users[index].firstName);

                                if (position == SwiperPosition.Left) {
                                  if (index < widget.users.length) {
                                    userRemoved.clear();
                                    setState(() {
                                      userRemoved.add(widget.users[index]);
                                      widget.users.removeAt(index);
                                    });
                                  }
                                } else if (position == SwiperPosition.Right) {
                                  if (1 != 1) {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          Future.delayed(
                                              Duration(milliseconds: 1700), () {
                                            Navigator.pop(ctx);
                                          });
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 80),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Card(
                                                child: Container(
                                                  height: 100,
                                                  width: 300,
                                                  child: Center(
                                                    child: Text(
                                                      translate(context,
                                                          'its_a_match')!,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .primaryColor,
                                                          fontSize: 30,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }

                                  if (index < widget.users.length) {
                                    userRemoved.clear();
                                    setState(() {
                                      userRemoved.add(widget.users[index]);
                                      widget.users.removeAt(index);
                                    });
                                  }
                                } else {
                                  debugPrint("onSwipe $index $position");
                                }
                              },
                              onRewind: (int index, SwiperPosition position) {
                                swipeKey.currentContext!
                                    .dependOnInheritedWidgetOfExactType();
                                widget.users.insert(index, userRemoved[0]);
                                setState(() {
                                  userRemoved.clear();
                                });
                                debugPrint("onRewind $index $position");
                                print(widget.users[index].id);
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            widget.users.length != 0
                                ? FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      userRemoved.length > 0
                                          ? Icons.replay
                                          : Icons.not_interested,
                                      color: userRemoved.length > 0
                                          ? Colors.amber
                                          : AppColors.secondaryColor,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      if (userRemoved.length > 0) {
                                        swipeKey.currentState!.rewind();
                                      }
                                    })
                                : FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.refresh,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    onPressed: () {},
                                  ),
                            FloatingActionButton(
                                heroTag: UniqueKey(),
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (widget.users.length > 0) {
                                    swipeKey.currentState!.swipeLeft();
                                  }
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
                                  if (widget.users.length > 0) {
                                    swipeKey.currentState!.swipeRight();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _adsCheck(count) {
    print(count);
    if (count % 3 == 0) {
      countswipe++;
    } else {
      countswipe++;
    }
  }
}
