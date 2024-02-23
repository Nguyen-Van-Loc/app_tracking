import 'package:app_tracking/api/localization_controller.dart';
import 'package:app_tracking/theme/theme_controller.dart';
import 'package:app_tracking/utils/app_constants.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// ignore: camel_case_types
class Custom_list extends StatelessWidget {
  final Function()? onPressed;
  final bool? transparent;
  final double? padingvh;
  final double? padinghr;
  final double? radius;
  final IconData? icon;
  final IconData? iconsux;
  final String? textTile;

  const Custom_list({
    super.key,
    this.onPressed,
    this.transparent,
    this.radius,
    this.icon,
    this.textTile,
    this.iconsux,
    this.padinghr,
    this.padingvh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        child: InkWell(
          onTap: textTile == "language"
              ? () {
            _showPopupMenu(
                  (index) {
                Get.find<LocalizationController>().setLanguage(Locale(
                  AppConstants.languages[index].languageCode,
                  AppConstants.languages[index].countryCode,
                ));
              },
              context,
            );
          }
              : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              border: Border.all(width: 0.7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 10),
                    Text(
                      textTile!.tr,
                      style: robotoMedium,
                    ),
                  ],
                ),
                textTile == "language"
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<LocalizationController>(
                      builder: (controller) {
                        return Text(
                          controller.locale.languageCode == 'vi'
                              ? 'lang_vi'.tr
                              : 'lang_en'.tr,
                          style: const TextStyle(color: Colors.grey),
                        );
                      },
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                )
                    : textTile == "regime"
                    ? GetBuilder<ThemeController>(
                  builder: (controller) {
                    return Switch(
                      thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Icon(Icons.dark_mode);
                          }
                          return const Icon(Icons.light_mode);
                        },
                      ),
                      value: controller.darkTheme ?? false,
                      onChanged: (bool value) {
                        controller.toggleTheme();
                      },
                    );
                  },
                )
                    : Icon(iconsux),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopupMenu(Function(int) onTap, BuildContext context) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(120, 550, 30, 100),
      items: [
        PopupMenuItem(
          value: 'lang_vi',
          onTap: () => onTap(0),
          child: Text('lang_vi'.tr),
        ),
        PopupMenuItem(
          value: 'lang_en',
          onTap: () => onTap(1),
          child: Text("lang_en".tr),
        ),
      ],
      elevation: 8.0,
    );
  }
}
