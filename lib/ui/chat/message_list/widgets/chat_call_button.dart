import 'package:flutter/material.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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




  const ChatCallButton({
    super.key,
    this.width,
    this.height,
    required this.child,
    required this.isVideoCall,
    required this.userId,
    required this.nickname,
    this.onWillPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints){
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
                onCallId: (callId){

                },
                buttonSize: Size(width, height),
                iconVisible: false,
                isVideoCall: isVideoCall,
                invitees: [
                  ZegoUIKitUser(
                    id: userId.toString(),
                    name: nickname,
                  ),
                ],
                onWillPressed: onWillPressed ?? () async => true,
                onPressed:
                    (String code, String message, List<String> errorInvitees) {
                  onCallInvitationSent(code, message, errorInvitees);
                },
              ),
            ],
          ),
        );
      }
    );
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
