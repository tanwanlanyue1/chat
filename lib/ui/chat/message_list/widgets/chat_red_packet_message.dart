import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_red_packet_builder.dart';

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

    return Flexible(
      child: GestureDetector(
        onTap: () => onPressed?.call(context, message, () {}),
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: ChatRedPacketBuilder(
          message: message,
          builder: (_){
            switch (message.redPacketViewType) {
              case RedPacketViewType.bubble:
                return RedPacketBubbleView(message: message);
              case RedPacketViewType.details:
                return RedPacketDetailsView(message: message);
              case RedPacketViewType.tips:
                return RedPacketTipsView(message: message);
            }
          },
        ),
      ),
    );
  }
}

class RedPacketTipsView extends StatelessWidget {
  final ZIMKitMessage message;

  const RedPacketTipsView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

///详情视图
class RedPacketDetailsView extends StatelessWidget {
  final ZIMKitMessage message;

  const RedPacketDetailsView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final content = message.redPacketContent;
    if (content == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 260.rpx,
      decoration: BoxDecoration(
        color: message.isMine ? AppColor.blue6 : Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: FEdgeInsets(
        horizontal: 12.rpx,
        vertical: 8.rpx,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(),
          buildContent(content),
        ],
      ),
    );
  }

  Widget buildTitle() {
    String title = (message.isMine ? '您领取了Ta的红包' : '您向Ta发了红包');
    return Padding(
      padding: FEdgeInsets(top: 6.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage.asset(
            'assets/images/chat/ic_red_packet_msg.png',
            width: 24.rpx,
            height: 24.rpx,
          ),
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              title,
              style: AppTextStyle.fs14m.copyWith(
                color: message.isMine ? Colors.white : AppColor.gray5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(MessageRedPacketContent content) {
    final redPacketLocal = message.redPacketLocal;
    Widget buildItem({
      required String label,
      required String value,
      bool isHighlight = false,
    }) {
      return Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: isHighlight
                ? const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textYellow,
                  )
                : null,
          ),
        ],
      );
    }

    final receiveTime = redPacketLocal.receiveTime;

    List<Widget> children = [
      buildItem(
        label: '发送时间',
        value:
            DateTime.fromMillisecondsSinceEpoch(message.info.timestamp).format2,
      ),
      if (receiveTime != null)
        buildItem(
          label: '领取时间',
          value: receiveTime.format2,
        ),
      buildItem(
          label: message.isMine ? '红包实付金额' : '实收金额',
          value: content.amount.toCurrencyString(),
          isHighlight: true),
    ];

    return Padding(
      padding: FEdgeInsets(top: 12.rpx, bottom: 4.rpx),
      child: DefaultTextStyle(
        style: AppTextStyle.fs12m.copyWith(
          color: message.isMine ? Colors.white : AppColor.gray30,
          height: 1.00001,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children.separated(Spacing.h12).toList(growable: false),
        ),
      ),
    );
  }
}

///气泡视图
class RedPacketBubbleView extends StatelessWidget {
  final ZIMKitMessage message;

  const RedPacketBubbleView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final content = message.redPacketContent;
    final status = message.redPacketLocal.status;

    return Bubble(
      elevation: 0,
      color: status == 0
          ? AppColor.orange6
          : const Color(0xFFFAD6AF),
      nip: message.isMine ? BubbleNip.rightBottom : BubbleNip.leftBottom,
      radius: Radius.circular(8.rpx),
      padding: BubbleEdges.symmetric(
        horizontal: 16.rpx,
        vertical: 16.rpx,
      ),
      child: SizedBox(
        width: 200.rpx,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: FEdgeInsets(right: 8.rpx),
                  child: AppImage.asset(
                    'assets/images/chat/ic_red_packet_msg.png',
                    width: 36.rpx,
                    height: 36.rpx,
                    opacity: AlwaysStoppedAnimation(
                        message.isRedPacketReceivable ? 1 : 0.5),
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
            if(status == 1) Padding(
              padding: FEdgeInsets(top: 8.rpx),
              child: Text(
                '红包金额：${content?.amount.toCurrencyString()}  已被领取',
                style: AppTextStyle.fs12m.copyWith(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
