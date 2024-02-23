import 'dart:async';
import 'dart:convert';

import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/model/body/token_request.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/helper/date_converter.dart';
import 'package:app_tracking/helper/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(
      {required String username, required String password}) async {
    //header login
    var token = "Basic Y29yZV9jbGllbnQ6c2VjcmV0";
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': '$token'
    };
    //call api login
    return await apiClient.postDataLogin(
        AppConstants.LOGIN_URI,
        TokenRequest(
                username: username,
                password: password,
                clientId: "core_client",
                clientSecret: "secret",
                grantType: "password")
            .toJson(),
        header);
  }

  Future<Response> getTokenDevice() async {
    String tokenDevice = await NotificationHelper.getDeviceToken();
    return await apiClient
        .getData(AppConstants.TOKENDEVICE, query: {"tokenDevice": tokenDevice});
  }

  Future<Response> listUser(int size) async {
    Get.lazyPut(
            () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
    return await apiClient.postData(AppConstants.SEARCH_BY_PAGE,
        {"keyWord": "string", "pageIndex": 0, "size": size, "status": 0});
  }

  Future<Response> listNew(int size) async {
    Get.lazyPut(
            () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
    return await apiClient.postData(AppConstants.GET_NEWS,
        {"keyWord": "string", "pageIndex": "0", "size": size.toString(), "status": "0"});
  }

  Future<Response> getTracking() async {
    return await apiClient.getData(AppConstants.TRACKING_GET_POST);
  }

  Future<Response> deleteTracking(int id) async {
    return await apiClient.deleteData(
      "${AppConstants.TRACKING_UPDATE_DEL}$id",
    );
  }

  Future<Response> createUser(User user) async {
    return await apiClient.postData(AppConstants.SIGN_UP, {
      "active": true,
      "changePass": true,
      "confirmPassword": user.confirmPassword,
      "displayName": user.displayName,
      "email": user.email,
      "firstName": user.firstName,
      "gender": user.gender,
      "lastName": user.lastName,
      "password": user.password,
      "university": user.university,
      "username": user.username,
      "year": user.year,
      "birthPlace": user.birthPlace,
    });
  }

  Future<Response> saveTracking(
      Map<String, dynamic> user, String content) async {
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    return await apiClient.postData(AppConstants.TRACKING_GET_POST,
        {"content": content, "user": user, "date": formattedDate});
  }

  Future<Response> updateTracking(
      Map<String, dynamic> user, String content, int id) async {
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    return await apiClient.postData("${AppConstants.TRACKING_UPDATE_DEL}$id",
        {"content": content, "user": user, "date": formattedDate});
  }

  Future<Response> updateUser(User user) async {
    final roles = user.roles?.map((role) => role.toJson()).toList();
    return await apiClient
        .postData("${AppConstants.BASE_URL_UPDATE}${user.id}", {
      "active": true,
      "displayName": user.displayName,
      "email": user.email,
      "password": user.password,
      "university": user.university,
      "username": user.username,
      "year": user.year.toString(),
      "roles": roles,
      "image":user.image
    });
  }

  Future<Response> postNews(News news) async {
    return await apiClient.postData(AppConstants.POST_NEWS, {
      "content": news.content,
      "date": news.date,
      "user": news.user,
      "media": news.media,
      "like": news.likes,
      "comments": news.comments
    });
  }
  Future<Response> postImage(List<MultipartBody> imageImage) async {
    final token = Get.find<AuthRepo>().getUserToken();
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> header = {
      'Content-Type': 'multipart/form-data',
      AppConstants.LOCALIZATION_KEY:
      languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    return await apiClient.postMultipartData(
      AppConstants.POST_IMAGE,
      {"uploadfile":imageImage[0].file.toString()},
      imageImage,
      headers: header,
    );
  }
  Future<Response> getNotifi() async {
    return await apiClient.getData(
      AppConstants.GET_NOTIFI,
    );
  }

  Future<Response> likesNews(News news) async {
    return await apiClient.postData("${AppConstants.LIKE_NEWS}${news.id}", {
      "date": news.date,
      "post": {
        "comments": news.comments,
        "content": news.content,
        "date": news.date,
        "id": news.id,
        "likes": [null],
        "media": news.media,
        "user": news.user
      },
      "type": 0,
      "user": news.user
    });
  }

  Future<Response> commentsNews(News news, String comments) async {
    return await apiClient.postData("${AppConstants.COMMENTS_NEWS}${news.id}", {
      "content": comments,
      "date": news.date,
      "post": {
        "comments": [null],
        "content": news.content,
        "date": news.date,
        "id": news.id,
        "likes": news.likes,
        "media": news.media,
        "user": news.user
      },
      "user": news.user
    });
  }

  Future<Response> logOut() async {
    return await apiClient.deleteData(AppConstants.LOG_OUT);
  }

  Future<bool> saveListUser(String key, List<dynamic> userData) async {
    List<String> userStringList =
        userData.map((user) => jsonEncode(user)).toList();
    return await apiClient.sharedPreferences.setStringList(key, userStringList);
  }

  Future<bool> saveListNews(String key, List<dynamic> userData) async {
    List<String> userStringList =
        userData.map((user) => jsonEncode(user)).toList();
    return await apiClient.sharedPreferences.setStringList(key, userStringList);
  }

  Future<List<String>?> getNewsUser() async {
    return apiClient.sharedPreferences.getStringList("newsList");
  }

  String getIp() {
    return sharedPreferences.getString("ip") ?? "";
  }

  Future<List<String>?> getListUser() async {
    return apiClient.sharedPreferences.getStringList("userList");
  }

  Future<Response> getCurrentUser() async {
    return await apiClient.getData(AppConstants.GET_USER);
  }

  Future<Response> blockUser(int useId) async {
    final token = Get.find<AuthRepo>().getUserToken();
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    return await apiClient.getData(AppConstants.BLOCK_USER + useId.toString(),
        headers: header);
  }

  Future<Response> getTimeSheets(String ip) async {
    final token = Get.find<AuthRepo>().getUserToken();
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    return await apiClient.getData(AppConstants.TIME_SHEETS,
        query: {"ip": ip}, headers: header);
  }
  Future<Response> getImage() async {
    return await apiClient.getData(AppConstants.IMAGE_FILE,);
  }
  Future<String> _saveDeviceToken() async {
    String? deviceToken = '@';
    if (!GetPlatform.isWeb) {
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {}
    }
    if (deviceToken != null) {
      print('--------Device Token---------- ' + deviceToken);
    }
    return deviceToken!;
  }

  // for  user token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = "Bearer $token";
    apiClient.updateHeader("Bearer $token", null,
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? "vi", 0);
    return await sharedPreferences.setString(
        AppConstants.TOKEN, "Bearer $token");
  }

  Future<bool> clearUserToken() async {
    return await sharedPreferences.remove(AppConstants.TOKEN);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedAddress() {
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(
          AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserNumber(String number, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(
          AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
