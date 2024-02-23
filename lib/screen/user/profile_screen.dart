import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/api/user_controller.dart';
import 'package:app_tracking/helper/route_helper.dart';
import 'package:app_tracking/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Get.find<UserController>().getImageFile();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: ProfileWidget()
      ),
    );
  }
}
