import 'package:app_tracking/data/api/api_checker.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/model/body/notifi.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/data/model/response/token_resposive.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../data/api/api_client.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo repo;

  AuthController({required this.repo});

  bool _loading = false;
  User _user = User();
  List<User>? listUser;
  List<News>? listNews;
  List<Notifications>? listNoti;
  bool get loading => _loading;
  String image="";
  User get user => _user;

  Future<int> login(String username, String password) async {
    _loading = true;
    update();
    Response response =
        await repo.login(username: username, password: password);
    if (response.statusCode == 200) {
      TokenResponsive tokeBody = TokenResponsive.fromJson(response.body);
      await repo.saveUserToken(tokeBody.accessToken!);
      repo.getTokenDevice();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> postListUser(int size) async {
    _loading = true;
    Response response = await repo.listUser(size);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body["content"];
      listUser = responseData.map((content) => User.fromJson(content)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> postListNews(int size) async {
    _loading = true;
    Response response = await repo.listNew(size);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body["content"];
      listNews = responseData.map((content) => News.fromJson(content)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> postNews(News news) async {
    _loading = true;
    EasyLoading.show(status: "loading...");
    Response response = await repo.postNews(news);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("posted_successfully".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }
  Future<int> postImage(List<MultipartBody> imageList) async {
    _loading = true;
    Response response = await repo.postImage(imageList);
    if (response.statusCode == 200) {
      print(response.body);
      EasyLoading.dismiss();
      snackbarSuccess("posted_successfully".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }
  Future<int> likesNews(News news) async {
    _loading = true;
    EasyLoading.show(status: "loading...");
    Response response = await repo.likesNews(news);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> commentsNews(News news, String comment) async {
    _loading = true;
    EasyLoading.show(status: "loading...");
    Response response = await repo.commentsNews(news, comment);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> getNotification() async {
    Response response = await repo.getNotifi();
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body;
      listNoti = responseData
          .map((content) => Notifications.fromJson(content))
          .toList();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> logOut() async {
    _loading = true;
    EasyLoading.show(status: "loading...");
    Response response = await repo.logOut();
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      repo.clearUserToken();
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    update();
    return response.statusCode!;
  }

  Future<int> getCurrentUser() async {
    Response response = await repo.getCurrentUser();
    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  void clearData() {
    _loading = false;
    _user = User();
  }

  Future<int> registerUser(
    User user,
  ) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.createUser(user);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("register".tr + "success".tr);
    } else if (response.statusCode == 400) {
      snackbarFailed("account_already_exists".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> editUser(User user) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.updateUser(user);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("account_updated_successfully".tr);
    } else {
      print(response.statusCode!);
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> timeSheets(String ip) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.getTimeSheets(ip);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("you_have_succeeded_in_timekeeping".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }
  Future<int> getImageFile() async {
    Response response = await repo.getImage();
    if (response.statusCode == 200) {
      image= response.body;
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> blockUser(int userId) async {
    EasyLoading.show(status: "loading...");
    Response response = await repo.blockUser(userId);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      snackbarSuccess("the_account_has_been_successfully_disabled".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }
}
