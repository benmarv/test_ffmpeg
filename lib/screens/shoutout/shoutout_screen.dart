import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/create_post/create_post.page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late FlutterSoundRecorder _recorder;
  late FlutterSoundPlayer _player;
  late RecorderController _recorderController;
  bool _isRecording = false;
  bool showPlayButton = false;
  bool _isPlaying = false;
  String _filePath = '';
  Timer? _timer;
  int _recordDuration = 0;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _recorderController = RecorderController();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.request();
    var storageStatus = await Permission.storage.request();
    if (!status.isGranted || !storageStatus.isGranted) {
      return;
    }
    int min = 1;
    int max = 1000;
    int randomInRange = min + Random().nextInt(max - min + 1);
    int randomInRange2 = min + Random().nextInt(10000 - min - 1);
    final directory = await getExternalStorageDirectory();
    final customDir = Directory('${directory!.path}/Recordings');
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    _filePath = '${customDir.path}/shoutout$randomInRange$randomInRange2.wav';

    dev.log('Shoutout audio file path : $_filePath');
    await _recorder.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });
    _recorderController.record();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    _timer?.cancel();
    _recorderController.stop();

    setState(() {
      showPlayButton = true;
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    await _player.openPlayer();

    await _player.startPlayer(fromURI: _filePath);
    setState(() {
      _isPlaying = true;
    });

    // _player.onPlayerComplete.listen((event) {
    //   setState(() {
    //     _isPlaying = false;
    //   });
    // });
  }

  Future<void> _stopPlaying() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate(context, 'sound_recorder')!,
        ),
        actions: [
          if (showPlayButton && _filePath != '')
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreatePostPage(shoutOutAudio: _filePath)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  translate(context, 'save')!, // Use localized string here
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          // if (_isRecording) ...[
          Container(
            margin: const EdgeInsets.all(10),
            height: MediaQuery.sizeOf(context).height * 0.3,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AudioWaveforms(
                  enableGesture: true,
                  size: Size(MediaQuery.sizeOf(context).width, 100.0),
                  recorderController: _recorderController,
                  waveStyle: WaveStyle(
                    waveColor: Colors.greenAccent[400]!,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _isRecording ? _formatDuration(_recordDuration) : '00:00',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),

          // ],
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_filePath != '')
                GestureDetector(
                  onTap: _isPlaying ? _stopPlaying : _playRecording,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                    // border: Border.all(width: 3, color: Colors.black)
                  ),
                  child: Icon(
                    _isRecording ? Icons.square : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              if (_filePath != '')
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _filePath = '';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
