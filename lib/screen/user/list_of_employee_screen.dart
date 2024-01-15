import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/model/body/user.dart';
import 'package:app_tracking/view/custom_snackbar.dart';
import 'package:app_tracking/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfEmployeeScreen extends StatefulWidget {
  const ListOfEmployeeScreen({super.key});

  @override
  State<ListOfEmployeeScreen> createState() => ListOfEmployeeScreenState();
}

class ListOfEmployeeScreenState extends State<ListOfEmployeeScreen> {
  List<User>? listUser;
  bool loading = false;
  int page = 20;
  bool loadingMove = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getListUser();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoveList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("list_user".tr),
      ),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  final itemIndex = listUser![index];
                  return GetBuilder<AuthController>(
                    builder: (controller) {
                      return itemIndex.roles![0].id == 3
                          ? const SizedBox.shrink()
                          : UserCard(
                              user: itemIndex,
                              controller: controller,
                              getList: () {
                                getListUser();
                              },
                            );
                    },
                  );
                },
                itemCount: listUser!.length),
      ),
    );
  }

  void loadMoveList() async {
    setState(() {
      loadingMove = true;
    });
    try {
      final value = await Get.find<AuthController>().postListUser(page += page);
      if (value == 200) {
        listUser = Get.find<AuthController>().listUser;
      } else {
        snackbarError("Error data");
      }
    } catch (e) {
      snackbarError("Error loading more data");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void getListUser() async {
    loading = true;
    try {
      final value = await Get.find<AuthController>().postListUser(page);
      if (value == 200) {
        listUser = Get.find<AuthController>().listUser;
      } else {
        snackbarError("Error data");
      }
    } catch (e) {
      snackbarError("Error loading more data");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
