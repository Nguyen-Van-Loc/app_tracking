import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpWidget extends StatefulWidget {
  final TextEditingController userController,
      passController,
      repassController,
      nameController,
      lastController,
      genderController,
      emailController,
      univerController,
      birthPlaceController,
      yearController;
  final bool checkEye;
  final Function() onSignUp, toggleEye;

  const SignUpWidget(
      {super.key,
      required this.userController,
      required this.passController,
      required this.repassController,
      required this.nameController,
      required this.lastController,
      required this.genderController,
      required this.emailController,
      required this.univerController,
      required this.birthPlaceController,
      required this.yearController,
      required this.checkEye,
      required this.onSignUp,
      required this.toggleEye});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              "assets/image/background.png",
              fit: BoxFit.cover,
              height: 400,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/image/light.png",
                  width: 90,
                ),
                Image.asset(
                  "assets/image/light.png",
                  width: 70,
                ),
              ],
            ),
            Positioned(
              top: 30,
              child: MaterialButton(
                minWidth: 0,
                shape: const CircleBorder(),
                onPressed: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.back),
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "sign_up".tr,
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              InputTextField(
                vetical: 10,
                text: true,
                controller: widget.userController,
                hintText: "username".tr,
                onClear: () => widget.userController.clear(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputTextField(
                    text: true,
                    width: MediaQuery.of(context).size.width /4,
                    heigth: 90,
                    controller: widget.nameController,
                    hintText: "name".tr,
                    onClear: () => widget.nameController.clear(),
                  ),
                  InputTextField(
                    text: true,
                    width: MediaQuery.of(context).size.width /4,
                    heigth: 90,
                    controller: widget.lastController,
                    hintText: "last_name".tr,
                    onClear: () => widget.lastController.clear(),
                  ),
                  InputTextField(
                    text: true,
                    width: MediaQuery.of(context).size.width /4,
                    heigth: 90,
                    controller: widget.genderController,
                    hintText: "gender".tr,
                    onClear: () => widget.genderController.clear(),
                  ),
                ],
              ),
              InputTextField(
                vetical: 10,
                text: true,
                controller: widget.emailController,
                hintText: "email".tr,
                onClear: () => widget.emailController.clear(),
              ),
              InputTextField(
                vetical: 10,
                text: true,
                controller: widget.birthPlaceController,
                hintText: "date_of_birth".tr,
                onClear: () => widget.birthPlaceController.clear(),
              ),
              InputTextField(
                vetical: 10,
                text: true,
                controller: widget.univerController,
                hintText: "school's_name".tr,
                onClear: () => widget.univerController.clear(),
              ),
              InputTextField(
                vetical: 10,
                text: true,
                textInputType: TextInputType.number,
                controller: widget.yearController,
                hintText: "student_year".tr,
                onClear: () => widget.yearController.clear(),
              ),
              InputTextField(
                vetical: 10,
                text: true,
                obscureText: !widget.checkEye,
                checkEye: widget.checkEye,
                controller: widget.passController,
                hintText: "password".tr,
                onClear: () => widget.toggleEye(),
              ),
              InputTextField(
                vetical: 10,
                text: true,
                obscureText: !widget.checkEye,
                checkEye: widget.checkEye,
                controller: widget.repassController,
                hintText: "confirm_password".tr,
                onClear: () => widget.toggleEye(),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => widget.onSignUp(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "sign_up".tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("do_you_already_have_an_account".tr),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("sign_in".tr),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
