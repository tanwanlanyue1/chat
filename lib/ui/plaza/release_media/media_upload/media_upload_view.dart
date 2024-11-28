import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_uploader.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import 'media_item.dart';
import 'media_list_tile.dart';

///图片+视频上传控件
class MediaUploadView extends StatefulWidget {

  ///选中的文件列表变化回调
  final void Function(List<MediaItem> items)? onChanged;

  const MediaUploadView({
    super.key,
    this.onChanged,
  });

  @override
  State<MediaUploadView> createState() => _MediaUploadViewState();
}

class _MediaUploadViewState extends State<MediaUploadView> {
  static const imageLimit = 9;
  var isVideo = false;
  final dataList = <MediaItem>[];
  var itemSize = 80.rpx;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final visibleAddItem =
        isVideo ? dataList.isEmpty : dataList.length < imageLimit;
    return LayoutBuilder(builder: (_, size) {
      itemSize = size.maxWidth / 3;
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (visibleAddItem) buildAddItem(),
          ...dataList.map((item) {
            return MediaListTile(
              item: item,
              itemSize: itemSize,
              onTapDelete: () => onTapDeleteItem(item),
            );
          }),
        ],
      );
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.onChanged?.call(List.of(dataList));
  }

  Widget buildAddItem() {
    return Button.icon(
      onPressed: () {
        Get.bottomSheet(
          CommonBottomSheet(
            titles: const ['拍照', '选择图片', '选择视频'],
            onTap: (index) {
              switch (index) {
                case 0:
                  takePhoto();
                  break;
                case 1:
                  chooseImage();
                  break;
                case 2:
                  chooseVideo();
                  break;
              }
            },
          ),
        );
      },
      icon: AppImage.asset(
        'assets/images/mine/add_image.png',
        size: itemSize,
      ),
    );
  }

  void addImages(List<XFile> files) async {
    if (files.isEmpty) {
      return;
    }
    var list = List.of(dataList);
    if (isVideo) {
      list.clear();
      isVideo = false;
      MediaUploader().cancelAll();
    }
    final items = files
        .take(imageLimit - list.length)
        .map((e) => ImageItem(
              uuid: const Uuid().v4(),
              local: e.path,
            ))
        .toList();
    list.addAll(items);

    //刷新UI
    setState(() {
      dataList
        ..clear()
        ..addAll(list);
    });

    //开始下载
    MediaUploader().uploads(items);
  }

  void addVideo(XFile file) async {
    isVideo = true;
    MediaUploader().cancelAll();

    //获取视频首帧图片缩略图和时长
    Loading.show();
    final info = await VideoCompress.getMediaInfo(file.path);
    final thumb = await VideoCompress.getFileThumbnail(file.path);
    Loading.dismiss();

    final videoItem = VideoItem(
        uuid: const Uuid().v4(),
        local: file.path,
        duration: Duration(milliseconds: info.duration?.toInt() ?? 0),
        cover: ImageItem(
          uuid: const Uuid().v4(),
          local: thumb.path,
        ));

    //刷新UI
    setState(() {
      dataList
        ..clear()
        ..add(videoItem);
    });

    //开始下载
    MediaUploader().uploads([videoItem]);
  }

  void onTapDeleteItem(MediaItem item) {
    MediaUploader().cancel(item.uuid);
    setState(() {
      dataList.remove(item);
    });
  }

  void takePhoto() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1920,
      imageQuality: 90,
    );
    if (result != null) {
      addImages([result]);
    }
  }

  void chooseImage() async {
    final results = await ImagePicker().pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1920,
      imageQuality: 90,
      limit: isVideo ? imageLimit : imageLimit - dataList.length,
    );
    addImages(results);
  }

  void chooseVideo() async {
    final result = await ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 5));
    if (result != null) {
      addVideo(result);
    }
  }
}
