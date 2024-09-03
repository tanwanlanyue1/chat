import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_unknown_message.dart';

///音视频通话被拒绝接听消息
class ChatCallRejectMessage extends StatelessWidget {
  const ChatCallRejectMessage({
    super.key,
    required this.message,
    this.onPressed,
    this.onLongPress,
  });

  final ZIMKitMessage message;
  final void Function(
          BuildContext context, ZIMKitMessage message, Function defaultAction)?
      onPressed;
  final void Function(BuildContext context, LongPressStartDetails details,
      ZIMKitMessage message, Function defaultAction)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final content = message.callRejectContent;
    if (content == null) {
      return ChatUnknownMessage(message: message);
    }

    String icon;
    if (content.isVideoCall) {
      icon = message.isMine
          ? 'assets/images/chat/ic_video_call_white.png'
          : 'assets/images/chat/ic_video_call_black.png';
    } else {
      icon = message.isMine
          ? 'assets/images/chat/ic_voice_call_white.png'
          : 'assets/images/chat/ic_voice_call_black.png';
    }

    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {}),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {
          },
        ),
        child: Bubble(
          elevation: 0,
          color: message.isMine ? AppColor.blue6 : Colors.white,
          nip: message.isMine ? BubbleNip.rightBottom : BubbleNip.leftBottom,
          radius: Radius.circular(8.rpx),
          padding: BubbleEdges.symmetric(
            horizontal: 12.rpx,
            vertical: 8.rpx,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage.asset(
                icon,
                width: 24.rpx,
                height: 24.rpx,
              ),
              Padding(
                padding: FEdgeInsets(left: 8.rpx),
                child: Text(
                  content.message,
                  style: AppTextStyle.fs14m.copyWith(
                    color: message.isMine ? Colors.white : AppColor.gray5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
