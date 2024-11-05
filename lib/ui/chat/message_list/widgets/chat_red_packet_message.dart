import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
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
        onTap: (){
          message.isRevokeMessage = false;
          onPressed?.call(context, message, () {});
        },
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: ChatRedPacketBuilder(
          message: message,
          builder: (_) {
            //红包状态： 0待领取 1已领取 2已撤回 3已过期
            final status = message.redPacketLocal.status;
            if (message.isMine) {
              if(message.isInsertMessage){
                if (status == 1) {
                  return RedPacketDetailsView(message: message);
                } else {
                  return RedPacketTipsView(
                    message: message,
                    onPressedRevoke: (){
                      message.isRevokeMessage = true;
                      onPressed?.call(context, message, () {});
                    },
                  );
                }
              }
              return RedPacketBubbleView(message: message);
            } else {
              if (message.isInsertMessage) {
                return RedPacketDetailsView(message: message);
              }
              if ([2, 3].contains(status)) {
                return RedPacketTipsView(message: message);
              }
              return RedPacketBubbleView(message: message);
            }
          },
        ),
      ),
    );
  }
}

class RedPacketTipsView extends StatelessWidget {
  final ZIMKitMessage message;

  // 撤回
  final VoidCallback? onPressedRevoke;

  const RedPacketTipsView(
      {super.key, required this.message, this.onPressedRevoke});

  @override
  Widget build(BuildContext context) {
    final status = message.redPacketLocal.status;
    if (message.isMine && status == 0) {
      return buildRevoke();
    }
    return buildTips(status);
  }

  Widget buildTips(int status) {
    var text = '';
    switch(status){
      case 2:
        text = message.isMine ? S.current.youWithdrawnRedPacket : S.current.TaWithdrawnRedPacket;
        break;
      case 3:
        text = S.current.redPacketExpired;
        break;
    }
    if(text.isEmpty){
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      padding: FEdgeInsets(right: 48.rpx),
      child: Container(
        padding: FEdgeInsets(horizontal: 8.rpx, vertical: 4.rpx),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4.rpx),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage.asset(
              'assets/images/chat/ic_red_packet_msg.png',
              width: 16.rpx,
              height: 16.rpx,
            ),
            Padding(
              padding: FEdgeInsets(left: 4.rpx),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyle.fs14.copyWith(
                  color: AppColor.black3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRevoke() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: FEdgeInsets(horizontal: 8.rpx, vertical: 4.rpx),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4.rpx),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppImage.asset(
                'assets/images/chat/ic_red_packet_msg.png',
                width: 16.rpx,
                height: 16.rpx,
              ),
              Padding(
                padding: FEdgeInsets(left: 4.rpx),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyle.fs14.copyWith(
                      color: AppColor.black3,
                    ),
                    text: S.current.youSentRedEnvelope,
                    children: [
                      TextSpan(
                        text:
                            message.redPacketContent?.amount.toCurrencyString(),
                        style: const TextStyle(color: AppColor.red53),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onPressedRevoke?.call(),
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: FEdgeInsets(horizontal: 12.rpx, vertical: 4.rpx),
            child: Text(
              S.current.withdraw,
              style: AppTextStyle.fs14.copyWith(
                color: AppColor.primaryBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        )
      ],
    );
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
        color: message.isMine ? AppColor.primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: FEdgeInsets(
        horizontal: 12.rpx,
        vertical: 8.rpx,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTitle(content),
          buildContent(content),
        ],
      ),
    );
  }

  Widget buildTitle(MessageRedPacketContent content) {
    String title =
        (SS.login.userId == content.fromUid ? S.current.youSentTaRedEnvelope : S.current.youGetTaRedEnvelope);
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
              style: AppTextStyle.fs14.copyWith(
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
        label: S.current.sentTime,
        value:
            DateTime.fromMillisecondsSinceEpoch(message.info.timestamp).format2,
      ),
      if (receiveTime != null)
        buildItem(
          label: S.current.getTime,
          value: receiveTime.format2,
        ),
      buildItem(
          label: message.isMine ? S.current.amountRedEnvelopes : S.current.fundsReceive,
          value: content.amount.toCurrencyString(),
          isHighlight: true),
    ];

    return Padding(
      padding: FEdgeInsets(top: 12.rpx, bottom: 4.rpx),
      child: DefaultTextStyle(
        style: AppTextStyle.fs12.copyWith(
          color: message.isMine ? Colors.white : AppColor.black666,
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
    //红包状态： 0待领取 1已领取 2已撤回 3已过期
    final status = message.redPacketLocal.status;
    var statusText = '';
    switch (status) {
      case 1:
        statusText = content?.fromUid == SS.login.userId ? S.current.haveBeenReceived : S.current.alreadyReceived;
        break;
      case 2:
        statusText = S.current.withdrawn;
        break;
      case 3:
        statusText = S.current.haveExpired;
        break;
    }

    return Bubble(
      elevation: 0,
      color: status == 0 ? AppColor.orange6 : const Color(0xFFFAD6AF),
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
                    style: AppTextStyle.fs16.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            // 0待领取 1已领取 2已撤回 3已过期
            if (statusText.isNotEmpty)
              Padding(
                padding: FEdgeInsets(top: 8.rpx),
                child: Text(
                  '${S.current.amountOfRedEnvelope}${content?.amount.toCurrencyString()}  $statusText',
                  style: AppTextStyle.fs12.copyWith(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}
