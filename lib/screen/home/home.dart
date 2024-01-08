import 'dart:convert';

import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/notifi.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/screen/home/notification.dart';
import 'package:app_tracking/screen/likes/likes_screen.dart';
import 'package:app_tracking/screen/search/search_screen.dart';
import 'package:app_tracking/screen/user/profile_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> listWidget = [
    const HomeScreenSection0(),
    const LikesScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var index = 0.obs;
  var title = "home".obs;
  var _currentIndex = 0;
  bool check = false;
  List<Notifications>? list;

  @override
  void initState() {
    super.initState();
    title.value = "home".tr;
    _currentIndex = 0;
    getNotification();
  }

  void getNotification() async {
    list = [];
    setState(() {
      check = true;
    });
    list = await Get.find<AuthController>().getNotification();
    setState(() {
      check = false;
    });
  }

  Future<void> onButtonTimesheets() async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasClickedToday = prefs.getString('lastClickedDate') == currentDate;
    if (!hasClickedToday) {
      await Get.find<AuthController>()
          .time_Sheets(Get.find<AuthRepo>().getIp());
      prefs.setString('lastClickedDate', currentDate);
    } else {
      EasyLoading.showError("you've_already_marked_your_time_today".tr);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => Text(title.value)),
        actions: [
          _buildNotificationButton(),
          TextButton(
              onPressed: () async {
                onButtonTimesheets();
              },
              child: Text("timekeeping".tr,style: TextStyle(color: Colors.white),))
        ],
      ),
      body: listWidget[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() {
        _currentIndex = i;
        switch (_currentIndex) {
          case 0:
            title.value = "home".tr;
            // logOut();
            break;
          case 1:
            title.value = "favorite".tr;
            break;
          case 2:
            title.value = "search".tr;
            break;
          case 3:
            title.value = "profile".tr;
            break;
        }
      }),
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home_outlined),
          title: Text("home".tr),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.favorite_border),
          title: Text("favorite".tr),
          selectedColor: Colors.pink,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.search),
          title: Text("search".tr),
          selectedColor: Colors.orange,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person_outline),
          title: Text("profile".tr),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Container(
        margin: const EdgeInsets.only(top: 15, right: 15),
        child: badges.Badge(
          badgeContent: Text(
            list!.isNotEmpty ? list!.length.toString() : "0",
            style: const TextStyle(color: Colors.white),
          ),
          showBadge: true,
          ignorePointer: false,
          child: InkWell(
              onTap: () {
                Get.to(
                  const Notification_Screen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: const Icon(
                Icons.notifications,
                size: 30,
              )),
        ));
  }
}
