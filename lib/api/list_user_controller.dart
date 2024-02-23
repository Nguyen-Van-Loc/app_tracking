import 'package:app_tracking/data/api/api_checker.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ListUserController extends GetxController implements GetxService {
  final AuthRepo repo;

  ListUserController({required this.repo});

  int page = 20;
  bool _loading = false;
  bool _loadMove = false;

  bool get loading => _loading;

  bool get loadMove => _loadMove;
  List<User>? listUser;

  Future<int> postListUser(int size) async {
    Response response = await repo.listUser(size);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = response.body["content"];
      listUser = responseData.map((content) => User.fromJson(content)).toList();
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

  void showBlockDialog(User user, Function() getList) {
    Get.defaultDialog(
      onConfirm: () async {
        blockUser(user.id!);
        getList();
        Get.back();
      },
      title: "notification".tr,
      titleStyle: roboto,
      textConfirm: "confirm_to".tr,
      textCancel: "cancel".tr,
      content: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: user.active!
            ? Text("are_you_sure_you_want_to_block_this_account".tr)
            : Text("are_you_sure_you_want_to_unblock_this_account".tr),
      ),
    );
  }

  Future<bool> getListUser() async {
    _loading = true;
    try {
      final value = await postListUser(page);
      if (value == 200) {
        update();
        return _loading = false;
      } else {
        snackbarError("Error data");
      }
    } catch (e) {
      snackbarError("Error loading more data");
    }
    return _loading;
  }

  Future<bool> loadMoveList() async {
    update();
    _loadMove = true;
    await Future.delayed(const Duration(seconds: 3));
    try {
      final value = await postListUser(page += 10);
      if (value == 200) {
        update();
        return _loadMove = false;
      } else {
        snackbarError("Error data");
      }
    } catch (e) {
      snackbarError("Error loading more data");
    }
    return _loadMove;
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
}
