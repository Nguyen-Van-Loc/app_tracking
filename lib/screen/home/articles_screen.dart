import 'dart:io';

import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/screen/home/image_video_gallery.dart';
import 'package:app_tracking/view/custom_checkbox.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repository/auth_repo.dart';
import '../../helper/date_converter.dart';
import '../../utils/styles.dart';

class Create_Articles extends StatefulWidget {
  const Create_Articles({super.key});

  @override
  State<Create_Articles> createState() => _Create_ArticlesState();
}

class _Create_ArticlesState extends State<Create_Articles> {
  late FocusNode myFocusNode;
  List<File> list = [];
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }

  Future<void> _selectImages() async {
    final selectedImages = await Get.to<List<File>>(
      const ImagePickPage(multiple: true),
      transition: Transition.cupertinoDialog,
    );

    if (selectedImages != null) {
      setState(() {
        list.addAll(selectedImages);
      });
    }
  }

  Widget buildMediaWidget(File itemIndex, bool multiple) {
    if (itemIndex.path.endsWith('.mp4')) {
      return Stack(
        children: [
          SizedBox(
            width:
                multiple ? MediaQuery.of(context).size.width / 2 - 12.0 : null,
            height: multiple ? 258.0 : null,
            child: VideoWidget(videoPath: itemIndex),
          ),
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  list.removeWhere((element) => element == itemIndex);
                });
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
              Get.to(ShowImage(image: itemIndex));
            },
            child: Image.file(
              itemIndex,
              width: multiple
                  ? MediaQuery.of(context).size.width / 2 - 12.0
                  : null,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 0,
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  list.removeWhere((element) => element == itemIndex);
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create_articles".tr),
        actions: [
          MaterialButton(
            onPressed: () {
              onPostNews();
            },
            minWidth: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Đăng",
              style: robotoRegular,
            ),
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: _selectImages,
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
      ),
      body: InkWell(
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: () => myFocusNode.requestFocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GetBuilder<AuthController>(
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
                  height: 5,
                  color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade200,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: contentController,
                    focusNode: myFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "what_are_you_thinking".tr,
                    ),
                  ),
                ),
                if (list.length >= 2)
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: list
                        .map((itemIndex) => buildMediaWidget(itemIndex, true))
                        .toList(),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final itemIndex = list[index];
                      return buildMediaWidget(itemIndex, false);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPostNews() async {
    if (isEmpty(contentController.text, "what_are_you_thinking".tr)) {
      return;
    }
    List<Media> mediaList = [];
    int currentId = 0;
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    Comments comments = Comments(
        user: User.fromJson(ad.body), date: formattedDate, content: "", id: 0);
    Likes like = Likes(
        user: User.fromJson(ad.body), date: formattedDate, id: 0, type: 0);
    for (var file in list) {
      Media media = Media(
        id: currentId,
        name: file.path,
        contentType: file.path.endsWith('.mp4')? "mp4" : "jpg",
        contentSize: file.lengthSync()~/ 1024,
        isVideo: true,
        filePath: file.path,
        extension: ""
      );
      currentId++;
      mediaList.add(media);
    }
    Get.find<AuthController>().postNews(News(
      content: contentController.text,
      date: formattedDate,
      user: User.fromJson(ad.body),
      comments:[comments],
      likes: [like],
      media: mediaList
    ));
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
  }
}
