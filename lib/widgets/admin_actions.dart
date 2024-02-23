import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/api/list_user_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminActions extends StatelessWidget {
  const AdminActions(
      {super.key,
      required this.user,
      required this.getList,
      required this.detailUser});

  final User user;
  final Function() getList;
  final Future<void> Function(bool)  detailUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          padding: const EdgeInsets.all(5),
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            detailUser(true);
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
            Get.find<ListUserController>(). showBlockDialog(user, getList);
          },
          child: user.active!
              ? Icon(Icons.lock, color: ColorResources.redColor)
              : Icon(Icons.lock_open, color: ColorResources.gradientColor),
        ),
      ],
    );
  }
}
