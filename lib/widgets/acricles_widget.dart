import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/user_controller.dart';

import '../utils/styles.dart';
import 'media_widget.dart';

class ActiclesWidget extends StatefulWidget {
  const ActiclesWidget({super.key, required this.list, required this.title});

  final TextEditingController title;
  final List<File> list;

  @override
  State<ActiclesWidget> createState() => _ActiclesWidgetState();
}

class _ActiclesWidgetState extends State<ActiclesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GetBuilder<UserController>(
            builder: (controller) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Text(controller.user.displayName!, style: roboto),
                ],
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 5,
          color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade200,
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (txt) {
                setState(() {});
              },
              controller: widget.title,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "what_are_you_thinking".tr,
              ),
            )),
        if (widget.list.length >= 2)
          MultipleImagesWidget(list: widget.list, onRemove: removeFromList)
        else
          SingleImageWidget(list: widget.list, onRemove: removeFromList),
      ],
    );
  }

  void removeFromList(File item) {
    setState(() {
      widget.list.remove(item);
    });
  }
}

class AppBarActicles extends StatelessWidget implements PreferredSizeWidget {
  const AppBarActicles(
      {Key? key, required this.onPostNews, required this.title})
      : super(key: key);

  final Function() onPostNews;
  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: title,
        builder: (context, child) {
          return AppBar(
            title: Text("create_articles".tr),
            actions: [
              MaterialButton(
                onPressed: title.text.isEmpty ? null : onPostNews,
                minWidth: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "post".tr,
                  style: robotoRegular,
                ),
              )
            ],
          );
        });
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ButtonNavigationBarActicles extends StatelessWidget {
  const ButtonNavigationBarActicles({super.key, required this.selectImages});

  final VoidCallback selectImages;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectImages,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: .2,
            color: Get.isDarkMode ? Colors.grey.shade200 : Colors.black38,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        child: Row(
          children: [
            const Icon(CupertinoIcons.photo_on_rectangle),
            const SizedBox(width: 10),
            Text("photo/video".tr),
          ],
        ),
      ),
    );
  }
}
