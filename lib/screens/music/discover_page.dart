import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'item_discover_screen.dart';

class DiscoverPage extends StatefulWidget {
  final Function? onMoreClick;
  final Function? onPlayClick;
  final Function? onCheckClick;

  DiscoverPage({this.onMoreClick, this.onPlayClick, this.onCheckClick});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<SoundData>? soundCategoryList = [];

  @override
  void initState() {
    getDiscoverSound();
    super.initState();
  }
   void getDiscoverSound() {
    apiClient.fetchSoundList().then((value) {
      soundCategoryList = value.data;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return soundCategoryList == null
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          )
        : ListView(
            physics: BouncingScrollPhysics(),
            children: List<ItemDiscoverScreen>.generate(
              soundCategoryList!.length,
              (index) => ItemDiscoverScreen(
                soundData: soundCategoryList![index],
                onMoreClick: (soundList) {
                  widget.onMoreClick?.call(soundList);
                },
                onPlayClick: widget.onPlayClick,
                onCheckClick: widget.onCheckClick,
              ),
            ),
          );
  }

 
}
