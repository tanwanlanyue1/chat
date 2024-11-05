// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'dart:ffi';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/network/api/model/im/chat_call_pay_model.dart';
import 'package:guanjia/common/notification/notification_manager.dart';
import 'package:guanjia/common/notification/payload/chat_message_payload.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/file_logger.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/common/utils/plugin_util.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/global.dart';
import 'package:guanjia/ui/chat/custom/message_call_reject_content.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/zim_kit_core_extension.dart';
import 'package:guanjia/ui/chat/message_list/message_list_controller.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_end_dialog.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_recharge_dialog.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' hide Size;
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/internal_instance.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/notification.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/protocols.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/calling/machine.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/page_manager.dart';
import 'package:zego_uikit_prebuilt_call/src/minimizing/overlay_machine.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../custom/custom_message_type.dart';
import 'chat_event_notifier.dart';

part 'chat_call_mixin.dart';
part 'chat_notification_mixin.dart';
part 'chat_sender_mixin.dart';

///IM聊天，音视频通话 服务管理
class ChatManager
    with
        WidgetsBindingObserver,
        _ChatCallMixin,
        _ChatNotificationMixin,
        _ChatSenderMixin {
  ChatManager._();

  factory ChatManager() => instance;

  static final instance = ChatManager._();

  var _isInit = false;

  ///初始化
  Future<void> init() async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    //ZEGO 即时通信
    await ZIMKit().init(
      appID: AppConfig.zegoAppId,
      appSign: AppConfig.zegoAppSign,
      notificationConfig: ZegoZIMKitNotificationConfig(
        resourceID: AppConfig.zegoChatResourceId,
        supportOfflineMessage: true,
        androidNotificationConfig: ZegoZIMKitAndroidNotificationConfig(
          channelID: AppConfig.zegoChatResourceId,
          channelName: S.current.newMessageNotification,
          icon: 'logo',
        ),
        iosNotificationConfig: ZegoZIMKitIOSNotificationConfig(
          certificateIndex: ZegoSignalingPluginMultiCertificate.firstCertificate
        )
      ),
    );

    //ZEGO 音视频通话
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(Get.key);

    ZegoUIKit().initLog().then((value) {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
    });

    //监听聊天消息
    final initTimestamp = DateTime.now().millisecondsSinceEpoch;
    ChatEventNotifier().onReceivePeerMessage.listen((event) {
      var reminder = false;
      event.messageList
          .where((element) => element.timestamp > initTimestamp)
          .map((element) => element.toKIT())
          .forEach((message) {
        //通话结束对话框
        if (message.customType == CustomMessageType.callEnd) {
          _showCallEndDialog(message);
        }

        //新消息通知，发送的消息和通话消息不弹通知
        if (message.info.direction == ZIMMessageDirection.receive &&
            ![
              CustomMessageType.callInvite,
              CustomMessageType.callEnd,
              CustomMessageType.callReject,
            ].contains(message.customType)) {
          reminder = true;
          _showNotification(message);
        }
      });

      //声音震动提醒
      if (reminder) {
        SS.inAppMessage.messageReminder();
      }
    });

    //监听连接状态更新用户信息
    ZIMKitCore.instance.getConnectionStateChangedEventStream().listen((event) {
      if (ZIMKitCore.instance.connectionState == ZIMConnectionState.connected) {
        syncUserInfo();
      }
    });
  }

  ///连接到IM服务
  Future<void> connect({
    required String userId,
    required String nickname,
    String? avatar,
  }) async {
    //登录ZEGO即时通信服务
    final ret = await ZIMKit().connectUser(
      id: userId,
      name: nickname,
      avatarUrl: avatar ?? '',
    );
    if (ret != 0) {
      AppLogger.w('连接到IM服务失败，code=$ret');
      return;
    }

    AppLogger.d('连接到IM服务成功,nickname=$nickname, userId=$userId');

    //初始化音视频通话服务
    await _initChatCall(userId: userId, nickname: nickname);
    _startChatWithAppLaunch();
  }

  ///断开连接
  Future<void> disconnect() async {
    AppLogger.d('断开IM连接');
    await ZIMKit().disconnectUser();
    await _uninitChatCall();
    await clearNotifications();
  }

  ///同步用户信息到IM服务
  @Deprecated('服务端已同步，不需要客户端调用这个接口')
  Future<void> syncUserInfo() async {
    // AppLogger.d('同步用户信息到IM服务syncUserInfo');
    // final userInfo = SS.login.info;
    // if (userInfo != null) {
    //   await ZIMKit().updateUserInfo(
    //     name: userInfo.nickname,
    //     avatarUrl: userInfo.avatar ?? '',
    //   );
    // } else {
    //   AppLogger.w('syncUserInfo: 用户信息为空');
    // }
  }

  ///开始聊天(跳转聊天页面)
  bool startChat({required int userId}) {
    if (userId == SS.login.userId) {
      AppLogger.w('不可和自己聊天');
      return false;
    }

    clearNotifications(conversationId: userId.toString());
    final index = AppPages.routeObserver.stack.indexWhere(
        (element) => element.settings.name == AppRoutes.messageListPage);
    if (index > 0) {
      final item = AppPages.routeObserver.stack.elementAtOrNull(index + 1);
      Get.offNamedUntil(
        AppRoutes.messageListPage,
        (route) => route == item,
        arguments: {
          'conversationId': userId.toString(),
          'conversationType': ZIMConversationType.peer,
        },
      );
    } else {
      Get.toNamed(
        AppRoutes.messageListPage,
        arguments: {
          'conversationId': userId.toString(),
          'conversationType': ZIMConversationType.peer,
        },
      );
    }
    return true;
  }
}
