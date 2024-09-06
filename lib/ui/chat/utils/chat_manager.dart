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
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/network/api/model/im/chat_call_pay_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_call_reject_content.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/zim_kit_core_extension.dart';
import 'package:guanjia/ui/chat/message_list/message_list_controller.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_end_dialog.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_recharge_dialog.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/system_ui.dart';
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
    );
    //ZEGO 音视频通话
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(Get.key);

    ZegoUIKit().initLog().then((value) {
      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
        [ZegoUIKitSignalingPlugin()],
      );
    });

    _initNotification();

    //监听聊天消息
    ChatEventNotifier().onReceivePeerMessage.listen((event) {
      _onMessageArrivedNotification(event.messageList);
      for (var message in event.messageList) {
        if (message is! ZIMCustomMessage) {
          continue;
        }
        final kitMessage = message.toKIT();
        if (kitMessage.customType == CustomMessageType.callEnd) {
          _showCallEndDialog(kitMessage);
          break;
        }
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
  }

  ///断开连接
  Future<void> disconnect() async {
    AppLogger.d('断开IM连接');
    await ZIMKit().disconnectUser();
    await _uninitChatCall();
    await clearNotifications();
  }

  ///同步用户信息到IM服务
  Future<void> syncUserInfo() async {
    AppLogger.d('同步用户信息到IM服务syncUserInfo');
    final userInfo = SS.login.info;
    if (userInfo != null) {
      await ZIMKit().updateUserInfo(
        name: userInfo.nickname,
        avatarUrl: userInfo.avatar ?? '',
      );
    } else {
      AppLogger.w('syncUserInfo: 用户信息为空');
    }
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
