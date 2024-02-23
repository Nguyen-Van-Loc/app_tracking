import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/login_logup/sign_up.dart';

class SignInWidget extends StatefulWidget {
  final bool checkEye;
  final Function() toggleEye,login;
  final TextEditingController userController;
  final TextEditingController passController;
  const SignInWidget({super.key, required this.userController, required this.passController, required this.checkEye, required this.toggleEye, required this.login});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
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
              top: 240,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "sign_in".tr,
                  style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              InputTextField(
                vetical: 5,
                text: true,
                controller:widget.userController,
                hintText: "username".tr,
                onClear: () => widget.userController.clear(),
              ),
              InputTextField(
                vetical: 5,
                text: true,
                obscureText:!widget.checkEye,
                checkEye: widget.checkEye,
                controller: widget.passController,
                hintText: "password".tr,
                onClear: () => widget.toggleEye(),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    widget.login();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Text(
                    "sign_in".tr,
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
                  Text("do_not_have_an_account".tr),
                  TextButton(
                      onPressed: () {
                        Get.to(
                          const SignUp(),
                          fullscreenDialog: true,
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      child: Text("sign_up".tr))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        Center(
            child: GetBuilder<AuthController>(
              builder: (controller) {
                return Visibility(
                  visible: controller.loading,
                  child: const CircularProgressIndicator(),
                );
              },
            )
        )
      ],
    );
  }
}
