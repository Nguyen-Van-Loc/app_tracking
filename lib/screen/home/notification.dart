import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/notifi.dart';
import 'package:app_tracking/helper/date_converter.dart';
import 'package:app_tracking/utils/color_resources.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/widgets/item_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  bool loading = false;
  List<Notifications>? _list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  void getNotification() async {
    setState(() {
      loading = true;
    });
    _list = await Get.find<AuthController>().getNotification();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notification".tr),
      ),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _list!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/notification_1.png",
                          width: 100,
                        ),
                        Text("don't_have_any_new_announcements_yet".tr)
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _list!.length,
                    itemBuilder: (context, index) {
                      final itemIndex = _list![_list!.length - 1 - index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 2,
                        child: InkWell(
                            onTap: () async {
                              print(itemIndex.id);
                              detailUser(itemIndex,false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Text("${itemIndex.title}",
                                        style: robotoRegular)),
                              ],
                            )),
                      );
                    },
                  ),
      ),
    );
  }

  Future<void> detailUser(Notifications item, bool status) async {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          color: Get.isDarkMode ? const Color(0xff7a7a7a) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text("notification".tr, style: roboto),
              ),
              const SizedBox(height: 20),
              buildInfoCard(
                status: status,
                title: "date".tr,
                field: DateConverter.isoStringToLocalDateOnly(item.date!),
              ),
              buildInfoCard(
                status: status,
                title: "content".tr,
                field: item.body!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
