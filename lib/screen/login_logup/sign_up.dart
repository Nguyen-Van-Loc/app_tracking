import 'package:app_tracking/api/auth_controller.dart';

import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
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
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    InputTextField(
                      text: true,
                      controller: userController,
                      hintText: "username".tr,
                      onClear: () => userController.clear(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputTextField(
                          text: true,
                          width: 100,
                          heigth: 90,
                          controller: nameController,
                          hintText: "name".tr,
                          onClear: () =>nameController.clear(),
                        ),
                        InputTextField(
                          text: true,
                          width: 100,
                          heigth: 90,
                          controller: lastController,
                          hintText: "last_name".tr,
                          onClear: () => lastController.clear(),
                        ),
                        InputTextField(
                          text: true,
                          width: 100,
                          heigth: 90,
                          controller: genderController,
                          hintText: "gender".tr,
                          onClear: () => genderController.clear(),
                        ),
                      ],
                    ),
                    InputTextField(
                      text: true,
                      controller: emailController,
                      hintText: "email".tr,
                      onClear: () => emailController.clear(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      text: true,
                      controller: birthPlaceController,
                      hintText: "date_of_birth".tr,
                      onClear: () => birthPlaceController.clear(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      text: true,
                      controller: univerController,
                      hintText: "school's_name".tr,
                      onClear: () => univerController.clear(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      text: true,
                      textInputType: TextInputType.number,
                      controller: yearController,
                      hintText: "student_year".tr,
                      onClear: () => yearController.clear(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      text: true,
                      obscureText: !checkEye,
                      checkEye: checkEye,
                      controller: passController,
                      hintText: "password".tr,
                      onClear: () => _toggleEye(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputTextField(
                      text: true,
                      obscureText: !checkEye,
                      checkEye: checkEye,
                      controller: repassController,
                      hintText: "confirm_password".tr,
                      onClear: () => _toggleEye(),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => onSignUp(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:  Text(
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
                          child:  Text("sign_in".tr),
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
          ),
        ),
      ),
    );
  }

  void _toggleEye() {
    setState(() {
      checkEye = !checkEye;
    });
  }

  void onSignUp()  async{
    if (isEmpty(userController.text, "username".tr) ||
        isEmpty(nameController.text, "name".tr) ||
        isEmpty(lastController.text, "last_name".tr) ||
        isEmpty(emailController.text, "email".tr) ||
        isEmptyEmail(emailController.text, "email".tr) ||
        isEmpty(birthPlaceController.text, "date_of_birth".tr) ||
        isEmpty(univerController.text, "school's_name".tr) ||
        isEmpty(yearController.text, "student_year".tr) ||
        isEmpty(passController.text, "password".tr) ||
        isEmptyPassword(passController.text, "password".tr) ||
        isEmpty(repassController.text, "confirm_password".tr) ||
        !isPasswordMatch(passController.text, repassController.text)) {
      return;
    }
      int success =await Get.find<AuthController>().registerUser(User(
      username: userController.text,
      firstName: nameController.text,
      lastName: lastController.text,
      email: emailController.text,
      birthPlace: birthPlaceController.text,
      university: univerController.text,
      year:  int.parse(yearController.text),
      password: passController.text,
      confirmPassword: repassController.text,
      gender: genderController.text,
      displayName: lastController.text + nameController.text,
      ));
    if(success==200) {
      Navigator.pop(context);
    }
  }
}
