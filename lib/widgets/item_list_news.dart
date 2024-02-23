import 'package:app_tracking/api/news_controller.dart';
import 'package:app_tracking/data/model/body/news.dart';
import 'package:app_tracking/utils/styles.dart';
import 'package:app_tracking/widgets/textflied_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/body/user.dart';
import '../data/repository/auth_repo.dart';
import '../helper/date_converter.dart';

class ItemListNew extends StatefulWidget {
  const ItemListNew(
      {super.key,
      this.itemIndex,
      required this.index,
      required this.commentsControllers,
      required this.showCommentsList,
      this.getListNews});

  final dynamic itemIndex;
  final int index;
  final List<TextEditingController> commentsControllers;
  final List<bool> showCommentsList;
  final Function()? getListNews;

  @override
  State<ItemListNew> createState() => _ItemListNewState();
}

class _ItemListNewState extends State<ItemListNew> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5,
          color: Get.isDarkMode ? Colors.black38 : Colors.grey.shade200,
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
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${widget.itemIndex.user!.displayName}",
                  style: robotoMedium,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text("${widget.itemIndex.content}"),
        ),
        // Container(
        //   height: 300,
        //   color: Colors.red,
        // ),
        InkWell(
          onTap: () {
            showLikeComment(widget.itemIndex, widget.index);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${widget.itemIndex.likes != null ? widget.itemIndex.likes!.length : 0} ${"likes".tr}"),
                Text(
                    "${widget.itemIndex.comments != null ? widget.itemIndex.comments!.length : 0} ${"comment".tr}"),
              ],
            ),
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 1,
            color: Get.isDarkMode ? Colors.grey.shade200 : Colors.black38),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  onLike(widget.itemIndex);
                },
                label: const Text("Thích"),
                icon: const Icon(Icons.favorite_border_outlined),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    widget.showCommentsList[widget.index] =
                        !widget.showCommentsList[widget.index];
                  });
                },
                label: const Text("Bình luận"),
                icon: const Icon(Icons.mode_comment_outlined),
              )
            ],
          ),
        ),
        if (widget.showCommentsList[widget.index])
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: InputTextField(
                  width: MediaQuery.of(context).size.width - 55,
                  heigth: 70,
                  text: false,
                  controller: widget.commentsControllers[widget.index],
                  hintText: "write_a_comment".tr,
                  onClear: () {
                    setState(() {
                      widget.commentsControllers[widget.index].clear();
                    });
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  onComment(widget.itemIndex, widget.index);
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
  }

  void onLike(News itemIndex) async {
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    Get.find<NewsController>().likesNews(News(
        id: itemIndex.id,
        content: itemIndex.content,
        date: formattedDate,
        user: User.fromJson(ad.body),
        comments: itemIndex.comments,
        media: itemIndex.media));
  }

  Future<void> onComment(News itemIndex, int index) async {
    Response ad = await Get.find<AuthRepo>().getCurrentUser();
    final formattedDate = DateConverter.localDateToIsoString(DateTime.now());
    Get.find<NewsController>().commentsNews(
        News(
            id: itemIndex.id,
            content: itemIndex.content,
            date: formattedDate,
            user: User.fromJson(ad.body),
            likes: itemIndex.likes,
            media: itemIndex.media),
        widget.commentsControllers[index].text);
    widget.showCommentsList[index] = false;
    widget.commentsControllers[index].clear();
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
                               index];
                          return itemListComment(item);
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

  Widget itemListComment(item) {
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
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode
                    ? const Color(0xffa4a4a4)
                    : const Color(0xffe7e7e7)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
  }
}
