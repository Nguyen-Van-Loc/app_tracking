import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/api/api_client.dart';
import '../data/model/body/user.dart';
import '../view/custom_snackbar.dart';

class UserController extends GetxController implements GetxService {
  final AuthRepo repo;
  bool _loading = false;
  String image = "";

  bool get loading => _loading;
  User _user = User();

  User get user => _user;

  UserController({required this.repo});

  Future<int> getCurrentUser() async {
    Response response = await repo.getCurrentUser();
    if (response.statusCode == 200) {
      _user = User.fromJson(response.body);
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }

  Future<int> postImage(List<MultipartBody> imageList) async {
    _loading = true;
    Response response = await repo.postImage(imageList);
    if (response.statusCode == 200) {
      print(response.body);
      EasyLoading.dismiss();
      snackbarSuccess("posted_successfully".tr);
    } else {
      ApiChecker.checkApi(response);
    }
    _loading = false;
    return response.statusCode!;
  }

  Future<int> getImageFile() async {
    Response response = await repo.getImage();
    if (response.statusCode == 200) {
      image = response.body;
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }
}
