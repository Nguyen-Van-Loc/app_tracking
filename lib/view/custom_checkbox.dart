import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({Key? key, required this.value, this.onChanged})
      : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.value);
          setState(() {});
        }
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.value ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2.0),
        ),
        child: widget.value
            ? const Icon(
          Icons.check,
          size: 20,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}
class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          PhotoView(imageProvider: FileImage(image)),
          Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white))),
        ]));
  }
}
class VideoWidget extends StatefulWidget {
  final File videoPath;

  const VideoWidget({required this.videoPath, Key? key}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController!.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(videoPlayerController!),
          const Center(
              child: Icon(
                CupertinoIcons.play_circle,
                size: 50,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}