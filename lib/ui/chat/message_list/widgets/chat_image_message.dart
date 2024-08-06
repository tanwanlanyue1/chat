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

  @override
  Widget build(BuildContext context) {
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
        child: AspectRatio(
          aspectRatio: message.imageContent!.aspectRatio,
          child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
            final cacheWidth =
                constraints.maxWidth * Get.mediaQuery.devicePixelRatio;
            final cacheHeight =
                constraints.maxHeight * Get.mediaQuery.devicePixelRatio;

            return ClipRRect(
              borderRadius: BorderRadius.circular(8.rpx),
              child: message.isMine
                  ? FutureBuilder(
                      future:
                          File(message.imageContent!.fileLocalPath).exists(),
                      builder: (context, snapshot) {
                        return snapshot.hasData && snapshot.data!
                            ? Image.file(
                                File(message.imageContent!.fileLocalPath),
                                cacheHeight: cacheHeight.floor(),
                                cacheWidth: cacheWidth.floor(),
                              )
                            : AppImage.network(
                                message.isNetworkUrl
                                    ? message.imageContent!.fileDownloadUrl
                                    : message
                                        .imageContent!.largeImageDownloadUrl,
                                fit: BoxFit.cover,
                                memCacheHeight: cacheHeight,
                                memCacheWidth: cacheWidth,
                              );
                      },
                    )
                  : AppImage.network(
                      message.isNetworkUrl
                          ? message.imageContent!.fileDownloadUrl
                          : message.imageContent!.largeImageDownloadUrl,
                      fit: BoxFit.cover,
                      memCacheHeight: cacheHeight,
                      memCacheWidth: cacheWidth,
                    ),
            );
          }),
        ),
      ),
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
