import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/my_loading.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/screens/camera/session_manager.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ItemFavMusicScreen extends StatefulWidget {
  final SoundList soundList;
  final Function onItemClick;
  final Function onCheckClick;
  final int type;

  ItemFavMusicScreen(
      {required this.soundList,
      required this.onItemClick,
      required this.type,
      required this.onCheckClick});

  @override
  _ItemFavMusicScreenState createState() => _ItemFavMusicScreenState();
}

class _ItemFavMusicScreenState extends State<ItemFavMusicScreen> {
  final SessionManager sessionManager =  SessionManager();

  @override
  void initState() {
    super.initState();
    initSessionManager();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () {
        widget.onItemClick(widget.soundList);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Consumer<MyLoading>(
              builder: (context, value, child) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Image(
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.soundList.soundImage!),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Visibility(
                      visible: value.lastSelectSoundId ==
                          widget.soundList.sound! + widget.type.toString(),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            !value.getLastSelectSoundIsPlay
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.soundList.soundTitle!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.soundList.singer!,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.soundList.duration!,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () async {
                final response = await apiClient
                    .addRemoveFavSounds(widget.soundList.soundId.toString());
                if (response['success'] == 200) {
                  String message = response['message'];
                  toast('$message');
                }
                sessionManager
                    .saveFavouriteMusic(widget.soundList.soundId.toString());
                setState(() {});
              },
              child: Icon(
                sessionManager
                        .getFavouriteMusic()
                        .contains(widget.soundList.soundId)
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            Consumer<MyLoading>(
              builder: (context, value, child) => Visibility(
                visible: value.lastSelectSoundId ==
                    widget.soundList.sound! + widget.type.toString(),
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () async {
                    Provider.of<MyLoading>(context, listen: false)
                        .setIsDownloadClick(true);
                    widget.onCheckClick(widget.soundList);
                  },
                  child: Container(
                    width: 50,
                    height: 25,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initSessionManager() async {
    sessionManager.initPref().then((value) {
      setState(() {});
    });
  }
}
