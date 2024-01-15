import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';

class AdminActions extends StatelessWidget {
  const AdminActions(
      {super.key,
      required this.user,
      this.controller,
      required this.getList,
      required this.detailUser});

  final User user;
  final dynamic controller;
  final Function() getList;
  final dynamic detailUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          padding: const EdgeInsets.all(5),
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            detailUser(user, true, controller);
          },
          child: Icon(
            Icons.edit,
            color: ColorResources.gradientColor,
          ),
        ),
        MaterialButton(
          padding: const EdgeInsets.all(5),
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            showBlockDialog(user, controller, getList);
          },
          child: user.active!
              ? Icon(Icons.lock, color: ColorResources.redColor)
              : Icon(Icons.lock_open, color: ColorResources.gradientColor),
        ),
      ],
    );
  }

  void showBlockDialog(
      User user, AuthController controller, Function() getList) {
    Get.defaultDialog(
      onConfirm: () async {
        Get.find<AuthController>().blockUser(user.id!);
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
}
