import 'dart:io';

import 'package:app_tracking/api/localization_controller.dart';
import 'package:app_tracking/firebase_options.dart';
import 'package:app_tracking/helper/notification_helper.dart';
import 'package:app_tracking/helper/responsive_helper.dart';
import 'package:app_tracking/helper/route_helper.dart';
import 'package:app_tracking/theme/dark_theme.dart';
import 'package:app_tracking/theme/light_theme.dart';
import 'package:app_tracking/theme/theme_controller.dart';
import 'package:app_tracking/utils/app_constants.dart';
import 'package:app_tracking/utils/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';


Future<void> main() async {
  if (kDebugMode) {
    print("Bắt đầu: ${DateTime.now()}");
  }
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  List<NetworkInterface> interfaces = await NetworkInterface.list(
      includeLoopback: false, includeLinkLocal: false);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  for (var interface in interfaces) {
    if(interface.name =="wlan0"){
      print('Tên: ${interface.name}');
      for (var addr in interface.addresses) {
        print('Địa chỉ IP: ${addr.address}');
        prefs.setString("ip", addr.address);
      }
      print('---');
    }
  }
  setPathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationHelper.getDeviceToken().then((value) {
    print("tokenDrive $value");
  });
  try {
    if (GetPlatform.isMobile) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  Map<String, Map<String, String>> _languages = await di.init();
  runApp(MyApp(languages: _languages));
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  const MyApp({super.key, this.languages});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        FlutterNativeSplash.remove();
        print("Kết thúc init: ${DateTime.now()}");
        return GetMaterialApp(
          builder: EasyLoading.init(),
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          navigatorKey: Get.key,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          theme: themeController.darkTheme!
              ? themeController.darkColor == null
              ? dark()
              : dark(color: themeController.darkColor!)
              : themeController.lightColor == null
              ? light()
              : light(color: themeController.lightColor!),
          locale: localizeController.locale,
          translations: Messages(languages: languages),
          fallbackLocale: Locale(AppConstants.languages[0].languageCode,
              AppConstants.languages[0].countryCode),
          initialRoute: GetPlatform.isWeb
              ? RouteHelper.getInitialRoute()
              : RouteHelper.getSplashRoute(),
          getPages: RouteHelper.routes,
          // home: Home(),
          defaultTransition: Transition.topLevel,
          transitionDuration: const Duration(milliseconds: 250),
        );
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
