import 'package:app_tracking/api/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/auth_controller.dart';
import '../helper/route_helper.dart';
import '../screen/user/list_of_employee_screen.dart';
import '../screen/user/my_profile_screen.dart';
import '../screen/user/tranking_screen.dart';
import '../utils/styles.dart';
import '../view/custom_list.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50, bottom: 20),
          alignment: Alignment.center,
          child: const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  "http://android-tracking.oceantech.com.vn/mita/public/images/imagelogo.png")),
        ),
        GetBuilder<UserController>(
          builder: (controller) {
            return Text(
              controller.user.displayName.toString(),
              style: roboto,
            );
          },
        ),
        Custom_list(
            textTile: "information",
            radius: 10,
            icon: CupertinoIcons.person_alt_circle,
            iconsux: Icons.navigate_next,
            onPressed: () async {
              await Get.to(const MyProfile(),
                  transition: Transition.rightToLeftWithFade);
            }),

        Custom_list(
            textTile: "list_user",
            radius: 10,
            icon: CupertinoIcons.list_dash,
            iconsux: Icons.navigate_next,
            onPressed: () {
              Get.to(const ListOfEmployeeScreen(),
                  transition: Transition.rightToLeftWithFade);
            }),

        Custom_list(
            textTile: "tracking_list",
            radius: 10,
            icon: Icons.spatial_tracking,
            iconsux: Icons.navigate_next,
            onPressed: () {
              Get.to(const Tracking_List(),
                  transition: Transition.rightToLeftWithFade);
            }),

        const Custom_list(
          textTile: "terms",
          radius: 10,
          iconsux: Icons.navigate_next,
          icon: Icons.policy,
        ),

        const Custom_list(
          textTile: "language",
          radius: 10,
          icon: Icons.language,
          iconsux: Icons.navigate_next,
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
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text(
              "logout"
                  .toString()
                  .tr,
              style: robotoMedium,
            ),
          ),
        )
      ],
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
