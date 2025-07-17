// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/reactionlist/haha_reaction.dart';
import 'package:link_on/screens/reactionlist/reaction_list_controller.dart';
import 'package:link_on/screens/reactionlist/angry_reaction.dart';
import 'package:link_on/screens/reactionlist/like_reaction.dart';
import 'package:link_on/screens/reactionlist/love_reaction.dart';
import 'package:link_on/screens/reactionlist/sad_reaction.dart';
import 'package:link_on/screens/reactionlist/wow_reaction.dart';
import 'package:provider/provider.dart';

class ReactionsList extends StatefulWidget {
  final String? postid;
  const ReactionsList({super.key, this.postid});

  @override
  State<ReactionsList> createState() => _ReactionsListState();
}

class _ReactionsListState extends State<ReactionsList>
    with SingleTickerProviderStateMixin {
  final colors = [
    Colors.blue.shade700,
    Colors.red,
    Colors.yellow,
    Colors.yellow,
    Colors.yellow,
    Colors.orange
  ];
  Color? indicatorColor;
  TabController? _controller;

  @override
  void initState() {
    Provider.of<ReactionListController>(context, listen: false).clearList();
    Provider.of<ReactionListController>(context, listen: false)
        .fetchReactionList(widget.postid!);
    super.initState();
    _controller = TabController(length: 6, vsync: this)
      ..addListener(() {
        setState(() {
          indicatorColor = colors[_controller!.index];
        });
      });
    indicatorColor = colors[0];
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<ReactionListController>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          title: Text(
            translate(context, 'people_who_reacted')!,
            style: TextStyle(fontSize: 17),
          ),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: indicatorColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3.0,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/like.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist1.length.toString())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/love.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist2.length.toString())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/haha.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist3.length.toString())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/wow.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist4.length.toString())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/sad.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist5.length.toString())
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/fbImages/angry.gif',
                      height: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(value.reactionlist6.length.toString())
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller!,
          children: [
            const LikeReaction(),
            const LoveReaction(),
            const HahaReaction(),
            const WowReaction(),
            const SadReaction(),
            const AngryReaction(),
          ],
        ),
      ),
    ));
  }
}
