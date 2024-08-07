import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/src/callkit/notification_manager.dart';
import 'package:zego_zimkit/src/services/logger_service.dart';
import 'package:zego_zimkit/src/services/services.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:guanjia/common/utils/app_logger.dart';

extension ZIMKitCoreExtension on ZIMKitCore{

  ///发送媒体消息，可携带扩展字段
  Future<void> sendMediaMessageExt(
      String conversationID,
      ZIMConversationType conversationType,
      String mediaPath,
      ZIMMessageType messageType, {
        FutureOr<ZIMKitMessage> Function(ZIMKitMessage message)? preMessageSending,
        Function(ZIMKitMessage message)? onMessageSent,
        int audioDuration = 0,
        String? localExtendedData,
      }) async {
    if (mediaPath.isEmpty || !(await File(mediaPath).exists())) {
      AppLogger.w(
          "sendMediaMessage: mediaPath is empty or file doesn't exits");
      return;
    }
    if (conversationID.isEmpty) {
      AppLogger.w('sendCustomMessage: conversationID is empty');
      return;
    }

    // 1. create message
    var kitMessage = ZIMKitMessageUtils.mediaMessageFactory(
      mediaPath,
      messageType,
      audioDuration: audioDuration,
    ).toKIT();
    kitMessage.zim.conversationID = conversationID;
    kitMessage.zim.conversationType = conversationType;

    // 2. preMessageSending
    kitMessage = (await preMessageSending?.call(kitMessage)) ?? kitMessage;

    // 3. re-generate zim
    // ignore: cascade_invocations
    kitMessage.reGenerateZIMMessage();

    if(localExtendedData != null){
      kitMessage.localExtendedData.value = localExtendedData;
      kitMessage.zim.localExtendedData = localExtendedData;
    }

    final sendConfig = ZIMMessageSendConfig();
    if (ZegoZIMKitNotificationManager.instance.resourceID?.isNotEmpty ??
        false) {
      final pushConfig = ZIMPushConfig()
        ..resourcesID = ZegoZIMKitNotificationManager.instance.resourceID!
        ..title = ZIMKit().currentUser()?.baseInfo.userName ?? ''

      /// media only show [type] for offline message
        ..content = '[${messageType.name}]'
        ..payload = const JsonEncoder().convert(
          {
            ZIMKitInvitationProtocolKey.operationType:
            BackgroundMessageType.mediaMessage.text,
            'id': conversationID,
            'sender': {
              'id': ZIMKit().currentUser()?.baseInfo.userID ?? '',
              'name': ZIMKit().currentUser()?.baseInfo.userName ?? '',
            },
            'type': conversationType.index,
          },
        );
      sendConfig.pushConfig = pushConfig;
    }

    final mediaMessagePath =
    // ignore: avoid_dynamic_calls
    kitMessage.autoContent.fileDownloadUrl.isNotEmpty
    // ignore: avoid_dynamic_calls
        ? kitMessage.autoContent.fileDownloadUrl
        : mediaPath;
    ZIMKitLogger.info('sendMediaMessage: $mediaMessagePath');

    // 3. call service
    late ZIMKitMessageNotifier kitMessageNotifier;
    await ZIM
        .getInstance()!
        .sendMediaMessage(
      kitMessage.zim as ZIMMediaMessage,
      conversationID,
      conversationType,
      sendConfig,
      ZIMMediaMessageSendNotification(
        onMessageAttached: (zimMessage) {
          ZIMKitLogger.info('sendMediaMessage.onMessageAttached: '
              '${(zimMessage as ZIMMediaMessage).fileName}');
          kitMessageNotifier = db
              .messages(conversationID, conversationType)
              .onAttach(zimMessage);
        },
        onMediaUploadingProgress:
            (message, currentFileSize, totalFileSize) {
          final zimMessage = message as ZIMMediaMessage;
          ZIMKitLogger.info(
              'onMediaUploadingProgress: ${zimMessage.fileName}, $currentFileSize/$totalFileSize');

          kitMessageNotifier.value = (kitMessageNotifier.value.clone()
            ..updateExtraInfo({
              'upload': {
                ZIMMediaFileType.originalFile.name: {
                  'currentFileSize': currentFileSize,
                  'totalFileSize': totalFileSize,
                }
              }
            }));
        },
      ),
    )
        .then((result) {
      ZIMKitLogger.info('sendMediaMessage: success, $mediaPath}');
      kitMessageNotifier.value = result.message.toKIT();
      onMessageSent?.call(kitMessageNotifier.value);
    }).catchError((error) {
      kitMessageNotifier.value =
      (kitMessageNotifier.value.clone()..sendFailed(error));
      return checkNeedReloginOrNot(error).then((retryCode) {
        if (retryCode == 0) {
          ZIMKitLogger.info('relogin success, retry sendMediaMessage');
          sendMediaMessage(
            conversationID,
            conversationType,
            mediaPath,
            messageType,
            preMessageSending: preMessageSending,
            onMessageSent: onMessageSent,
          );
        } else {
          ZIMKitLogger.severe(
              'sendMediaMessage: failed, $mediaPath, error:$error');
          onMessageSent?.call(kitMessageNotifier.value);
          throw error;
        }
      });
    });
  }

}