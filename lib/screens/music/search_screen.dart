import 'dart:async';
import 'package:flutter/material.dart';
import 'package:link_on/components/data_not_found.dart';
import 'package:link_on/controllers/my_loading.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/viewModel/api_client.dart';
import 'package:provider/provider.dart';
import 'item_fav_music_screen.dart';

class SearchMusicScreen extends StatefulWidget {
  final List<SoundList>? soundList;
  final Function onSoundClick;
  final Function onCheckClick;
  SearchMusicScreen(
      {this.soundList, required this.onCheckClick, required this.onSoundClick});
  @override
  _SearchMusicScreenState createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  var _streamController = StreamController<List<SoundList>?>();
  bool isSearch = true;
  @override
  void initState() {
    super.initState();
    if (widget.soundList != null) {
      isSearch = false;
      _streamController.add(widget.soundList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, value, child) {
        if (isSearch) {
          getSearchSoundList(value.getMusicSearchText);
        }
        return StreamBuilder<List<SoundList>?>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return snapshot.data != null && snapshot.data!.isNotEmpty
                ? ListView(
                    physics: BouncingScrollPhysics(),
                    children: List<ItemFavMusicScreen>.generate(
                      snapshot.data!.length,
                      (index) => ItemFavMusicScreen(
                        soundList: snapshot.data![index],
                        onItemClick: (soundUrl) {
                          widget.onSoundClick(soundUrl);
                        },
                        type: 3,
                        onCheckClick: (soundUrl) {
                          widget.onCheckClick(soundUrl);
                        },
                      ),
                    ),
                  )
                : DataNotFound();
          },
        );
      },
    );
  }


  void getSearchSoundList(String keyword) {
    // apiService.client.close();
    apiClient.fetchSearchSoundList(keyword).then((value) {
      _streamController.add(value.data);
    });
  }
}
