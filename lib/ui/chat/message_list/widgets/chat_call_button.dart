import 'package:flutter/material.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/ui/chat/chat_manager.dart';
import 'package:guanjia/widgets/loading.dart';

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
    this.jumpToChatPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startCall,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: width,
        height: height,
        child: IgnorePointer(
          child: child,
        ),
      ),
    );
  }

  void _startCall() async {
    //发起通话确认对话框
    final ret =
        await ChatCallDialog.show(isVideoCall: isVideoCall, userId: userId);
    if (ret != true) {
      return;
    }

    Loading.show();
    final response = await IMApi.createCallOrder(isVideoCall ? 1 : 2);
    Loading.dismiss();
    int? orderId;
    if (response.isSuccess) {
      orderId = response.data;
    } else {
      response.showErrorMessage();
      return;
    }
    if (orderId == null) {
      Loading.showToast('发起失败');
      return;
    }

    if (jumpToChatPage) {
      ChatManager().startChat(userId: userId);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    ChatManager().startCall(
      userId: userId,
      nickname: nickname,
      callId: orderId.toString(),
      isVideoCall: isVideoCall,
    );
  }

}
