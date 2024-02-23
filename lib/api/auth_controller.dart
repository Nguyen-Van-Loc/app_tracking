import 'package:app_tracking/data/api/api_checker.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/data/model/body/notifi.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/data/model/response/token_resposive.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/screen/home/home.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../data/api/api_client.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo repo;

  AuthController({required this.repo});

  bool _loading = false;
  User _user = User();

  List<Notifications>? listNoti;

  bool get loading => _loading;
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
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      snackbarFailed("account_already_exists".tr);
    } else {
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

  Future<void> OnLogin(
      String username, String password, BuildContext context) async {
    if (username.isEmpty || password.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Bạn cần điền đầy đủ tài khoản mật khẩu.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      login(username, password).then((value) => {
            if (value == 200)
              {
                Get.to(const Home(),
                    transition: Transition.size,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn)
              }
            else if (value == 400)
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Tài khoản mật khẩu không chính xác")))
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Đã xảy ra lỗi xin vui lòng thử lại")))
              },
          });
    }
  }

  Future<void> onSignUp(
      String userController,
      nameController,
      lastController,
      emailController,
      birthPlaceController,
      univerController,
      yearController,
      passController,
      repassController,
      BuildContext context,
      genderController) async {
    if (isEmpty(userController, "username".tr) ||
        isEmpty(nameController, "name".tr) ||
        isEmpty(lastController, "last_name".tr) ||
        isEmpty(emailController, "email".tr) ||
        isEmptyEmail(emailController, "email".tr) ||
        isEmpty(birthPlaceController, "date_of_birth".tr) ||
        isEmpty(univerController, "school's_name".tr) ||
        isEmpty(yearController, "student_year".tr) ||
        isEmpty(passController, "password".tr) ||
        isEmptyPassword(passController, "password".tr) ||
        isEmpty(repassController, "confirm_password".tr) ||
        !isPasswordMatch(passController, repassController)) {
      return;
    }
    int success = await registerUser(User(
      username: userController,
      firstName: nameController,
      lastName: lastController,
      email: emailController,
      birthPlace: birthPlaceController,
      university: univerController,
      year: int.parse(yearController),
      password: passController,
      confirmPassword: repassController,
      gender: genderController,
      displayName: lastController + nameController,
    ));
    if (success == 200) {
      Navigator.pop(context);
    }
  }
}
