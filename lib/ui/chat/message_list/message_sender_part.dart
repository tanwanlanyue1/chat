import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/ui/chat/custom/zim_kit_core_extension.dart';
import 'package:guanjia/ui/chat/message_list/message_order_part.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/ui/order/widgets/order_create_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_controller.dart';
import 'widgets/chat_feature_panel.dart';

///消息发送功能
extension MessageSenderPart on MessageListController {
  ///发送文本消息
  Future<void> sendTextMessage(String text) async {
    await ZIMKit().sendTextMessage(
      state.conversationId,
      state.conversationType,
      text,
    );
    scrollController.jumpTo(0);
  }

  ///发送图片消息
  Future<void> sendPictureMessage() async {
    // iOS端需要判断权限
    if (GetPlatform.isIOS) {
      final isGranted = await PermissionsUtils.requestPhotosPermission();
      if (!isGranted) return;
    }
    final files = await ImagePicker().pickMultiImage(
      imageQuality: 90,
      limit: 9,
    );
    if (files.isEmpty) {
      //没选图片
      return;
    }

    for (final file in files) {
      String? localExtendedData;
      try {
        final input = AsyncImageInput.input(FileInput(File(file.path)));
        final size = await ImageSizeGetter.getSizeAsync(input);
        if (size.width > 0 && size.height > 0) {
          localExtendedData = jsonEncode({
            'width': size.needRotate ? size.height : size.width,
            'height': size.needRotate ? size.width : size.height,
          });
        }
      } catch (ex) {
        AppLogger.w('获取图片尺寸信息失败，$ex');
      }

      await ZIMKitCore.instance.sendMediaMessageExt(state.conversationId,
          state.conversationType, file.path, ZIMMessageType.image,
          localExtendedData: localExtendedData);
    }
    scrollController.jumpTo(0);
  }

  ///发送视频消息
  Future<void> sendVideoMessage() async {
    // iOS端需要判断权限
    if (GetPlatform.isIOS) {
      final isGranted = await PermissionsUtils.requestCameraPermission();
      if (!isGranted) return;
    }
    final file = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 2), //视频录制限制时长
    );
    if (file == null) {
      return;
    }

    String? extendedData;
    try {
      final videoInfo = await FlutterVideoInfo().getVideoInfo(file.path);
      final durationMs = videoInfo?.duration ?? 0;
      if (videoInfo != null && durationMs > 0) {
        final needRotate = [90, 270].contains(videoInfo.orientation);
        final width = videoInfo.width ?? 0;
        final height = videoInfo.height ?? 0;

        extendedData = jsonEncode({
          'duration': (durationMs / 1000).ceil(), //毫秒转成秒
          'width': needRotate ? height : width,
          'height': needRotate ? width : height,
        });
      }
    } catch (ex) {
      AppLogger.w('获取视频信息失败，$ex');
    }

    await ZIMKitCore.instance.sendMediaMessageExt(
      state.conversationId,
      state.conversationType,
      file.path,
      ZIMMessageType.video,
      extendedData: extendedData,
    );
    scrollController.jumpTo(0);
  }

  ///发红包消息
  void sendRedPacketMessage() {
    Get.toNamed(
      AppRoutes.redPacketPage,
      arguments: {
        'conversationId': state.conversationId,
        'conversationType': state.conversationType,
      },
    );
  }

  ///点击聊天功能面板
  void onTapFeatureAction(ChatFeatureAction action) {
    switch (action) {
      case ChatFeatureAction.picture:
        sendPictureMessage();
        break;
      case ChatFeatureAction.recordVideo:
        sendVideoMessage();
        break;
      case ChatFeatureAction.location:
        break;
      case ChatFeatureAction.redPacket:
        sendRedPacketMessage();
        break;
      case ChatFeatureAction.voiceCall:
      case ChatFeatureAction.videoCall:
        break;
      case ChatFeatureAction.date:
        onTapOrderAction(OrderOperationType.create, null);
        break;
      case ChatFeatureAction.transfer:
        Uint8List cmdMessage = utf8.encode('自定义指令');
        final message = ZIMCommandMessage(message: cmdMessage);
        ZIM.getInstance()?.sendMessage(
              message,
              state.conversationId,
              state.conversationType,
              ZIMMessageSendConfig(),
            );

        break;
    }
  }
}
