import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/screens/music/item_fav_music_screen.dart';

class ItemDiscoverScreen extends StatelessWidget {
  final SoundData soundData;
  final Function onMoreClick;
  final Function? onPlayClick;
  final Function? onCheckClick;

  ItemDiscoverScreen(
      {required this.soundData,
      required this.onMoreClick,
      required this.onPlayClick,
      required this.onCheckClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 35,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  soundData.soundCategoryName!,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  onMoreClick.call(soundData.soundList);
                },
                child: Row(
                  children: [
                    Text('More', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 5),
                    Icon(Icons.menu, color: AppColors.primaryColor),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          child: GridView(
            scrollDirection: Axis.horizontal,
            primary: false,
            shrinkWrap: false,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 105 / MediaQuery.of(context).size.width,
            ),
            children: new List<Widget>.generate(
              soundData.soundList!.length,
              (index) => ItemFavMusicScreen(
                soundList: soundData.soundList![index],
                onItemClick: (soundUrl) {
                  onPlayClick!(soundUrl);
                },
                type: 1,
                onCheckClick: (soundUrl) {
                  onCheckClick!(soundUrl);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
