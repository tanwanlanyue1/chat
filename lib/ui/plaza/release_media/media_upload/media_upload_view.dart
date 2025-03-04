import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_uploader.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/video_editor_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

import 'media_list_tile.dart';
import 'video_cover_page.dart';
import 'video_preview_page.dart';

///图片+视频上传控件
class MediaUploadView extends StatefulWidget {

  ///上传管理器
  final MediaUploader uploader;

  ///选中的文件列表变化回调
  final void Function(List<MediaItem> items)? onChanged;

  const MediaUploadView({
    super.key,
    required this.uploader,
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
        mainAxisSpacing: 8.rpx,
        crossAxisSpacing: 8.rpx,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (visibleAddItem) buildAddItem(),
          ...dataList.map((item) {
            return MediaListTile(
              mediaUploader: widget.uploader,
              item: item,
              itemSize: itemSize,
              onTap: () => onTapItem(item),
              onTapDelete: () => onTapDeleteItem(item),
              onTapEdit: () => onTapEditVideoItem(item),
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
      width: itemSize,
      height: itemSize,
      backgroundColor: AppColor.black9.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8.rpx),
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
        'assets/images/plaza/ic_plus.png',
        size: 24.rpx,
      ),
    );
  }

  void addImages(List<XFile> files) async {
    if (files.isEmpty) {
      return;
    }
    var list = List.of(dataList);
    if (isVideo) {
      isVideo = false;
      widget.uploader.cancelAll();
      deleteCacheFiles(list);
      list.clear();
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
    widget.uploader.uploads(items);
  }

  void addVideo(File file) async {
    isVideo = true;
    widget.uploader.cancelAll();
    deleteCacheFiles(dataList);

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
    widget.uploader.uploads([videoItem]);
  }

  void onTapDeleteItem(MediaItem item) {
    setState(() {
      widget.uploader.cancel(item.uuid);
      dataList.remove(item);
      deleteCacheFiles([item]);
    });
  }

  void onTapEditVideoItem(final MediaItem item) {
    if (item is VideoItem) {
      Get.bottomSheet(
        CommonBottomSheet(
          titles: ['选封面', '预览', '删除'],
          onTap: (index) async {
            switch (index) {
              case 0:
                chooseVideoCover(item);
                break;
              case 1:
                VideoPreviewPage.open(item);
                break;
              case 2:
                onTapDeleteItem(item);
                break;
            }
          },
        ),
      );
    }
  }

  void onTapItem(MediaItem item) {
    if (item.isVideo) {
      VideoPreviewPage.open(item as VideoItem);
    } else {
      var initIndex = 0;
      final images = dataList.mapIndexed((index, element) {
        if (item.uuid == element.uuid) {
          initIndex = index;
        }
        if (element.local != null) {
          return element.local ?? '';
        } else {
          return element.remote ?? '';
        }
      }).toList();
      PhotoViewGalleryPage.show(
        images: images,
        index: initIndex,
        heroTag: MediaListTile.heroTag,
      );
    }
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
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (result != null) {
      final file = await VideoEditorPage.open(file: File(result.path));
      if (file != null) {
        addVideo(file);
      } else {
        //删除临时文件
        File(result.path).delete().ignore();
      }
    }
  }

  ///选择视频封面
  void chooseVideoCover(VideoItem item) async {
    final result = await VideoCoverPage.open(file: File(item.local ?? ''));
    if (result != null) {
      //删除原来的封面图片缓存
      deleteCacheFiles([item.cover]);
      item.cover.local = result.path;
      item.cover.remote = null;
      widget.uploader
        ..cancel(item.cover.uuid)
        ..uploads([item]);
      //刷新ui
      setState(() {});
    }
  }

  ///删除缓存文件
  Future<void> deleteCacheFiles(List<MediaItem> items) async {
    for (var element in items) {
      final file = element.local?.let(File.new);
      if (file != null && await file.exists()) {
        file.delete().ignore();
      }
      if (element is VideoItem) {
        await deleteCacheFiles([element.cover]);
      }
    }
  }

  @override
  void dispose() {
    //删除所有图片缓存
    deleteCacheFiles(dataList);
    super.dispose();
  }
}

class ImageItem extends MediaItem {
  ImageItem({
    required super.uuid,
    super.local,
    super.remote,
  }) : super(isVideo: false);
}

class VideoItem extends MediaItem {
  final ImageItem cover;
  final Duration duration;

  VideoItem({
    required this.cover,
    required this.duration,
    required super.uuid,
    super.local,
    super.remote,
  }) : super(isVideo: true);
}

abstract class MediaItem {
  final String uuid;
  final bool isVideo;
  String? local;
  String? remote;

  MediaItem({
    required this.isVideo,
    required this.uuid,
    this.local,
    this.remote,
  });
}
