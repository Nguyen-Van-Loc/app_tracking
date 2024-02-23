import 'package:app_tracking/api/auth_controller.dart';

import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:app_tracking/widgets/sign_up_widget.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late AuthController authController;
  bool checkEye = false;
  final userController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();
  final nameController = TextEditingController();
  final lastController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final univerController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final yearController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
    repassController.dispose();
    nameController.dispose();
    lastController.dispose();
    genderController.dispose();
    emailController.dispose();
    univerController.dispose();
    birthPlaceController.dispose();
    yearController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SignUpWidget(
                toggleEye: toggleEye,
                userController: userController,
                passController: passController,
                checkEye: checkEye,
                birthPlaceController: birthPlaceController,
                emailController: emailController,
                genderController: genderController,
                lastController: lastController,
                nameController: nameController,
                repassController: repassController,
                univerController: univerController,
                yearController: yearController,
                onSignUp: () {
                  authController.onSignUp(
                      userController.text,
                      nameController.text,
                      lastController.text,
                      emailController.text,
                      birthPlaceController.text,
                      univerController.text,
                      yearController.text,
                      passController.text,
                      repassController.text,
                      context,
                      genderController.text);
                })),
      ),
    );
  }

  void toggleEye() {
    setState(() {
      checkEye = !checkEye;
    });
  }
}
