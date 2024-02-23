import 'package:app_tracking/screen/home/articles_screen.dart';
import 'package:app_tracking/widgets/item_list_news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/news_controller.dart';
import '../utils/styles.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget(
      {super.key,
      required this.scrollController,
      required this.newsController});

  final ScrollController scrollController;
  final NewsController newsController;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
            controller: widget.scrollController,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.newsController.listNews!.length,
                  itemBuilder: (context, index) {
                    final itemIndex = widget.newsController.listNews![index];
                    return ItemListNew(
                      itemIndex: itemIndex,
                      index: index,
                      commentsControllers:
                          Get.find<NewsController>().commentsControllers,
                      showCommentsList:
                          Get.find<NewsController>().showCommentsList,
                      getListNews: widget.newsController.getListNew,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
