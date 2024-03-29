import 'dart:async';

import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/api/splash_controller.dart';
import 'package:app_tracking/api/user_controller.dart';
import 'package:app_tracking/screen/home/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../helper/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../view/no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });
    _route();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: splashController.hasConnection
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Images.logo, width: 200),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),
                    ],
                  )
                : NoInternetScreen(child: const SplashScreen()),
          ),
        );
      }),
    );
  }

  _route() {
    Get.find<UserController>().getCurrentUser().then((value) => {
          if (value == 200)
            {
              Get.off(const Home(),
                  transition: Transition.size,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn)
            }
          else
            {Get.offNamed(RouteHelper.signIn)}
        });
  }
}
