import 'dart:io';

import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/screen/home/image_video_gallery_screen.dart';
import 'package:app_tracking/widgets/media_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repository/auth_repo.dart';
import '../../helper/date_converter.dart';
import '../../utils/styles.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => ArticlesScreenState();
}

class ArticlesScreenState extends State<ArticlesScreen> {
  List<File> list = [];
  final contentController = TextEditingController();

  void removeFromList(File item) {
    print(list);
    setState(() {
      list.remove(item);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("create_articles".tr),
        actions: [
          MaterialButton(
            onPressed: contentController.text.isEmpty
                ? null
                : () {
                    onPostNews();
                  },
            minWidth: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "post".tr,
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
      body:  SafeArea(
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
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: 5,
                  color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade200,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (txt){
                      setState(() {});
                    },
                    controller: contentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "what_are_you_thinking".tr,
                    ),
                  ),
                ),
                if (list.length >= 2)
                  MultipleImagesWidget(list: list, onRemove: removeFromList)
                else
                  SingleImageWidget(list: list, onRemove: removeFromList),
              ],
            ),
          ),
        ),
    );
  }

  void onPostNews() async {
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
          contentType: file.path.endsWith('.mp4') ? "mp4" : "jpg",
          contentSize: file.lengthSync() ~/ 1024,
          isVideo: true,
          filePath: file.path,
          extension: "");
      currentId++;
      mediaList.add(media);
    }
    Get.find<AuthController>().postNews(News(
        content: contentController.text,
        date: formattedDate,
        user: User.fromJson(ad.body),
        comments: [comments],
        likes: [like],
        media: mediaList));
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
  }
}