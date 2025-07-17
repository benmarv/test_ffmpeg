import 'package:flutter/material.dart';
// import 'package:lecle_flutter_link_preview/lecle_flutter_link_preview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeLinkPreview extends StatefulWidget {
  final String url;

  const YouTubeLinkPreview({Key? key, required this.url}) : super(key: key);

  @override
  _YouTubeLinkPreviewState createState() => _YouTubeLinkPreviewState();
}

class _YouTubeLinkPreviewState extends State<YouTubeLinkPreview> {
  YoutubePlayerController? _youtubeController;
  bool isYouTubeLink = false;

  @override
  void initState() {
    super.initState();
    _initializeLinkPreview();
  }

  void _initializeLinkPreview() async {
    // final metadata = await LecleFlutterLinkPreview.getPreviewData(widget.url);
    final videoId = YoutubePlayer.convertUrlToId(widget.url);

    if (videoId != null) {
      setState(() {
        isYouTubeLink = true;
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      });
    } else {
      setState(() {
        isYouTubeLink = false;
      });
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
        aspectRatio: 16 / 9,
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
      );
  }
}
