import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:zego_zimkit/zego_zimkit.dart';


///订单消息
class ChatOrderMessage extends StatelessWidget {
  const ChatOrderMessage({
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
            Clipboard.setData(ClipboardData(text: message.textContent!.text));
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
          child: Text(
            message.orderContent?.message ?? '',
            textAlign: TextAlign.left,
            style: AppTextStyle.fs14m.copyWith(
              color: message.isMine
                  ? Colors.white
                  : AppColor.gray5,
              height: 21/14,
            ),
          ),
        ),
      ),
    );
  }
}
