import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/notifi.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/screen/home/notification.dart';
import 'package:app_tracking/screen/likes/likes_screen.dart';
import 'package:app_tracking/screen/search/search_screen.dart';
import 'package:app_tracking/screen/user/profile_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
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

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<Widget> listWidget = [
    const HomeScreen(),
    const LikesScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];
  var index = 0.obs;
  String title = "home";
  var _currentIndex = 0;
  bool check = false;
  List<Notifications>? list;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    title = "home";
    getNotification();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void getNotification() async {
    list = [];
    setState(() {
      check = true;
    });
    try {
      final value = await Get.find<AuthController>().getNotification();
      if (value == 200) {
        list = Get.find<AuthController>().listNoti;
      } else {
        showSnackbar("Lỗi dữ liệu");
      }
    } catch (e) {
      showSnackbar("Error loading user data");
    } finally {
      setState(() {
        check = false;
      });
    }
  }

  Future<void> onButtonTimesheets() async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasClickedToday = prefs.getString('lastClickedDate') == currentDate;
    if (!hasClickedToday) {
      await Get.find<AuthController>().timeSheets(Get.find<AuthRepo>().getIp());
      prefs.setString('lastClickedDate', currentDate);
    } else {
      EasyLoading.showError("you've_already_marked_your_time_today".tr);
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title.tr),
        actions: [
          _buildNotificationButton(),
          TextButton(
              onPressed: () async {
                onButtonTimesheets();
              },
              child: Text(
                "timekeeping".tr,
                style: const TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            LikesScreen(),
            SearchScreen(),
            ProfileScreen(),
          ],),
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
            title = "home";
            break;
          case 1:
            title = "favorite";
            break;
          case 2:
            title = "search";
            break;
          case 3:
            title = "profile";
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
