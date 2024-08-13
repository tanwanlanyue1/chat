import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'chat_call_dialog.dart';

///音视频通话按钮
class ChatCallButton extends StatelessWidget {

  final Widget child;

  ///是否是视频通话
  final bool isVideoCall;

  ///用户ID
  final int userId;

  ///用户昵称
  final String nickname;

  ///控制是否呼出的回调，return true开始呼叫，false啥也不做
  final Future<bool> Function()? onWillPressed;

  final double? width;
  final double? height;

  ///是否先跳转聊天页面
  final bool jumpToChatPage;

  const ChatCallButton({
    super.key,
    this.width,
    this.height,
    required this.child,
    required this.isVideoCall,
    required this.userId,
    required this.nickname,
    this.onWillPressed,
    this.jumpToChatPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final width = this.width ?? constraints.constrainWidth();
      final height = this.height ?? constraints.constrainHeight(50.rpx);
      return SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            child,
            ZegoSendCallInvitationButton(
              buttonSize: Size(width, height),
              iconVisible: false,
              isVideoCall: isVideoCall,
              invitees: [
                ZegoUIKitUser(
                  id: userId.toString(),
                  name: nickname,
                ),
              ],
              onWillPressed: _onWillPressed,
              onPressed:
                  (String code, String message, List<String> errorInvitees) {
                onCallInvitationSent(code, message, errorInvitees);
              },
            ),
          ],
        ),
      );
    });
  }

  ///音视频通话呼出前调用
  Future<bool> _onWillPressed() async {
    final result = await onWillPressed?.call() ?? await _defaultOnWillPressed();
    if (result) {
      ChatManager().setChatCallInfo(
        invitee: userId.toString(),
        isVideoCall: isVideoCall,
      );
    }
    return result;
  }

  Future<bool> _defaultOnWillPressed() async{
    var hasPermission = false;
    if (isVideoCall) {
      hasPermission = await PermissionsUtils.requestPermissions([
        Permission.camera,
        Permission.microphone,
      ], hintText: '需要开启相机和麦克风权限');
    } else {
      hasPermission = await PermissionsUtils.requestPermission(
        Permission.microphone,
        hintText: '需要开启麦克风权限',
      );
    }
    if(!hasPermission){
      return false;
    }

    if(jumpToChatPage){
      ChatManager().toChatPage(userId: userId);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    //发起聊天
    final result = await ChatCallDialog.show(isVideoCall: isVideoCall);

    return result == true;
  }


  ///错误信息显示
  void onCallInvitationSent(
      String code, String message, List<String> errorInvitees) {
    String log = '';
    if (errorInvitees.isNotEmpty) {
      log = "User doesn't exist or is offline: ${errorInvitees[0]}";
      if (code.isNotEmpty) {
        log += ', code: $code, message:$message';
      }
    } else if (code.isNotEmpty) {
      log = 'code: $code, message:$message';
    }
    if (log.isNotEmpty) {
      Loading.showToast(log);
    }
  }
}
