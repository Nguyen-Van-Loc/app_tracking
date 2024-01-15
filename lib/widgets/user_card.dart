import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/widgets/admin_actions.dart';
import 'package:app_tracking/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';
import '../view/custom_snackbar.dart';

class UserCard extends StatefulWidget {
  const UserCard(
      {super.key, required this.user, this.controller, required this.getList});

  final User user;
  final dynamic controller;
  final Function() getList;

  @override
  State<UserCard> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final universityController = TextEditingController();
  final usernameController = TextEditingController();
  final studentyearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: InkWell(
          onTap: () async {
            detailUser(widget.user, false, widget.controller);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text("${"user_name".tr}: ${widget.user.displayName}",
                      style: robotoRegular)),
              if (widget.controller.user.roles![0].id == 3)
                AdminActions(
                  user: widget.user,
                  getList: widget.getList,
                  controller: widget.controller,
                  detailUser: detailUser,
                ),
            ],
          )),
    );
  }

  Future<void> detailUser(
      User item, bool status, AuthController controller) async {
    displayNameController.text = item.displayName ?? "";
    usernameController.text = item.username ?? "";
    emailController.text = item.email ?? "";
    studentyearController.text = item.year.toString();
    universityController.text = item.university ?? "";
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          color: Get.isDarkMode ? const Color(0xff7a7a7a) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(!status ? "userinformation".tr : "userupdates".tr,
                    style: roboto),
              ),
              const SizedBox(height: 20),
              controller.user.roles![0].id == 3
                  ? buildInfoCard(
                      enabled: false,
                      title: "username".tr,
                      field: item.username!,
                      status: status,
                      controller: usernameController)
                  : const SizedBox.shrink(),
              buildInfoCard(
                  title: "displayName".tr,
                  field: item.displayName ?? "",
                  status: status,
                  controller: displayNameController),
              buildInfoCard(
                  title: "email".tr,
                  field: item.email!,
                  status: status,
                  controller: emailController),
              buildInfoCard(
                  title: "school's_name".tr,
                  field: item.university ?? "",
                  status: status,
                  controller: universityController),
              buildInfoCard(
                  title: "student_year".tr,
                  field: item.year.toString(),
                  status: status,
                  controller: studentyearController),
              status
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          onEditUser(item);
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20)),
                        child: Text(
                          "update".tr,
                          style: robotoRegular,
                        ),
                      ))
                  : const SizedBox.shrink(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void onEditUser(User item) async {
    AuthController authController = Get.find<AuthController>();
    if (isEmpty(usernameController.text, "username".tr) ||
        isEmpty(displayNameController.text, "displayName".tr) ||
        isEmpty(emailController.text, "email".tr) ||
        isEmptyEmail(emailController.text, "email".tr) ||
        isEmpty(universityController.text, "school's_name".tr) ||
        isEmpty(studentyearController.text, "student_year".tr)) {
      return;
    }
    Get.find<AuthController>().editUser(User(
      id: item.id,
      username: usernameController.text,
      email: emailController.text,
      university: universityController.text,
      year: int.parse(studentyearController.text),
      password: authController.user.password,
      displayName: displayNameController.text,
      roles: item.roles,
      active: true,
    ));
    widget.getList();
    Get.back();
  }
}
