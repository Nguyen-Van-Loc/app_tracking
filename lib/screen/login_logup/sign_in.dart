import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/screen/home/home.dart';
import 'package:app_tracking/screen/login_logup/sign_up.dart';
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
  final userController =TextEditingController();
  final passController =TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    passController.dispose();
  }
  void _toggleEye() {
    setState(() {
      checkEye = !checkEye;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      text: true,
                      controller: userController,
                      hintText: "username".tr,
                      onClear: () => userController.clear(),
                    ),
                    const SizedBox(
                      height: 30,
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
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          _login();
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
          ),
        ),
    );
  }
  _login() {
    String username = userController.text;
    String password = passController.text;
    if (username.isEmpty || password.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Bạn cần điền đầy đủ tài khoản mật khẩu.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Get.find<AuthController>().login(username, password).then((value) => {
        if (value == 200)
          {Get.to(const Home(),transition: Transition.size,duration: const Duration(milliseconds: 500),curve: Curves.easeIn)}
        else if (value == 400)
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Tài khoản mật khẩu không chính xác")))
          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Đã xảy ra lỗi xin vui lòng thử lại")))
          },
      });
    }
  }
}
