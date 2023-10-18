import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VerVideoExamen extends StatefulWidget {
  const VerVideoExamen({
    Key? key,
    required this.filePath,
  }) : super(key: key);
  final String filePath;
  @override
  _VerVideo createState() => _VerVideo();
}

class _VerVideo extends State<VerVideoExamen> {
  String? videoId;
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoId!,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      hideControls: false,
      controlsVisibleAtStart: true,
      enableCaption: false,
      isLive: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        videoId = YoutubePlayer.convertUrlToId("${widget.filePath}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
   
    );
  }
}




