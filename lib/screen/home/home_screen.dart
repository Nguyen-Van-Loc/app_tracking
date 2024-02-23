import 'package:app_tracking/api/news_controller.dart';
import 'package:app_tracking/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  late NewsController newsController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(onScroll);
    newsController = Get.find<NewsController>();
  }

  void onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      newsController.loadMoveList();
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: HomeWidget(
      scrollController: _scrollController, newsController: newsController,
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
