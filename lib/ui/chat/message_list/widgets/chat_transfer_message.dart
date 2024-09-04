import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/message_transfer_content.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_unknown_message.dart';

///转账消息
class ChatTransferMessage extends StatelessWidget {
  const ChatTransferMessage({
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
    final content = message.transferContent;
    if (content == null) {
      return ChatUnknownMessage(message: message);
    }

    ///当前用户是转账发起方
    final isSender = content.fromUid == SS.login.userId;

    Widget child;
    if(isSender){
      child = message.isMine ? buildDetailsView(content) : buildBubbleView(content);
    }else{
      child = message.isInsertMessage ? buildDetailsView(content) : buildBubbleView(content);
    }

    return Flexible(
      child: GestureDetector(
        onTap: (){
          onPressed?.call(context, message, () {});
        },
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
              () {},
        ),
        child: child,
      ),
    );
  }

  ///气泡视图
  Widget buildBubbleView(MessageTransferContent content) {

    //对方收款消息
    final isReceiveMoney = content.toUid.toString() == message.zim.senderUserID;

    return Bubble(
      elevation: 0,
      color: isReceiveMoney ? const Color(0xFFFAD5AF) : AppColor.orange6,
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
                'assets/images/chat/ic_transfer_msg.png',
                width: 36.rpx,
                height: 36.rpx,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${content.amount.toStringAsTrimZero() ?? ''}',
                    style: AppTextStyle.fs16b.copyWith(color: Colors.white),
                  ),
                  Text(
                    isReceiveMoney ? 'Ta成功收款' : '向您转账',
                    style: AppTextStyle.fs12m.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///详情视图
  Widget buildDetailsView(MessageTransferContent content){
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
    String title = '发起了一笔转账';
    title = (message.isMine ? '您向Ta' : 'Ta向您') + title;
    return Padding(
      padding: FEdgeInsets(top: 6.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage.asset(
            'assets/images/chat/ic_transfer_msg.png',
            width: 24.rpx,
            height: 24.rpx,
            color: message.isMine ? Colors.white : AppColor.orange6,
          ),
          Padding(
            padding: FEdgeInsets(left: 8.rpx),
            child: Text(
              title,
              style: AppTextStyle.fs14m.copyWith(
                color: message.isMine ? Colors.white : AppColor.blackBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(MessageTransferContent content) {
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


    List<Widget> children = [
      buildItem(
        label: '转账时间',
        value: DateTime.fromMillisecondsSinceEpoch(content.time).format2,
      ),
      buildItem(
        label: '到账时间',
        value: DateTime.fromMillisecondsSinceEpoch(content.time).format2,
      ),
      buildItem(label: message.isMine ? '转账实付金额' :  '实收金额', value: content.amount.toCurrencyString(), isHighlight: true),
    ];

    return Padding(
      padding: FEdgeInsets(top: 12.rpx, bottom: 4.rpx),
      child: DefaultTextStyle(
        style: AppTextStyle.fs12m.copyWith(
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
