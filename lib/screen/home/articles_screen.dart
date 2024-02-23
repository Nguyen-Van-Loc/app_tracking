import 'dart:io';
import 'package:app_tracking/api/news_controller.dart';
import 'package:app_tracking/screen/home/image_video_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/user_controller.dart';
import '../../utils/styles.dart';
import '../../widgets/acricles_widget.dart';
import '../../widgets/media_widget.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => ArticlesScreenState();
}

class ArticlesScreenState extends State<ArticlesScreen> {
  List<File> list = [];
  final contentController = TextEditingController();
  late NewsController newsController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newsController = Get.find<NewsController>();
  }

  Future<void> selectImages() async {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarActicles(
        onPostNews: () {
          newsController.onPostNews(list, contentController.text, context);
        },
        title: contentController,
      ),
      bottomNavigationBar: ButtonNavigationBarActicles(
        selectImages: () {
          setState(() {
            selectImages();
          });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: ActiclesWidget(
          list: list, title: contentController,
        )),
      ),
    );
  }
}