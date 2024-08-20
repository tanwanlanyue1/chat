import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/message_call_end_content.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_end_dialog.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'chat_unknown_message.dart';

///通话结束消息
class ChatCallEndMessage extends StatelessWidget {
  const ChatCallEndMessage({
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
    final content = message.callEndContent;
    if (content == null) {
      return ChatUnknownMessage(message: message);
    }

    return Flexible(
      child: GestureDetector(
        onTap: (){
          onPressed?.call(context, message, () {});
          ChatCallEndDialog.show(message: message);
        },
        onLongPressStart: (details) => onLongPress?.call(
          context,
          details,
          message,
          () {},
        ),
        child: Container(
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
              buildTitle(content),
              buildContent(content),
            ],
          ),
        ),
      ),
    );
  }

  ///是否是通话发起方
  bool get isSelfInviter =>
      message.callEndContent?.inviter == SS.login.userId.toString();

  Widget buildTitle(MessageCallEndContent content) {
    String icon;
    String title;
    if (content.isVideoCall) {
      title = '发起了一次视频聊天';
      icon = message.isMine
          ? 'assets/images/chat/ic_video_call_white.png'
          : 'assets/images/chat/ic_video_call_black.png';
    } else {
      title = '发起了一次语音聊天';
      icon = message.isMine
          ? 'assets/images/chat/ic_voice_call_white.png'
          : 'assets/images/chat/ic_voice_call_black.png';
    }
    title = (isSelfInviter ? '您' : 'Ta') + title;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImage.asset(
          icon,
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
    );
  }

  Widget buildContent(MessageCallEndContent content) {
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
        label: '通话结束时间',
        value: content.beginTime.add(content.duration).format2,
      ),
      buildItem(label: '本次通话时长', value: content.duration.formatHHmmss),
    ];

    if (isSelfInviter) {
      children.addAll([
        buildItem(
          label: '本次实付金额',
          value: content.amount.toStringAsTrimZero(),
          isHighlight: true,
        ),
      ]);
    } else {
      children = [
        buildItem(
          label: '用户缴纳费用',
          value: content.amount.toStringAsTrimZero(),
        ),
        buildItem(
          label: '平台收取比例',
          value: content.feeRate.toPercent(),
        ),
        buildItem(
          label: '平台费',
          value: content.fee.toPercent(),
        ),
        buildItem(
          label: '陪聊实收金额',
          value: content.income.toStringAsTrimZero(),
          isHighlight: true,
        ),
      ];
    }

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
