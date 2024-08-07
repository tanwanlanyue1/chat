import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

///红包消息
class ChatRedPacketMessage extends StatelessWidget {
  const ChatRedPacketMessage({
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
    final content = message.redPacketContent;
    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {}),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: Bubble(
          elevation: 0,
          color: AppColor.orange6,
          nip: message.isMine ? BubbleNip.rightBottom : BubbleNip.leftBottom,
          radius: Radius.circular(8.rpx),
          padding: BubbleEdges.symmetric(
            horizontal: 16.rpx,
            vertical: 8.rpx,
          ),
          child: SizedBox(
            width: 200.rpx,
            height: 68.rpx,
            child: Row(
              children: [
                Padding(
                  padding: FEdgeInsets(right: 8.rpx),
                  child: AppImage.asset(
                    'assets/images/chat/ic_red_packet_msg.png',
                    width: 36.rpx,
                    height: 36.rpx,
                  ),
                ),
                Expanded(
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    content?.desc ?? '',
                    style: AppTextStyle.fs16m.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
