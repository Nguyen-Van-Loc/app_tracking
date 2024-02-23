import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/screen/home/home.dart';
import 'package:app_tracking/screen/login_logup/sign_up.dart';
import 'package:app_tracking/widgets/sign_in_widget.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool checkEye = false;
  final userController = TextEditingController();
  final passController = TextEditingController();
  late AuthController authController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    passController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController =Get.find<AuthController>();
  }
  void toggleEye() {
    setState(() {
      checkEye = !checkEye;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SignInWidget(
        checkEye: checkEye,
        passController: passController,
        userController: userController,
        toggleEye: toggleEye, login: () {
          authController.OnLogin(userController.text, passController.text,context);
          },
      )),
    );
  }

}
