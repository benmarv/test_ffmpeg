import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class MoviePlay extends StatefulWidget {
  final String? url;
  const MoviePlay({super.key, this.url});

  @override
  State<MoviePlay> createState() => _MoviePlayState();
}

class _MoviePlayState extends State<MoviePlay> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isFullScreen = false;
  bool _isControlsVisible = true;
  Duration _videoDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  late final ValueNotifier<bool> _isFullScreenNotifier;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!))
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
        _videoDuration = _controller!.value.duration;
      });
    _isFullScreenNotifier = ValueNotifier<bool>(_isFullScreen);
    _controller!.addListener(() {
      setState(() {
        _currentPosition = _controller!.value.position;
        _isPlaying = _controller!.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _isFullScreenNotifier.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // Reset orientation when exiting fullscreen
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _isFullScreenNotifier.value = _isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = _isFullScreenNotifier.value;
    final controls = _isControlsVisible
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isFullScreen)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: _toggleFullScreen,
                        child: Icon(Icons.fullscreen_exit, color: Colors.white),
                      )
                    ],
                  ),
                ),
              if (!isFullScreen)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: _toggleFullScreen,
                        child: Icon(Icons.fullscreen_exit, color: Colors.white),
                      )
                    ],
                  ),
                ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white),
                    onPressed: _togglePlayPause,
                  ),
                  Expanded(
                    child: VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${_formatDuration(_currentPosition)} / ${_formatDuration(_videoDuration)}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          )
        : SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isControlsVisible = !_isControlsVisible;
            });
          },
          child: Stack(
            children: [
              Center(
                child: _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : CircularProgressIndicator(),
              ),
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _isControlsVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: controls,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
