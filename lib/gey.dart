import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Initialize the Video player
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState

    _controller = VideoPlayerController.asset('assets/vids/rickRoll.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player!!")),
      body: content(),
      floatingActionButton: FloatingActionButton(
          child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }),
    );
  }

  Widget content() {
    return Center(
        child: Container(
      width: 350,
      height: 350,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : Container(),
    ));
  }
}
