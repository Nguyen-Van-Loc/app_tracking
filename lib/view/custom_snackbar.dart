import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/responsive_helper.dart';
import '../utils/dimensions.dart';
import '../utils/styles.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  if(message.isNotEmpty) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.PADDING_SIZE_SMALL,
        top: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL, left: Dimensions.PADDING_SIZE_SMALL,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      content: Text(message, style: robotoMedium.copyWith(color: Colors.white)),
    ));
  }
}
void snackbarSuccess (String title) {
  Get.snackbar(
    'notification'.tr,
    title,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    borderRadius: 10,
  );
}
void snackbarError (String title) {
  Get.snackbar(
    'error'.tr,
    title + "failed".tr,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 10,
  );
}
void snackbarFailed (String title) {
  Get.snackbar(
    'error'.tr,
    title.tr,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 10,
  );
}
bool isEmpty(String value, String fieldName) {
  if (value.isEmpty) {
    snackbarFailed("$fieldName ${"cannot_be_empty".tr}");
    return true;
  }
  return false;
}
bool isEmptyEmail(String value, String fieldName) {
  final emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );
  if (!emailRegex.hasMatch(value)) {
    snackbarFailed("$fieldName ${"invalid".tr}");
    return true;
  }
  return false;
}

bool isEmptyPassword(String value, String fieldName) {
  if (value.length < 6) {
    snackbarFailed("$fieldName ${"there_must_be_at_least_6_characters".tr}");
    return true;
  }
  return false;
}

bool isPasswordMatch(String password, String confirmPassword) {
  if (password != confirmPassword) {
    snackbarFailed('Mật khẩu nhập lại không khớp');
    return false;
  }
  return true;
}
void showSnackbar(String message ,context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
}