import 'package:app_tracking/api/auth_controller.dart';
import 'package:get/get.dart';
import '../../helper/route_helper.dart';
import '../../view/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.find<AuthController>().clearData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      showCustomSnackBar(response.statusText ?? "error");
    }
  }
}
