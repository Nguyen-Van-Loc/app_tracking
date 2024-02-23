import 'package:app_tracking/api/list_user_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:app_tracking/widgets/admin_actions.dart';
import 'package:app_tracking/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/styles.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.controller,
    required this.getList,
  }) : super(key: key);

  final User user;
  final dynamic controller;
  final Function() getList;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final universityController = TextEditingController();
  final usernameController = TextEditingController();
  final studentYearController = TextEditingController();
  late ListUserController listUserController;

  @override
  void initState() {
    super.initState();
    displayNameController.text = widget.user.displayName ?? "";
    usernameController.text = widget.user.username ?? "";
    emailController.text = widget.user.email ?? "";
    universityController.text = widget.user.university ?? "";
    studentYearController.text = widget.user.year.toString();
    listUserController = Get.find<ListUserController>();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          await detailUser(false);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"user_name".tr}: ${widget.user.displayName}",
                  style: robotoRegular),
              if (widget.controller.user.roles![0].id == 3)
                AdminActions(
                  user: widget.user,
                  getList: widget.getList,
                  detailUser: detailUser,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> detailUser(bool status) async {
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
              // controller.user.roles![0].id == 3
              //     ? buildInfoCard(
              //         enabled: false,
              //         title: "username".tr,
              //         field: widget.user.username,
              //         status: status,
              //         controller: usernameController)
              //     : const SizedBox.shrink(),
              buildInfoCard(
                  title: "displayName".tr,
                  field: widget.user.displayName ?? "",
                  status: status,
                  controller: displayNameController),
              buildInfoCard(
                  title: "email".tr,
                  field: widget.user.email ?? "",
                  status: status,
                  controller: emailController),
              buildInfoCard(
                  title: "school's_name".tr,
                  field: widget.user.university ?? "",
                  status: status,
                  controller: universityController),
              buildInfoCard(
                  title: "student_year".tr,
                  field: widget.user.year ?? "",
                  status: status,
                  controller: studentYearController),
              status
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          onEditUser();
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

  void onEditUser() async {
    if (isEmpty(usernameController.text, "username".tr) ||
        isEmpty(displayNameController.text, "displayName".tr) ||
        isEmpty(emailController.text, "email".tr) ||
        isEmptyEmail(emailController.text, "email".tr) ||
        isEmpty(universityController.text, "school's_name".tr) ||
        isEmpty(studentYearController.text, "student_year".tr)) {
      return;
    }
    listUserController.editUser(User(
      id: widget.user.id,
      username: usernameController.text,
      email: emailController.text,
      university: universityController.text,
      year: int.parse(studentYearController.text),
      password: widget.user.password,
      displayName: displayNameController.text,
      roles: widget.user.roles,
      active: true,
    ));
    widget.getList();
    Get.back();
  }
}
