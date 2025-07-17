// ignore_for_file: body_might_complete_normally_catch_error
import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:link_on/components/dialog/loader_dialog.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/my_loading.dart';
import 'package:link_on/models/sound/sound.dart';
import 'package:link_on/screens/camera/video_editor_screen.dart';
import 'package:link_on/screens/music/discover_page.dart';
import 'package:link_on/screens/music/search_screen.dart';
import 'package:path_provider/path_provider.dart';

class MainMusicScreen extends StatefulWidget {
  final Function(SoundList?, String) onSelectMusic;
  final bool? flag;
  final String? postVideo;
  final String? thumbNail;
  final String? soundId;
  final bool? isFromStory;

  MainMusicScreen(this.onSelectMusic,
      {this.flag,
      this.postVideo,
      this.soundId,
      this.thumbNail,
      this.isFromStory = false});
  @override
  _MainMusicScreenState createState() => _MainMusicScreenState();
}

class _MainMusicScreenState extends State<MainMusicScreen> {
  FocusNode _focus = new FocusNode();
  List<SoundList>? soundList;
  bool isPlay = false;
  SoundList? lastSoundListData;
  AudioPlayer? audioPlayer = AudioPlayer();
  String _localPath = '';

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      Provider.of<MyLoading>(context, listen: false)
          .setIsSearchMusic(_focus.hasFocus);
      soundList = null;
    });
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  void _bindBackgroundIsolate() {
    dynamic isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      int status = data[1];
      if (status == 3) {
        print('go back 2 times');
        widget.onSelectMusic(lastSoundListData,
            _localPath + Platform.pathSeparator + lastSoundListData!.sound!);
        Navigator.pop(context);
      }
    });
  }

  @pragma('vm:entry-point')
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music", style: TextStyle(fontSize: 18.0)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.968,
        child: Column(
          children: [
            Consumer<MyLoading>(
              builder: (context, value, child) {
                return Container(
                  margin: EdgeInsets.only(
                      left: soundList != null ? 0 : 15, top: 15, right: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: TextField(
                    onChanged: (value) {
                      if (audioPlayer != null) {
                        audioPlayer?.release();
                      }
                      MyLoading myLoading =
                          Provider.of<MyLoading>(context, listen: false);
                      myLoading.setMusicSearchText(value);
                      myLoading.setLastSelectSoundId("");
                    },
                    focusNode: _focus,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.primaryColor,
                      border: InputBorder.none,
                      hintText: 'Search',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                );
              },
            ),
            Container(
                margin: EdgeInsets.only(top: 18),
                height: 0.2,
                color: Colors.grey),
            Expanded(
              child: Consumer<MyLoading?>(
                builder: (context, value, child) {
                  return value != null && !value.isSearchMusic
                      ? DiscoverPage(
                          onMoreClick: (value) {
                            soundList = value;
                            Provider.of<MyLoading>(context, listen: false)
                                .setIsSearchMusic(true);
                          },
                          onCheckClick: (data) {
                            downloadAudio(data: data);
                          },
                          onPlayClick: (data) {
                            playMusic(data, 1);
                          },
                        )
                      : (soundList != null && soundList!.isNotEmpty
                          ? SearchMusicScreen(
                              soundList: soundList,
                              onSoundClick: (data) {
                                playMusic(data, 3);
                              },
                              onCheckClick: (data) {
                                downloadAudio(data: data);
                              },
                            )
                          : SearchMusicScreen(
                              onCheckClick: (data) {
                                downloadAudio(data: data);
                              },
                              onSoundClick: (data) {
                                playMusic(data, 3);
                              },
                            ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer?.release();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void playMusic(SoundList data, int type) async {
    MyLoading myLoading = Provider.of<MyLoading>(context, listen: false);
    if (myLoading.isDownloadClick) {
      myLoading.setIsDownloadClick(false);
      _localPath = (await _findLocalPath());

      final savedDir = Directory(_localPath);

      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
      if (File(savedDir.path + "/" + data.sound!).existsSync()) {
        File(savedDir.path + "/" + data.sound!).deleteSync();
      }
      await FlutterDownloader.enqueue(
        url: "${data.sound!}",
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true,
      );
      return;
    }
    if (lastSoundListData == data) {
      if (isPlay) {
        isPlay = false;
        audioPlayer?.pause();
      } else {
        isPlay = true;
        audioPlayer?.resume();
      }
      myLoading.setLastSelectSoundIsPlay(isPlay);
      return;
    }
    lastSoundListData = data;
    myLoading.setLastSelectSoundId(lastSoundListData!.sound! + type.toString());
    myLoading.setLastSelectSoundIsPlay(true);
    if (audioPlayer != null) {
      audioPlayer?.release();
    }
    audioPlayer?.play(UrlSource("${lastSoundListData?.sound}"));
    isPlay = true;
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();
    return "${directory?.path}";
  }

  Future downloadAudio({required SoundList data}) async {
    log(
      "${data.sound!}",
    );
    String f = await _findLocalPath();
    showDialog(
      context: context,
      builder: (context) => LoaderDialog(),
    );
    final response = await http.get(Uri.parse(data.sound!));

    print("download response is ${response.body}");
    print("download file path is $f/audio.mp3");
    final file = File("$f/audio.mp3");
    await file.writeAsBytes(response.bodyBytes).whenComplete(() {}).catchError(
      (e) {
        toast("Error");
      },
    );

    var videoPath =
        "$f${Platform.pathSeparator}output${DateTime.now().millisecond}.mp4";
    print("audio path is $f/audio.mp3");

    await FFmpegKit.execute(
      '-y -i ${widget.postVideo} -i $f/audio.mp3 -c:v libx264 -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 -shortest $videoPath',
    ).then((value) async {
      final returnCode = await value.getReturnCode();
      // Handle success and failure cases
      if (ReturnCode.isSuccess(returnCode)) {
        log("FFmpeg command executed successfully.");
      } else if (ReturnCode.isCancel(returnCode)) {
        log("FFmpeg command was cancelled.");
      } else {
        // Handle error
        log("FFmpeg command failed with error.");
      }
      log("path is ${f}");
      await value.cancel();
    }).whenComplete(() {
      toast("Exported");
      Navigator.of(context).pop();
    }).catchError((e) {
      log("compressing error ${e}");
      Navigator.of(context).pop();
      throw Exception(e);
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VideoEditorScreen(
          isFromStory: widget.isFromStory,
          postVideo: videoPath,
          thumbNail: widget.thumbNail,
          sound: "$f/audio.mp3",
          soundId: widget.soundId,
        ),
      ),
    );
  }
}
