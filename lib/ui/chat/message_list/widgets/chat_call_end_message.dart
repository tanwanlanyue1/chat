import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
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
          onPressed?.call(context, message, () {
            ChatCallEndDialog.show(message: message);
          });
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
      message.callEndContent?.inviter == SS.login.userId;

  Widget buildTitle(MessageCallEndContent content) {
    String icon;
    String title;
    if (content.isVideoCall) {
      title = S.current.initiatedVideoChat;
      icon = message.isMine
          ? 'assets/images/chat/ic_video_call_white.png'
          : 'assets/images/chat/ic_video_call_black.png';
    } else {
      title = S.current.initiatedVoiceChat;
      icon = message.isMine
          ? 'assets/images/chat/ic_voice_call_white.png'
          : 'assets/images/chat/ic_voice_call_black.png';
    }
    title = (isSelfInviter ? S.current.you : S.current.ta) + title;

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
            style: AppTextStyle.fs14.copyWith(
              color: message.isMine ? Colors.white : AppColor.blackBlue,
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
                ? PFTextStyle(
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
        label: S.current.callEndTime,
        value: DateTime.fromMillisecondsSinceEpoch(content.endTime).format2,
      ),
      buildItem(label: S.current.callDuration, value: Duration(seconds: content.duration).formatHHmmss),
    ];

    if (isSelfInviter) {
      children.addAll([
        buildItem(
          label: S.current.actualAmountPaid,
          value: content.amount.toCurrencyString(),
          isHighlight: true,
        ),
      ]);
    } else {
      children.addAll([
        buildItem(
          label: S.current.userFee,
          value: content.amount.toCurrencyString(),
        ),
        buildItem(
          label: S.current.platformChargeRatio,
          value: content.platformRate.toPercent(scale: 1),
        ),
        buildItem(
          label: S.current.platformFee,
          value: content.platformFee.toCurrencyString(),
        ),
        if(content.hasAgent) buildItem(
          label: S.current.agentChargeRatio,
          value: (content.agentRate ?? 0).toPercent(scale: 1),
        ),
        if(content.hasAgent) buildItem(
          label: S.current.agentFee,
          value: (content.agentFee ?? 0).toCurrencyString(),
        ),
        buildItem(
          label: S.current.beautyActualAmount,
          value: content.beautyFee.toCurrencyString(),
          isHighlight: true,
        ),
      ]);
    }

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
