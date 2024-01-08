import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/utils/color_resources.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_tracking/widgets/item_list_tile.dart';

class Listofemployee extends StatefulWidget {
  const Listofemployee({super.key});

  @override
  State<Listofemployee> createState() => _ListofemployeeState();
}

class _ListofemployeeState extends State<Listofemployee> {
  List<User>? user;
  bool loading = false;
  int page = 20;
  bool loadingMove = false;
  late ScrollController _scrollController;
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final universityController = TextEditingController();
  final usernameController = TextEditingController();
  final studentyearController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getListUser();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoveList();
    }
  }

  void loadMoveList() async {
    setState(() {
      loadingMove = true;
    });
    user = await Get.find<AuthController>().postListUser(page += page);
    setState(() {
      loadingMove = false;
    });
  }

  void getListUser() async {
    loading = true;
    user = await Get.find<AuthController>().postListUser(page);
    if (user == null) {
      return;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list_user".tr),
      ),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final itemIndex = user![index];
                  return GetBuilder<AuthController>(
                    builder: (controller) {
                      return itemIndex.roles![0].id == 3
                          ? const SizedBox.shrink()
                          :
                      Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              elevation: 2,
                              child: InkWell(
                                  onTap: () async {
                                    detailUser(itemIndex, false, controller);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                          child: Text(
                                              "${"user_name".tr}: ${itemIndex.displayName}",
                                              style: robotoRegular)),
                                      controller.user.roles![0].id == 3
                                          ? Row(
                                              children: [
                                                MaterialButton(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  minWidth: 0,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  onPressed: () {
                                                    detailUser(itemIndex, true,
                                                        controller);
                                                  },
                                                  child: Icon(Icons.edit,
                                                      color: ColorResources
                                                          .gradientColor),
                                                ),
                                                MaterialButton(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    minWidth: 0,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onPressed: () {
                                                      Get.defaultDialog(
                                                          onConfirm: () async {
                                                            Get.find<
                                                                    AuthController>()
                                                                .blockUser(
                                                                    itemIndex
                                                                        .id!);
                                                            Get.back();
                                                            getListUser();
                                                          },
                                                          title: "notification"
                                                              .tr,
                                                          titleStyle: roboto,
                                                          textConfirm:
                                                              "confirm_to".tr,
                                                          textCancel: "cancel"
                                                              .tr,
                                                          content: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: itemIndex
                                                                      .active!
                                                                  ? Text(
                                                                      "are_you_sure_you_want_to_block_this_account"
                                                                          .tr)
                                                                  : Text(
                                                                      "are_you_sure_you_want_to_unblock_this_account"
                                                                          .tr)));
                                                    },
                                                    child: itemIndex.active!
                                                        ? Icon(Icons.lock,
                                                            color:
                                                                ColorResources
                                                                    .redColor)
                                                        : Icon(Icons.lock_open,
                                                            color: ColorResources
                                                                .gradientColor)),
                                              ],
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  )),
                            );
                    },
                  );
                },
                itemCount: user!.length),
      ),
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
    getListUser();
    Get.back();
  }
}
