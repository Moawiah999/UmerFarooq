
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


class VideoScreen extends StatefulWidget {
  final String videoLink;
  const VideoScreen({super.key, required this.videoLink});

  @override
  // ignore: library_private_types_in_public_api
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoLink));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      allowFullScreen: true,
      looping: false, // Set to true if you want the video to loop
      // aspectRatio: 16 / 9, // Adjust the aspect ratio based on your video dimensions
      showControlsOnInitialize: true,
      fullScreenByDefault: true,
      showControls: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Video Player'),
      // ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
