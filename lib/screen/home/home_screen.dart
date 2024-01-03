import 'package:app_tracking/api/auth_controller.dart';
import 'package:app_tracking/data/repository/auth_repo.dart';
import 'package:app_tracking/helper/date_converter.dart';
import 'package:app_tracking/screen/home/articles_screen.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    newsList = await Get.find<AuthController>().postListNews(page += page);
    if (newsList != null) {
      setState(() {
        loadingMove = false;
      });
    }
    setState(() {
      loadingMove = false;
    });
    showCommentsList = List.generate(newsList!.length, (index) => false);
    commentsControllers =
        List.generate(newsList!.length, (index) => TextEditingController());
  }

  void getListNew() async {
      latestComments = [];
      loading = true;
      newsList = await Get.find<AuthController>().postListNews(page);
      if (newsList == null) {
        return;
      }
      setState(() {
        loading = false;
      });
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
                Get.to(const Create_Articles(),
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 5,
                                color: Get.isDarkMode
                                    ? Colors.black38
                                    : Colors.grey.shade200,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.green,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        "${itemIndex.user!.displayName}",
                                        style: robotoMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text("${itemIndex.content}"),
                              ),
                              // Container(
                              //   height: 300,
                              //   color: Colors.red,
                              // ),
                              InkWell(
                                onTap: () {
                                  showLikeComment(itemIndex, index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${itemIndex.likes != null ? itemIndex.likes!.length : 0} ${"likes".tr}"),
                                      Text(
                                          "${itemIndex.comments != null ? itemIndex.comments!.length : 0} ${"comment".tr}"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 1,
                                  color: Get.isDarkMode
                                      ? Colors.grey.shade200
                                      : Colors.black38),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        onLike(itemIndex);
                                      },
                                      label: const Text("Thích"),
                                      icon: const Icon(
                                          Icons.favorite_border_outlined),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          showCommentsList[index] =
                                              !showCommentsList[index];
                                        });
                                      },
                                      label: const Text("Bình luận"),
                                      icon: const Icon(
                                          Icons.mode_comment_outlined),
                                    )
                                  ],
                                ),
                              ),
                              if (showCommentsList[index])
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: InputTextField(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                55,
                                        heigth: 70,
                                        text: false,
                                        controller: commentsControllers[index],
                                        hintText: "write_a_comment".tr,
                                        onClear: () {
                                          setState(() {
                                            commentsControllers[index].clear();
                                          });
                                        },
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        onComment(itemIndex, index);
                                      },
                                      minWidth: 0,
                                      padding: EdgeInsets.zero,
                                      child: const Icon(Icons.send),
                                    )
                                  ],
                                )
                              else
                                Container()
                            ],
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

  void onLike(News itemIndex) async {
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    Get.find<AuthController>().likesNews(News(
        id: itemIndex.id,
        content: itemIndex.content,
        date: formattedDate,
        user: User.fromJson(ad.body),
        comments: itemIndex.comments,
        media: itemIndex.media));
    getListNew();
  }

  Future<void> onComment(News itemIndex, int index) async {
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    Get.find<AuthController>().commentsNews(
        News(
            id: itemIndex.id,
            content: itemIndex.content,
            date: formattedDate,
            user: User.fromJson(ad.body),
            likes: itemIndex.likes,
            media: itemIndex.media),
        commentsControllers[index].text);
    showCommentsList[index] = false;
    getListNew();
  }

  Future showLikeComment(News itemIndex, int index) {
    return Get.bottomSheet(
        backgroundColor:
            Get.isDarkMode ? const Color(0xff7a7a7a) : Colors.white,
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${itemIndex.likes!.length}"),
                      const Icon(
                        Icons.favorite_outlined,
                        color: Colors.pinkAccent,
                      )
                    ],
                  ),
                  MaterialButton(
                    minWidth: 0,
                    shape: const CircleBorder(),
                    onPressed: () {
                      onLike(itemIndex);
                    },
                    child: const Icon(Icons.favorite_border_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: itemIndex.comments == null
                    ? const Center(
                        child: Text("Bài viết chưa có bình luận nào ?"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemIndex.comments!.length,
                        itemBuilder: (context, index) {
                          final item = itemIndex.comments![
                              itemIndex.comments!.length - 1 - index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.green,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      left: 5, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Get.isDarkMode
                                          ? const Color(0xffa4a4a4)
                                          : const Color(0xffe7e7e7)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.user!.displayName}",
                                        style: robotoBold,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${item.content}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 5.0),
            //       child: InputTextField(
            //         width:
            //         MediaQuery.of(context).size.width -
            //             55,
            //         heigth: 70,
            //         text: false,
            //         controller: commentsControllers[index],
            //         hintText: "write_a_comment".tr,
            //         onClear: () {
            //           setState(() {
            //             commentsControllers[index].clear();
            //           });
            //         },
            //       ),
            //     ),
            //     MaterialButton(
            //       onPressed: ()async {
            //         await onComment(itemIndex, index);
            //         commentsControllers[index].clear();
            //         FocusScope.of(context).requestFocus(FocusNode());
            //       },
            //       minWidth: 0,
            //       padding: EdgeInsets.zero,
            //       child: const Icon(Icons.send),
            //     )
            //   ],
            // )
          ],
        ));
  }
}
