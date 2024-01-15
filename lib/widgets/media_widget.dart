import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../view/custom_checkbox.dart';

class MediaWidget extends StatefulWidget {
  const MediaWidget(
      {super.key,
      required this.itemIndex,
      required this.multiple,
      required this.list,
      required this.onRemove});

  final File itemIndex;
  final bool multiple;
  final List<File> list;
  final Function(File) onRemove;

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.itemIndex.path.endsWith('.mp4')) {
      return Stack(
        children: [
          SizedBox(
            width: widget.multiple
                ? MediaQuery.of(context).size.width / 2 - 12.0
                : null,
            height: widget.multiple ? 258.0 : null,
            child: InkWell(
                onTap: () {
                  Get.to(ShowVideo(
                    fileVideo: widget.itemIndex,
                  ));
                },
                child: VideoWidget(videoPath: widget.itemIndex)),
          ),
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: () {
                widget.onRemove(widget.itemIndex);
              },
              padding: EdgeInsets.zero,
              minWidth: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          InkWell(
            onTap: () {
              Get.to(ShowImage(image: widget.itemIndex));
            },
            child: Image.file(
              widget.itemIndex,
              width: widget.multiple
                  ? MediaQuery.of(context).size.width / 2 - 12.0
                  : null,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: () {
                widget.onRemove(widget.itemIndex);
              },
              padding: EdgeInsets.zero,
              minWidth: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }
}

class MultipleImagesWidget extends StatelessWidget {
  final List<File> list;
  final Function(File) onRemove;

  const MultipleImagesWidget(
      {Key? key, required this.list, required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: list
          .map((itemIndex) => MediaWidget(
                itemIndex: itemIndex,
                multiple: true,
                list: list,
                onRemove: onRemove,
              ))
          .toList(),
    );
  }
}

class SingleImageWidget extends StatelessWidget {
  final List<File> list;
  final Function(File) onRemove;

  const SingleImageWidget(
      {Key? key, required this.list, required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final itemIndex = list[index];
        return MediaWidget(
          itemIndex: itemIndex,
          multiple: false,
          list: list,
          onRemove: onRemove,
        );
      },
    );
  }
}
