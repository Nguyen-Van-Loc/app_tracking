import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/helper/date_converter.dart';
import 'package:app_tracking/screen/home/articles_screen.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/widgets/item_list_news.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/body/news.dart';
import '../../data/model/body/user.dart';

class HomeScreenSection0 extends StatefulWidget {
  const HomeScreenSection0({Key? key}) : super(key: key);

  @override
  State<HomeScreenSection0> createState() => _HomeScreenSection0State();
}

class _HomeScreenSection0State extends State<HomeScreenSection0> {
  List<News>? newsList;
  bool loading = false, loadingMove = false;
  List<TextEditingController> commentsControllers = [];
  List<bool> showCommentsList = [];
  int page = 10;
  late ScrollController _scrollController;
  List<Comments>? latestComments;
  bool hasLoadedListNew = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getListNew();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoveList();
    }
  }

  void loadMoveList() async {
    setState(() {
      loadingMove = true;
    });
    try {
      final value = await Get.find<AuthController>().postListNews(page+=10);
      if (value == 200) {
        newsList = Get.find<AuthController>().listNews;
      } else {
        showSnackbar("Lỗi dữ liệu");
      }
    } catch (e) {
      showSnackbar("Error loading user data");
    }finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        loadingMove = false;
      });
    }
    showCommentsList = List.generate(newsList!.length, (index) => false);
    commentsControllers =
        List.generate(newsList!.length, (index) => TextEditingController());
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void getListNew() async {
    latestComments = [];
    loading = true;
    try {
      final value = await Get.find<AuthController>().postListNews(page);
      if (value == 200) {
        newsList = Get.find<AuthController>().listNews;
      } else {
        showSnackbar("Lỗi dữ liệu");
      }
    } catch (e) {
      showSnackbar("Error loading user data");
    } finally {
      setState(() {
        loading = false;
      });
    }
    showCommentsList = List.generate(newsList!.length, (index) => false);
    commentsControllers =
        List.generate(newsList!.length, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Get.to(const ArticlesScreen(),
                    transition: Transition.downToUp, fullscreenDialog: true);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: .5,
                        color: Get.isDarkMode
                            ? Colors.grey.shade200
                            : Colors.grey.shade600)),
                child: Text(
                  "how_are_you_today".tr,
                  style: robotoRegular,
                ),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: newsList!.length,
                        itemBuilder: (context, index) {
                          final itemIndex = newsList![index];
                          return ItemListNew(
                            itemIndex: itemIndex,
                            index: index,
                            commentsControllers: commentsControllers,
                            showCommentsList: showCommentsList,
                            getListNews: getListNew,
                          );
                        },
                      ),
                      loadingMove
                          ? const Center(child: CircularProgressIndicator())
                          : Container(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
          )),
        ],
      ),
    );
  }
}
