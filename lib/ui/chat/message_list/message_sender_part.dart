import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/message_order_part.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import 'message_list_controller.dart';
import 'widgets/chat_feature_panel.dart';

///消息发送功能
extension MessageSenderPart on MessageListController {

  ///发送文本消息
  Future<void> sendTextMessage(String text) async {
    final result = await ChatManager().sendTextMessage(
      text: text,
      conversationId: state.conversationId,
      conversationType: state.conversationType,
    );
    if (result) {
      scrollController.jumpTo(0);
    }
  }

  ///发送图片+视频消息
  Future<void> sendMediaMessage() async {
    // iOS端需要判断权限
    if (GetPlatform.isIOS) {
      final isGranted = await PermissionsUtils.requestPhotosPermission();
      if (!isGranted) return;
    }

    final files = await ImagePicker().pickMultipleMedia(
      imageQuality: 90,
      limit: 9,
    );

    const videoMimeTypes = ['video/mp4', 'video/quicktime'];
    String? errorMsg;
    files.removeWhere((element) {
      final mimeType = element.mimeType ?? lookupMimeType(element.name) ?? '';
      AppLogger.d('mineType: $mimeType  name:${element.name}');
      if (mimeType.startsWith('video') && !videoMimeTypes.contains(mimeType)) {
        errorMsg = S.current.videoMsgSupportHint;
      }
      return !mimeType.startsWith('image/') &&
          !videoMimeTypes.contains(mimeType);
    });
    if (errorMsg != null) {
      Loading.showToast(errorMsg!);
    }

    if (files.isEmpty) {
      //没选图片或视频
      return;
    }

    for (final file in files) {
      final mimeType = file.mimeType ?? lookupMimeType(file.name) ?? '';
      if (videoMimeTypes.contains(mimeType)) {
        await _sendVideoMessage(file.path);
      } else {
        await _sendImageMessage(file.path);
      }
    }
  }

  Future<void> _sendImageMessage(String filePath) async {

    final result = await ChatManager().sendImageMessage(
      filePath: filePath,
      conversationId: state.conversationId,
      conversationType: state.conversationType,
    );
    if (result) {
      scrollController.jumpTo(0);
    }
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
    return _sendVideoMessage(file.path);
  }

  ///发送视频消息
  Future<void> _sendVideoMessage(String filePath) async {
    final result = await ChatManager().sendVideoMessage(
      filePath: filePath,
      conversationId: state.conversationId,
      conversationType: state.conversationType,
    );
    if (result) {
      scrollController.jumpTo(0);
    }
  }

  ///发红包消息
  void sendRedPacketMessage() {
    Get.toNamed(
      AppRoutes.redPacketPage,
      arguments: {
        'userId': int.parse(state.conversationId),
      },
    );
  }

  ///发转账消息
  void sendTransferMoneyMessage() {
    Get.toNamed(
      AppRoutes.transferMoneyPage,
      arguments: {
        'userId': int.parse(state.conversationId),
      },
    );
  }

  ///点击聊天功能面板
  void onTapFeatureAction(ChatFeatureAction action) {
    switch (action) {
      case ChatFeatureAction.picture:
        sendMediaMessage();
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
        sendTransferMoneyMessage();
        break;
    }
  }
}
