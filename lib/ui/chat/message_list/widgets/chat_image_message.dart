import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatImageMessage extends StatelessWidget {
  const ChatImageMessage({
    super.key,
    required this.message,
    this.onPressed,
    this.onLongPress,
  });

  final ZIMKitMessage message;

  final void Function(
    BuildContext context,
    ZIMKitMessage message,
    Function defaultAction,
  )? onPressed;

  final void Function(
    BuildContext context,
    LongPressStartDetails details,
    ZIMKitMessage message,
    Function defaultAction,
  )? onLongPress;

  ///获取图片原始大小(px)
  Size getOriginalPixelSize() {
    final imageContent = message.imageContent!;
    var size = Size(
      imageContent.originalImageWidth.toDouble(),
      imageContent.originalImageHeight.toDouble(),
    );
    if (!size.isEmpty) {
      return size;
    }
    //图片发送中，ZIMKitMessageImageContent没有图片尺寸信息，需从本地扩展字段中获取原始宽高
    final extData = message.zim.localExtendedData;
    if (extData.isNotEmpty) {
      try {
        final data = jsonDecode(extData);
        if (data is Map) {
          size = Size(
            double.tryParse("${data['width']}") ?? 0,
            double.tryParse("${data['height']}") ?? 0,
          );
          if (!size.isEmpty) {
            imageContent.originalImageWidth = size.width.toInt();
            imageContent.originalImageHeight = size.height.toInt();
          }
        }
      } catch (ex) {
        //e
      }
    }
    return size;
  }

  ///获取图片最佳显示大小
  Size getBestDisplaySize() {
    final originSize = getOriginalPixelSize();
    final constraints = BoxConstraints(
      minWidth: 60.rpx,
      minHeight: 60.rpx,
      maxWidth: Get.width * 0.6,
      maxHeight: Get.width * 0.6,
    );
    if (originSize.isEmpty) {
      return constraints.smallest;
    }
    return constraints.constrainSizeAndAttemptToPreserveAspectRatio(originSize);
  }

  @override
  Widget build(BuildContext context) {
    final imageContent = message.imageContent!;
    final displaySize = getBestDisplaySize();
    return Flexible(
      child: GestureDetector(
        onTap: () async {
          onPressed?.call(
            context,
            message,
            () {},
          );
          showPhotoView();
        },
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.rpx),
          child: message.isMine
              ? FutureBuilder(
                  future: File(imageContent.fileLocalPath).exists(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return buildNetworkImage(imageContent, displaySize);
                    }
                    if (snapshot.hasData) {
                      return buildLocalImage(imageContent, displaySize);
                    }
                    //placeholder
                    return buildImagePlaceholder(imageContent, displaySize);
                  },
                )
              : buildNetworkImage(imageContent, displaySize),
        ),
      ),
    );
  }

  Widget buildLocalImage(ZIMKitMessageImageContent imageContent, Size size) {
    return Image.file(
      File(imageContent.fileLocalPath),
      width: size.width,
      height: size.height,
      cacheWidth: (size.width * Get.pixelRatio).floor(),
      cacheHeight: (size.height * Get.pixelRatio).floor(),
      fit: BoxFit.cover,
    );
  }

  Widget buildNetworkImage(ZIMKitMessageImageContent imageContent, Size size) {
    return AppImage.network(
      message.isNetworkUrl
          ? imageContent.fileDownloadUrl
          : imageContent.largeImageDownloadUrl,
      fit: BoxFit.cover,
      width: size.width,
      height: size.height,
      memCacheWidth: size.width,
      memCacheHeight: size.height,
    );
  }

  Widget buildImagePlaceholder(ZIMKitMessageImageContent imageContent, Size size) {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
    );
  }


  void showPhotoView() async {
    final imageContent = message.imageContent;
    if (imageContent == null) {
      return;
    }

    final hasLocalFile = await File(imageContent.fileLocalPath).exists();
    var imagePath = imageContent.fileLocalPath;
    if (!hasLocalFile) {
      imagePath = message.isNetworkUrl
          ? imageContent.fileDownloadUrl
          : imageContent.largeImageDownloadUrl;
    }

    //查看大图
    PhotoViewGalleryPage.show(
      Get.context!,
      PhotoViewGalleryPage(
        images: [imagePath],
        index: 0,
        heroTag: '',
      ),
    );
  }
}
