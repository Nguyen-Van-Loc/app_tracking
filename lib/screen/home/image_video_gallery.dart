import 'dart:io';

import 'package:app_tracking/view/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickPage extends StatefulWidget {
  const ImagePickPage({Key? key, required this.multiple}) : super(key: key);
  final bool multiple;

  @override
  State<ImagePickPage> createState() => _ImagePickPageState();
}

class _ImagePickPageState extends State<ImagePickPage> {
  List<Widget> imageList = [];
  int curentPage = 0;
  int? lastPage;
  Set<AssetEntity> selectedImages = {};
  final ImageLoader imageLoader = ImageLoader();

  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= 0.33) return;
    if (curentPage == lastPage) return;
    fetchAllImage();
  }

  fetchAllImage() async {
    List<Widget> images = await imageLoader.fetchAllImage(
        curentPage: curentPage,
        lastPage: lastPage,
        selectedImages: selectedImages,
        handleScrollEvent: handleScrollEvent,
        toggleSelection: toggleSelection,
        multiple: widget.multiple);
    setState(() {
      imageList.addAll(images);
      curentPage++;
    });
  }

  void toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectedImages.contains(asset)) {
        selectedImages.remove(asset);
      } else {
        selectedImages.add(asset);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllImage();
  }

  Future<File> convertAssetToFile(AssetEntity asset) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${asset.title}';
    final file = File(filePath);
    if (await file.exists()) {
      return file;
    }
    final uint8List = await asset.originBytes;
    await file.writeAsBytes(uint8List!);
    return file;
  }

  void convertSelectedImagesToUint8List() async {
    if (!widget.multiple && selectedImages.isNotEmpty) {
      AssetEntity asset = selectedImages.first;
      File file = await convertAssetToFile(asset);
      Navigator.pop(context, file);
    } else if (widget.multiple) {
      List<File> selectedImageFiles = [];
      for (AssetEntity asset in selectedImages) {
        File file = await convertAssetToFile(asset);
        selectedImageFiles.add(file);
      }
      Navigator.pop(context, selectedImageFiles);
    } else {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("library".tr),
        actions: [
          IconButton(
            onPressed: selectedImages.isEmpty
                ? null
                : () {
                    convertSelectedImagesToUint8List();
                  },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            handleScrollEvent(scroll);
            return true;
          },
          child: GridView.builder(
            itemCount: imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return imageList[index];
            },
          ),
        ),
      ),
    );
  }
}

class ImageLoader {
  Future<List<Widget>> fetchAllImage({
    required int curentPage,
    required bool multiple,
    required int? lastPage,
    required Set<AssetEntity> selectedImages,
    required Function(ScrollNotification) handleScrollEvent,
    required Function(AssetEntity) toggleSelection,
  }) async {
    lastPage = curentPage;
    final permission1 = await Permission.storage.isDenied;
    !permission1
        ? buildNoPhotosFoundWidget()
        : await Permission.storage.request();
    List<AssetPathEntity> album = await PhotoManager.getAssetPathList(
      type: RequestType.all,
      onlyAll: true,
    );
    if (album.isEmpty) {
      return [buildNoPhotosFoundWidget()];
    } else {
      List<AssetEntity> photos =
          await album[0].getAssetListPaged(page: curentPage, size: 24);
      List<Widget> temp = [];
      for (var asset in photos) {
        temp.add(
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ImageWidget(
                  asset: asset,
                  imageData: snapshot.data as Uint8List,
                  selectedImages: selectedImages,
                  toggleSelection: toggleSelection,
                  multiple: multiple,
                );
              }
              return const SizedBox();
            },
            future: asset.thumbnailDataWithSize(
              const ThumbnailSize(200, 200),
            ),
          ),
        );
      }
      return temp;
    }
  }

  Widget buildNoPhotosFoundWidget() {
    return const Center(
      child: Text(
        'No photos found on this device.',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  final AssetEntity asset;
  final Uint8List imageData;
  final Set<AssetEntity> selectedImages;
  final Function(AssetEntity) toggleSelection;
  final bool multiple;

  const ImageWidget({
    Key? key,
    required this.asset,
    required this.imageData,
    required this.selectedImages,
    required this.toggleSelection,
    required this.multiple,
  }) : super(key: key);

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selectedImages.contains(widget.asset);
    bool isVideo = widget.asset.type == AssetType.video;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                widget.toggleSelection(widget.asset);
              });
            },
            borderRadius: BorderRadius.circular(5),
            splashFactory: NoSplash.splashFactory,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2.0,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(widget.imageData),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: CustomCheckbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  widget.toggleSelection(widget.asset);
                });
              },
            ),
          ),
          if (isVideo)
            const Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.video_camera_back_outlined,
                color: Colors.white,
              ),
            ),
          if (!isVideo)
            const Positioned(
              bottom: 4,
              right: 4,
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
