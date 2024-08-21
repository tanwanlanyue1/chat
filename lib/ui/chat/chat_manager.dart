import 'dart:convert';
// Dart imports:
import 'dart:async';
// import 'dart:ffi';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_call/src/invitation/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/inner_text.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/assets.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/defines.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/internal_instance.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/notification.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/internal/protocols.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/calling/machine.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/pages/page_manager.dart';
import 'package:zego_uikit_prebuilt_call/src/invitation/service.dart';
import 'package:zego_uikit_prebuilt_call/src/minimizing/overlay_machine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_end_dialog.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_event_notifier.dart';
import 'custom/custom_message_type.dart';
import 'custom/message_call_end_content.dart';
part 'chat_call_mixin.dart';

///IM聊天，音视频通话 服务管理
class ChatManager with ChatCallMixin{
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

    //监听通话结束消息
    ChatEventNotifier().onReceivePeerMessage.listen((event) {
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
    }else{
      AppLogger.w('syncUserInfo: 用户信息为空');
    }
  }


  ///开始聊天(跳转聊天页面)
  bool startChat({required int userId}){
    if (userId == SS.login.userId) {
      AppLogger.w('不可和自己聊天');
      return false;
    }
    Get.toNamed(
      AppRoutes.messageListPage,
      arguments: {
        'conversationId': userId.toString(),
        'conversationType': ZIMConversationType.peer,
      },
    );
    return true;
  }


}

