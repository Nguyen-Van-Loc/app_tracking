import 'dart:io';

import 'package:app_tracking/data/api/api_checker.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../data/model/body/user.dart';
import '../helper/date_converter.dart';

class NewsController extends GetxController implements GetxService {
  final AuthRepo repo;
  List<bool> showCommentsList = [];
  List<Comments>? latestComments;
  int page = 10;

  NewsController({required this.repo});

  List<TextEditingController> commentsControllers = [];
  List<News>? listNews;
  bool _loading = false;
  bool _loadMove = false;
  bool _initialLoad = false;

  bool get loading => _loading;

  bool get loadMove => _loadMove;

  Future<int> postListNews(int size) async {
    Response response = await repo.listNew(size);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body["content"];
      listNews = responseData.map((content) => News.fromJson(content)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> postNews(News news) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.postNews(news);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("posted_successfully".tr);
      await postListNews(page);
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> likesNews(News news) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.likesNews(news);
    if (response.statusCode == 200) {
      await postListNews(page);
      EasyLoading.dismiss();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return response.statusCode!;
  }

  Future<int> commentsNews(News news, String comment) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.commentsNews(news, comment);
    if (response.statusCode == 200) {
      await postListNews(page);
      EasyLoading.dismiss();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    return response.statusCode!;
  }

  Future<bool> getListNew() async {
    if (!_initialLoad) {
      _loading = true;
      try {
        final value = await postListNews(page);
        if (value == 200) {
          showCommentsList = List.generate(listNews!.length, (index) => false);
          commentsControllers = List.generate(
              listNews!.length, (index) => TextEditingController());
          _initialLoad = true;
          update();
          return _loading = false;
        } else {
          snackbarError("Error data");
        }
      } catch (e) {
        snackbarError("Error loading user data");
      }
    }
    return _loading;
  }

  Future<bool> loadMoveList() async {
    update();
    _loadMove = true;
    await Future.delayed(const Duration(seconds: 2));
    try {
      final value = await postListNews(page += 10);
      if (value == 200) {
        showCommentsList = List.generate(listNews!.length, (index) => false);
        commentsControllers =
            List.generate(listNews!.length, (index) => TextEditingController());
        update();
        return _loadMove = false;
      } else {
        snackbarError("Error data");
      }
    } catch (e) {
      snackbarError("Error loading user data");
    }
    return _loadMove;
  }

  void onPostNews(List<File> list, String title, BuildContext context) async {
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
    postNews(News(
            content: title,
            date: formattedDate,
            user: User.fromJson(ad.body),
            comments: [comments],
            likes: [like],
            media: mediaList))
        .then((value) async {
      await Future.delayed(const Duration(seconds: 2));
      if (value == 200) {
        Navigator.pop(context);
      }
    });
  }
}
