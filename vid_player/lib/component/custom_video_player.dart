import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  bool showControls = false;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initController();
  }

  initController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController.initialize();

    videoController.addListener(vidoeControllerListener);

    setState(() {
      _controller = videoController;
    });
  }

  void vidoeControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.removeListener(vidoeControllerListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      _controller?.dispose();
      initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        // child: VideoPlayer(_controller!),
        child: Stack(
          children: [
            VideoPlayer(_controller!),
            if (showControls) Container(color: Color.fromRGBO(0, 0, 0, 0.5)),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                // child: Slider(
                //   min: 0,
                //   max: _controller!.value.duration.inSeconds.toDouble(),
                //   value: _controller!.value.position.inSeconds.toDouble(),
                //   onChanged: (double v) {
                //     _controller!.seekTo(Duration(seconds: v.toInt()));
                //   },
                // ),
                child: Row(
                  children: [
                    rednerTimeTextFromDuration(_controller!.value.position),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: _controller!.value.duration.inSeconds.toDouble(),
                        value: _controller!.value.position.inSeconds.toDouble(),
                        onChanged: (double v) {
                          _controller!.seekTo(Duration(seconds: v.toInt()));
                        },
                      ),
                    ),
                    rednerTimeTextFromDuration(_controller!.value.duration),
                  ],
                ),
              ),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<double>(
                      value: playbackSpeed,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      dropdownColor: Colors.black,
                      items: [
                        DropdownMenuItem<double>(
                          value: 1.0,
                          child: Text(
                            "1.0x",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem<double>(
                          value: 1.5,
                          child: Text(
                            "1.5x",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem<double>(
                          value: 2.0,
                          child: Text(
                            "2.0x",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          playbackSpeed = value!;
                          _controller!.setPlaybackSpeed(playbackSpeed);
                        });
                      },
                    ),
                    CustomIconButton(
                      onPressed: widget.onNewVideoPressed,
                      iconData: Icons.photo_camera_back,
                    ),
                  ],
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPausePressed,
                      iconData:
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = _controller!.value.position;

    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    _controller!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = _controller!.value.duration;
    final currentPosition = _controller!.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    _controller!.seekTo(position);
  }

  void onPlayPausePressed() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      showControls = false;
      _controller!.play();
    }
  }

  Widget rednerTimeTextFromDuration(Duration duration) {
    return Text(
      "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
      style: TextStyle(color: Colors.white),
    );
  }
}
