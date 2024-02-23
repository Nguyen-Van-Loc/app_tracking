import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/api/list_user_controller.dart';
import 'package:app_tracking/api/user_controller.dart';
import 'package:app_tracking/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfEmployeeScreen extends StatefulWidget {
  const ListOfEmployeeScreen({super.key});

  @override
  State<ListOfEmployeeScreen> createState() => ListOfEmployeeScreenState();
}

class ListOfEmployeeScreenState extends State<ListOfEmployeeScreen> {
  late ListUserController listUserController;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    listUserController = Get.find<ListUserController>();
    listUserController.getListUser();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      listUserController.loadMoveList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list_user".tr),
      ),
      body: SafeArea(
        child: GetBuilder<ListUserController>(
          builder: (controller) {
            if (controller.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                     ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listUserController.listUser!.length,
                        itemBuilder: (context, index) {
                          final itemIndex = listUserController.listUser![index];
                          return GetBuilder<UserController>(
                            builder: (controller) {
                              return itemIndex.roles![0].id == 3
                                  ? const SizedBox.shrink()
                                  : UserCard(
                                      user: itemIndex,
                                      controller: controller,
                                      getList: () {
                                        listUserController.getListUser();
                                      },
                                    );
                            },
                          );
                        },
                      ),
                    if (controller.loadMove)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
