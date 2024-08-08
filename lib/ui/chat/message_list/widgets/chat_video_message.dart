import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:zego_zimkit/src/services/services.dart';

import 'chat_video_message_player.dart';

class ChatVideoMessage extends StatelessWidget {
  const ChatVideoMessage({
    super.key,
    this.onPressed,
    this.onLongPress,
    required this.message,
  });

  final ZIMKitMessage message;
  final void Function(
          BuildContext context, ZIMKitMessage message, Function defaultAction)?
      onPressed;
  final void Function(BuildContext context, LongPressStartDetails details,
      ZIMKitMessage message, Function defaultAction)? onLongPress;

  void _onPressed(BuildContext context, ZIMKitMessage msg) {
    void defaultAction() => playVideo(context);
    if (onPressed != null) {
      onPressed!.call(context, msg, defaultAction);
    } else {
      defaultAction();
    }
  }

  void _onLongPress(
    BuildContext context,
    LongPressStartDetails details,
    ZIMKitMessage msg,
  ) {
    void defaultAction() {
      // TODO popup menu
    }
    if (onLongPress != null) {
      onLongPress!.call(context, details, msg, defaultAction);
    } else {
      defaultAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () => _onPressed(context, message),
        onLongPressStart: (details) => _onLongPress(context, details, message),
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildCover(),
            buildPlayIcon(),
            buildDuration(),
          ],
        ),
      ),
    );
  }

  ///获取视频分辨率(px)
  Size getOriginalPixelSize() {
    final videoContent = message.videoContent!;
    var size = Size(
      videoContent.videoFirstFrameWidth.toDouble(),
      videoContent.videoFirstFrameHeight.toDouble(),
    );
    if (!size.isEmpty) {
      return size;
    }
    //发送中，ZIMKitMessageVideoContent没有图片尺寸信息，需从扩展字段中获取原始宽高
    final extData = message.zim.extendedData;
    if (extData.isNotEmpty) {
      try {
        final data = jsonDecode(extData);
        if (data is Map) {
          size = Size(
            double.tryParse("${data['width']}") ?? 0,
            double.tryParse("${data['height']}") ?? 0,
          );
          if (!size.isEmpty) {
            videoContent.videoFirstFrameWidth = size.width.toInt();
            videoContent.videoFirstFrameHeight = size.height.toInt();
          }
        }
      } catch (ex) {
        //e
      }
    }
    return size;
  }

  ///获取视频时长
  int getVideoDuration() {
    var duration = message.videoContent?.videoDuration ?? 0;
    if (duration > 0) {
      return duration;
    }
    //从扩展字段获取视频时长
    final extData = message.zim.extendedData;
    if (extData.isNotEmpty) {
      try {
        final data = jsonDecode(extData);
        if (data is Map) {
          duration = int.tryParse("${data['duration']}") ?? 0;
          if (duration > 0) {
            message.videoContent?.videoDuration = duration;
          }
        }
      } catch (ex) {
        //e
      }
    }
    return duration;
  }

  ///获取最佳显示大小
  Size getBestDisplaySize() {
    final originSize = getOriginalPixelSize();
    final constraints = BoxConstraints(
      minWidth: 60.rpx,
      minHeight: 80.rpx,
      maxWidth: Get.width * 0.6,
      maxHeight: Get.width * 0.8,
    );
    if (originSize.isEmpty) {
      return constraints.smallest;
    }
    return constraints.constrainSizeAndAttemptToPreserveAspectRatio(originSize);
  }

  Widget buildCover() {
    final videoContent = message.videoContent!;
    final displaySize = getBestDisplaySize();
    return Container(
      width: displaySize.width,
      height: displaySize.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      foregroundDecoration: videoContent.videoDuration > 0
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8.rpx),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            )
          : null,
      child: videoContent.videoFirstFrameLocalPath.isNotEmpty
          ? Image.file(
              File(videoContent.videoFirstFrameLocalPath),
              fit: BoxFit.cover,
              width: displaySize.width,
              height: displaySize.height,
            )
          : AppImage.network(
              videoContent.videoFirstFrameDownloadUrl,
              key: ValueKey(message.info.messageID),
              fit: BoxFit.cover,
              width: displaySize.width,
              height: displaySize.height,
              placeholder: Container(
                width: displaySize.width,
                height: displaySize.height,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget buildPlayIcon() {
    return Container(
      height: 36.rpx,
      width: 36.rpx,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow,
        size: 24.rpx,
        color: Colors.white,
      ),
    );
  }

  Widget buildDuration() {
    final durationSeconds = getVideoDuration();
    if (durationSeconds <= 0) {
      return const SizedBox.shrink();
    }

    final minutes = (durationSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (durationSeconds % 60).ceil().toString().padLeft(2, '0');
    final durationText = '$minutes:$seconds';
    return Positioned(
      bottom: 8.rpx,
      right: 8.rpx,
      child: Text(
        durationText,
        style: AppTextStyle.fs12m.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  void playVideo(BuildContext context) {
    Get.to(
      () => ChatVideoMessagePlayer(
        message,
        key: ValueKey(message.info.messageID),
      ),
    );
  }
}