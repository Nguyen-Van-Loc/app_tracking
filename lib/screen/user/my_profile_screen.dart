import 'dart:io';
import 'dart:typed_data';

import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/api/list_user_controller.dart';
import 'package:app_tracking/api/user_controller.dart';
import 'package:app_tracking/data/api/api_client.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/screen/home/image_video_gallery_screen.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? imageFile;
  final usernameController = TextEditingController();
  final displayNameController = TextEditingController();
  final emailController = TextEditingController();
  final universityController = TextEditingController();
  final studentyearController = TextEditingController();
  late UserController userController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController = Get.find<UserController>();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    await userController.getCurrentUser();
    usernameController.text = userController.user.username?.toString() ?? '';
    displayNameController.text =
        userController.user.displayName?.toString() ?? '';
    emailController.text = userController.user.email?.toString() ?? '';
    universityController.text =
        userController.user.university?.toString() ?? '';
    studentyearController.text = userController.user.year?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("information".tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    final image =
                        await Get.to(const ImagePickPage(multiple: false));
                    setState(() {
                      imageFile = image;
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : Image.memory(Uint8List.fromList(
                                userController.image.codeUnits))
                            .image,
                  ),
                ),
                InputTextField(
                  vetical: 15,
                  text: true,
                  enabled: false,
                  width: MediaQuery.of(context).size.width - 20,
                  controller: usernameController,
                  hintText: "username".tr,
                ),
                InputTextField(
                  vetical: 15,
                  text: true,
                  width: MediaQuery.of(context).size.width - 20,
                  controller: displayNameController,
                  hintText: "displayName".tr,
                  onClear: () => displayNameController.clear(),
                ),
                InputTextField(
                  vetical: 15,
                  text: true,
                  width: MediaQuery.of(context).size.width - 20,
                  controller: emailController,
                  hintText: "email".tr,
                  onClear: () => emailController.clear(),
                ),
                InputTextField(
                  vetical: 15,
                  text: true,
                  width: MediaQuery.of(context).size.width - 20,
                  controller: universityController,
                  hintText: "school's_name".tr,
                  onClear: () => universityController.clear(),
                ),
                InputTextField(
                  vetical: 15,
                  text: true,
                  width: MediaQuery.of(context).size.width - 20,
                  controller: studentyearController,
                  hintText: "student_year".tr,
                  onClear: () => studentyearController.clear(),
                ),
                ElevatedButton(
                  onPressed: () {
                    onEdit();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  child: Text(
                    "edit".tr,
                    style: robotoRegular,
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onEdit() async {
    if (imageFile != null) {
      List<MultipartBody> list = [
        MultipartBody("uploadfile", XFile(imageFile!.path))
      ];
      Get.find<UserController>().postImage(list);
    }
    AuthController authController = Get.find<AuthController>();
    if (isEmpty(usernameController.text, "username".tr) ||
        isEmpty(displayNameController.text, "displayName".tr) ||
        isEmpty(emailController.text, "email".tr) ||
        isEmptyEmail(emailController.text, "email".tr) ||
        isEmpty(universityController.text, "school's_name".tr) ||
        isEmpty(studentyearController.text, "student_year".tr)) {
      return;
    }
    Get.find<ListUserController>().editUser(User(
      id: authController.user.id,
      username: usernameController.text,
      email: emailController.text,
      university: universityController.text,
      year: int.parse(studentyearController.text),
      password: authController.user.password,
      displayName: displayNameController.text,
      roles: authController.user.roles,
      image: "123",
      active: true,
    ));
  }
}
