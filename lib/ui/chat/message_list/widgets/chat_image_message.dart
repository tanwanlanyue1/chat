import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/photo_view_gallery_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

const heroTag = 'ChatImageMessage';

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
    return Size(
      imageContent.originalImageWidth.toDouble(),
      imageContent.originalImageHeight.toDouble(),
    );
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
    if(imageContent.fileLocalPath.isNotEmpty){
      return AppImage.file(
        File(imageContent.fileLocalPath),
        width: size.width,
        height: size.height,
        fit: BoxFit.cover,
        heroTag: heroTag,
      );
    }

    return buildNetworkImage(imageContent, size);
  }

  Widget buildNetworkImage(ZIMKitMessageImageContent imageContent, Size size) {
    return AppImage.network(
      imageContent.imageUrl,
      fit: BoxFit.cover,
      width: size.width,
      height: size.height,
      memCacheWidth: size.width,
      memCacheHeight: size.height,
      heroTag: heroTag,
    );
  }

  Widget buildImagePlaceholder(
      ZIMKitMessageImageContent imageContent, Size size) {
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
      imagePath = imageContent.imageUrl;
    }

    //查看大图
    PhotoViewGalleryPage.show(images: [imagePath], heroTag: heroTag);
  }
}

extension on ZIMKitMessageImageContent {
  String get imageUrl {
    if (largeImageDownloadUrl.startsWith('http')) {
      return largeImageDownloadUrl;
    }
    return fileDownloadUrl;
  }
}
