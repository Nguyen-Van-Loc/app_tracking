import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/helper/date_converter.dart';
import 'package:app_tracking/utils/color_resources.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Tracking_List extends StatefulWidget {
  const Tracking_List({super.key});

  @override
  State<Tracking_List> createState() => _Tracking_ListState();
}

class _Tracking_ListState extends State<Tracking_List> {
  List<dynamic> user = [];
  bool loading = false;
  final contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataTracking();
  }
  void getDataTracking() async {
    loading = true;
    Response ad = await Get.find<AuthRepo>().getTracking();
    setState(() {
      user = ad.body;
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("tracking_list".tr),
          actions: [
            MaterialButton(
              onPressed: () {
                showDialog(null, true);
              },
              minWidth: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 25,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: user.length,
                    itemBuilder: (context, index) {
                      final itemIndex = user[user.length - 1 - index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 2,
                        child: InkWell(
                            onTap: () async {
                              showDialog(itemIndex, false);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        child: Text(
                                            "${"update_day".tr}: ${DateConverter.isoStringToLocalDateOnly(itemIndex["date"])}",
                                            style: robotoRegular)),
                                    MaterialButton(
                                        padding: const EdgeInsets.all(5),
                                        minWidth: 0,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onPressed: () {
                                          Get.defaultDialog(
                                              onConfirm: () async {
                                                 await Get.find<AuthRepo>().deleteTracking(itemIndex["id"]);
                                                 getDataTracking();
                                                 Get.back();
                                                 snackbarSuccess("tracking_removed_successfully".tr);
                                              },
                                              title: "notification".tr,
                                              titleStyle: roboto,
                                              textConfirm: "confirm_to".tr,
                                              textCancel: "cancel".tr,
                                              content: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                      "are_you_sure_you_want_to_delete_this_tracking"
                                                          .tr)));
                                        },
                                        child: Icon(Icons.delete,
                                            color: ColorResources.redColor))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Text("content".tr),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      margin: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Text(itemIndex["content"],
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  )));
  }

  Future<dynamic> showDialog(item, bool check) {
    check
        ? contentController.clear()
        : contentController.text = item["content"];
    return Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: 20),
        title: check ? "add_tracking".tr : "update_tracking".tr,
        content: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: InputTextField(
                text: true,
                controller: contentController,
                width: MediaQuery.of(context).size.width - 20,
                hintText: "content".tr,
                onClear: () => contentController.clear(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                check? onSave() : onEdit(item);
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 13)),
              child: check
                  ? Text(
                      "add".tr,
                      style: robotoRegular,
                    )
                  : Text(
                      "update".tr,
                      style: robotoRegular,
                    ),
            )
          ],
        ));
  }
  void onSave() async {
    EasyLoading.show(status: "loading...");
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    if (isEmpty(contentController.text, "content".tr)) {
      EasyLoading.dismiss();
      return;
    }
    await Get.find<AuthRepo>().saveTracking(ad.body!, contentController.text);
    EasyLoading.dismiss();
    getDataTracking();
    Get.back();
    snackbarSuccess("tracking_added_successfully".tr);

  }
  void onEdit(item) async {
    EasyLoading.show(status: "loading...");
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    if (isEmpty(contentController.text, "content".tr)) {
      EasyLoading.dismiss();
      return;
    }
    await Get.find<AuthRepo>().updateTracking(ad.body!, contentController.text,item["id"]);
    EasyLoading.dismiss();
    getDataTracking();
    Get.back();
    snackbarSuccess("tracking_updated_successfully".tr);
  }
}
