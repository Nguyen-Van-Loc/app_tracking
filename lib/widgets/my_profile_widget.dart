import 'dart:io';
import 'dart:typed_data';

import 'package:app_tracking/api/user_controller.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home/image_video_gallery_screen.dart';
import '../utils/styles.dart';

class MyProfileWidget extends StatefulWidget {
  final TextEditingController usernameController,
      displayNameController,
      emailController,
      universityController,
      studentyearController;

  const MyProfileWidget({
    super.key,
    required this.usernameController,
    required this.displayNameController,
    required this.emailController,
    required this.universityController,
    required this.studentyearController,
  });

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  File? imageFile;
  late UserController userController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController = Get.find<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () async {
            final image = await Get.to(const ImagePickPage(multiple: false));
            setState(() {
              imageFile = image;
            });
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: imageFile != null
                ? FileImage(imageFile!)
                : Image.memory(
                        Uint8List.fromList(userController.image.codeUnits))
                    .image,
          ),
        ),
        InputTextField(
          vetical: 15,
          text: true,
          enabled: false,
          width: MediaQuery.of(context).size.width - 20,
          controller: widget.usernameController,
          hintText: "username".tr,
        ),
        InputTextField(
          vetical: 15,
          text: true,
          width: MediaQuery.of(context).size.width - 20,
          controller: widget.displayNameController,
          hintText: "displayName".tr,
          onClear: () => widget.displayNameController.clear(),
        ),
        InputTextField(
          vetical: 15,
          text: true,
          width: MediaQuery.of(context).size.width - 20,
          controller: widget.emailController,
          hintText: "email".tr,
          onClear: () => widget.emailController.clear(),
        ),
        InputTextField(
          vetical: 15,
          text: true,
          width: MediaQuery.of(context).size.width - 20,
          controller: widget.universityController,
          hintText: "school's_name".tr,
          onClear: () => widget.universityController.clear(),
        ),
        InputTextField(
          vetical: 15,
          text: true,
          width: MediaQuery.of(context).size.width - 20,
          controller: widget.studentyearController,
          hintText: "student_year".tr,
          onClear: () => widget.studentyearController.clear(),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
          child: Text(
            "edit".tr,
            style: robotoRegular,
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
