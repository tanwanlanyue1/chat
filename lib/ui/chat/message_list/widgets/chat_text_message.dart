import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///文本消息
class ChatTextMessage extends StatelessWidget {
  const ChatTextMessage({
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
    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {}),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {
            message.textContent?.text.copy();
          },
        ),
        child: Bubble(
          elevation: 0,
          color: message.isMine ? AppColor.primaryBlue : Colors.white,
          nip: message.isMine ? BubbleNip.rightBottom : BubbleNip.leftBottom,
          radius: Radius.circular(8.rpx),
          padding: BubbleEdges.symmetric(
            horizontal: 12.rpx,
            vertical: 8.rpx,
          ),
          child: Text(
            message.textContent!.text,
            textAlign: TextAlign.left,
            style: AppTextStyle.fs14.copyWith(
              color: message.isMine ? Colors.white : AppColor.blackBlue,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
