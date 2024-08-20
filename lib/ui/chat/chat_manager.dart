import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
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

///IM聊天，音视频通话 服务管理
class ChatManager {
  ChatManager._();

  factory ChatManager() => instance;

  static final instance = ChatManager._();

  var _isInit = false;

  ///当前音视频通话信息
  var _callInfo = ChatCallInfo();

  ///等待通话结束，显示对话框
  var _isWaitCallEndDialog = false;

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
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConfig.zegoAppId,
      appSign: AppConfig.zegoAppSign,
      userID: userId,
      userName: nickname,
      plugins: [ZegoUIKitSignalingPlugin()],
      //自定义文本内容
      innerText: ZegoCallInvitationInnerText(),
      requireConfig: _requireCallConfig,
      config: ZegoCallInvitationConfig(
        endCallWhenInitiatorLeave: false,
        canInvitingInCalling: false,
        permissions: [],
      ),
      uiConfig: _callInvitationUIConfig(),
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (ZegoCallEndEvent event, VoidCallback defaultAction) {
          defaultAction.call();
          AppLogger.d(
              'ZegoUIKitPrebuiltCallEvents>onCallEnd reason=, ${event.reason}');
          switch (event.reason) {
            case ZegoCallEndReason.localHangUp:
            case ZegoCallEndReason.abandoned:
              //本地挂断，发送一条通话时长消息
              _sendCallEndMessage(_callInfo);
              break;
            default:
              break;
          }
        },
      ),
      //事件说明 https://www.zegocloud.com/docs/uikit/zh/callkit-android/api-reference/event#invitationevents
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (
          String callID,
          ZegoCallUser callee,
        ) {
          AppLogger.d(
              'ZegoUIKitPrebuiltCallInvitationEvents>onOutgoingCallAccepted: callID=${callID}, info=$_callInfo');
          if (_callInfo.invitee == callee.id) {
            _isWaitCallEndDialog = true;
            _callInfo = _callInfo.copyWith(
              beginTime: DateTime.now(),
              inviter: SS.login.userId.toString(),
              invitee: callee.id,
              duration: Duration.zero,
            );
          }
        },
        onIncomingCallReceived: (
          String callID,
          ZegoCallUser caller,
          ZegoCallInvitationType callType,
          List<ZegoCallUser> callees,
          String customData,
        ) {
          _isWaitCallEndDialog = true;
          _callInfo = ChatCallInfo(
            beginTime: DateTime.now(),
            isVideoCall: callType == ZegoCallInvitationType.videoCall,
            inviter: caller.id,
            invitee: callees.first.id,
          );
        },
        onOutgoingCallRejectedCauseBusy: (
          String callID,
          ZegoCallUser callee,
          String customData,
        ) {
          Loading.showToast('对方正在通话中');
        },
      ),
    );
  }

  ///音视频通话呼叫过程中的UI配置
  ZegoCallInvitationUIConfig _callInvitationUIConfig() {
    //背景
    Widget? backgroundBuilder(
      BuildContext context,
      Size size,
      ZegoCallingBuilderInfo info,
    ) {
      return AppImage.asset(
        width: size.width,
        height: size.height,
        'assets/images/chat/call_background.png',
        fit: BoxFit.cover,
      );
    }

    return ZegoCallInvitationUIConfig(
      prebuiltWithSafeArea: false,
      invitationWithSafeArea: false,
      systemUiOverlayStyle: SystemUiOverlayStyle.light,
      //邀请人
      inviter: ZegoCallInvitationInviterUIConfig(
        backgroundBuilder: backgroundBuilder,
      ),
      //被邀请人
      invitee: ZegoCallInvitationInviteeUIConfig(
        backgroundBuilder: backgroundBuilder,
      ),
    );
  }

  ///音视频通话配置
  ZegoUIKitPrebuiltCallConfig _requireCallConfig(ZegoCallInvitationData data) {
    final isVideoCall = ZegoCallInvitationType.videoCall == data.type;
    final config = (data.invitees.length > 1)
        ? isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
        : isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

    //用户头像配置
    config.avatarBuilder = (
      BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map extraInfo,
    ) {
      return ChatAvatar.circle(
        userId: user?.id ?? '',
        width: size.width,
        height: size.height,
      );
    };

    //底部菜单栏配置
    config.bottomMenuBar = ZegoCallBottomMenuBarConfig(
      hideAutomatically: false,
      margin: const EdgeInsets.only(bottom: 48),
      buttons: [
        if (isVideoCall) ZegoCallMenuBarButtonName.toggleCameraButton,
        ZegoCallMenuBarButtonName.toggleMicrophoneButton,
        ZegoCallMenuBarButtonName.hangUpButton,
        ZegoCallMenuBarButtonName.switchAudioOutputButton,
        if (isVideoCall) ZegoCallMenuBarButtonName.switchCameraButton,
      ],
    );

    //布局配置
    config.audioVideoView = ZegoCallAudioVideoViewConfig(
        //是否在视图上显示麦克风状态。默认显示
        showMicrophoneStateOnView: false,
        //是否在视图上显示摄像头状态。默认显示
        showCameraStateOnView: false,
        //是否在视图上显示用户名。默认显示。
        showUserNameOnView: false,
        //是否裁剪视频，填充整个屏幕
        useVideoViewAspectFill: true,
        //通话界面背景
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return AppImage.asset(
            width: size.width,
            height: size.height,
            'assets/images/chat/call_background.png',
            fit: BoxFit.cover,
          );
        });

    //画中画布局
    config.layout = ZegoLayoutPictureInPictureConfig(
      isSmallViewShowOnlyVideo: true,
      margin: EdgeInsets.only(
        top: Get.mediaQuery.padding.top + 44.rpx,
        right: 16.rpx,
      ),
    );

    //通话时长回调
    config.duration = ZegoCallDurationConfig(onDurationUpdate: (duration) {
      _callInfo.duration = duration;
    });

    return config;
  }

  ///断开连接
  Future<void> disconnect() async {
    AppLogger.d('断开IM连接');
    await ZIMKit().disconnectUser();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isWaitCallEndDialog = false;
  }

  ///设置通话ID
  ///- invitee 被邀请人id
  ///- isVideoCall
  void setChatCallInfo({required String invitee, required bool isVideoCall}) {
    _callInfo
      ..isVideoCall = isVideoCall
      ..invitee = invitee;
  }

  ///发送一条通话记录消息
  void _sendCallEndMessage(ChatCallInfo info) async {
    AppLogger.d('_sendCallEndMessage: info = $info');

    //TODO 应该是服务端发送，目前先客户端测试发送
    //单价每分钟6美金
    const price = 6.0;
    //平台抽成12%
    const feeRate = 0.12;
    final content = MessageCallEndContent(
      isVideoCall: info.isVideoCall,
      inviter: info.inviter,
      invitee: info.invitee,
      beginTime: info.beginTime,
      duration: info.duration,
      amount: price * (info.duration.inSeconds / 60 - 1).ceil(),
      //前1分钟免费，不够1分钟按一分钟计费
      feeRate: feeRate,
    );
    final isSelfInviter = SS.login.userId.toString() == info.inviter;
    await ZIMKit().sendCustomMessage(
        isSelfInviter ? info.invitee : info.inviter, ZIMConversationType.peer,
        customType: CustomMessageType.callEnd.value,
        customMessage: content.toJsonString(), onMessageSent: (message) {
      _showCallEndDialog(message);
    });
  }

  ///显示通话结束对话框
  void _showCallEndDialog(ZIMKitMessage message) {
    final callEndContent = message.callEndContent;
    if (callEndContent == null || !_isWaitCallEndDialog) {
      return;
    }
    _isWaitCallEndDialog = false;
    Future.delayed(const Duration(milliseconds: 400), () {
      ChatCallEndDialog.show(message: message);
    });
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
}

///音视频通话状态信息
class ChatCallInfo {
  ///是否是视频通话
  bool isVideoCall;

  ///开始时间
  DateTime beginTime;

  ///通话时长
  Duration duration;

  ///邀请人(通话发起人)
  String inviter;

  ///被邀请人
  String invitee;

  ChatCallInfo({
    DateTime? beginTime,
    this.isVideoCall = false,
    this.duration = Duration.zero,
    this.inviter = '',
    this.invitee = '',
  }) : beginTime = beginTime ?? DateTime.now();

  ChatCallInfo copyWith({
    DateTime? beginTime,
    bool? isVideoCall,
    String? callId,
    Duration? duration,
    String? inviter,
    String? invitee,
  }) {
    return ChatCallInfo(
      beginTime: beginTime ?? this.beginTime,
      isVideoCall: isVideoCall ?? this.isVideoCall,
      duration: duration ?? this.duration,
      inviter: inviter ?? this.inviter,
      invitee: invitee ?? this.invitee,
    );
  }

  @override
  String toString() {
    return 'ChatCallInfo{isVideoCall: $isVideoCall, beginTime: $beginTime, duration: $duration, inviter: $inviter, invitee: $invitee}';
  }
}
