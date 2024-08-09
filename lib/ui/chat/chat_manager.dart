import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///IM聊天，音视频通话 服务管理
class ChatManager {
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
  }

  ///连接到IM服务
  Future<void> connect({
    required String userId,
    required String nickname,
    String? avatar,
  }) async {
    //登录ZEGO即时通信服务
    final ret = await ZIMKit().connectUser(
      id: userId.toString(),
      name: nickname,
      avatarUrl: avatar ?? '',
    );
    if (ret == 0) {
      //初始化音视频通话服务
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: AppConfig.zegoAppId,
        appSign: AppConfig.zegoAppSign,
        userID: userId.toString(),
        userName: nickname,
        plugins: [ZegoUIKitSignalingPlugin()],
        //自定义文本内容
        innerText: ZegoCallInvitationInnerText(),
        requireConfig: _requireCallConfig,
        config: ZegoCallInvitationConfig(),
        uiConfig: _callInvitationUIConfig(),
      );
    } else {
      AppLogger.w('连接IM失败，code=$ret');
    }
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
      return Container(
        width: size.width,
        height: size.height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: user != null
            ? ZIMKitAvatar(userID: user.id, name: user.name)
            : null,
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

    config.background = AppImage.asset(
      width: Get.width,
      height: Get.height,
      'assets/images/chat/call_background.png',
      fit: BoxFit.cover,
    );

    return config;
  }

  ///断开连接
  Future<void> disconnect() async {
    ZIMKit().disconnectUser();
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}
