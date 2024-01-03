import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/helper/route_helper.dart';
import 'package:app_tracking/screen/user/listofemployee.dart';
import 'package:app_tracking/screen/user/myprofile.dart';
import 'package:app_tracking/screen/user/tranking.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/view/custom_list.dart';
import 'package:flutter/cupertino.dart';
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
    Get.find<AuthController>().getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              alignment: Alignment.center,
              child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/image/logo_login.jpg")),
            ),
            GetBuilder<AuthController>(
              builder: (controller) {
                return Text(
                  controller.user.displayName.toString().tr,
                  style: roboto,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Custom_list(
                textTile: "information",
                radius: 10,
                icon: CupertinoIcons.person_alt_circle,
                iconsux: Icons.navigate_next,
                onPressed: () async {
                 await  Get.to(const MyProfile(),transition: Transition.rightToLeftWithFade);
                 Get.find<AuthController>().getCurrentUser();
                }),
            const SizedBox(
              height: 20,
            ),
            Custom_list(
                textTile: "list_user",
                radius: 10,
                icon: CupertinoIcons.list_dash,
                iconsux: Icons.navigate_next,
                onPressed: () {
                  Get.to(const Listofemployee(),transition: Transition.rightToLeftWithFade);
                }),
            const SizedBox(
              height: 20,
            ),
            Custom_list(
                textTile: "tracking_list",
                radius: 10,
                icon: Icons.spatial_tracking,
                iconsux: Icons.navigate_next,
                onPressed: () {
                  Get.to(const Tracking_List(),transition: Transition.rightToLeftWithFade);
                }),
            const SizedBox(
              height: 20,
            ),
            const Custom_list(
                textTile: "terms",
                radius: 10,
                iconsux: Icons.navigate_next,
                icon: Icons.policy,
                ),
            const SizedBox(
              height: 20,
            ),
            const Custom_list(
                textTile: "language",
                radius: 10,
                icon: Icons.language,
                iconsux: Icons.navigate_next,
            ),
            const SizedBox(
              height: 20,
            ),
             const Custom_list(
                textTile: "regime",
                radius: 10,
                icon: Icons.settings,
                iconsux: Icons.navigate_next,
               ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  logOut();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "logout".toString().tr,
                  style: robotoMedium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logOut() {
    Get.find<AuthController>().logOut().then((value) => {
          if (value == 200)
            {Get.offNamed(RouteHelper.signIn)}
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Đã có lỗi xảy ra vui lòng thử lại")))
            }
        });
  }
}
