import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_end_message.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_red_packet_message.dart';
import 'package:guanjia/ui/chat/widgets/chat_avatar.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/src/components/components.dart';
import 'package:zego_zimkit/src/components/messages/file_message.dart';
import 'package:zego_zimkit/src/services/services.dart';

import 'chat_call_invite_message.dart';
import 'chat_call_match_message.dart';
import 'chat_call_reject_message.dart';
import 'chat_image_message.dart';
import 'chat_location_message.dart';
import 'chat_order_message.dart';
import 'chat_text_message.dart';
import 'chat_transfer_message.dart';
import 'chat_unknown_message.dart';
import 'chat_video_message.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.message,
    this.onPressed,
    this.onLongPress,
    this.statusBuilder,
    this.avatarBuilder,
    this.timestampBuilder,
    this.messageContentBuilder,
  });

  final ZIMKitMessage message;

  final Widget Function(
          BuildContext context, ZIMKitMessage message, Widget defaultWidget)?
      avatarBuilder;
  final Widget Function(
          BuildContext context, ZIMKitMessage message, Widget defaultWidget)?
      statusBuilder;
  final Widget Function(
          BuildContext context, ZIMKitMessage message, Widget defaultWidget)?
      timestampBuilder;
  final Widget Function(
          BuildContext context, ZIMKitMessage message, Widget defaultWidget)?
      messageContentBuilder;
  final void Function(
          BuildContext context, ZIMKitMessage message, Function defaultAction)?
      onPressed;
  final void Function(BuildContext context, LongPressStartDetails details,
      ZIMKitMessage message, Function defaultAction)? onLongPress;

  Widget buildMessageContent(BuildContext context) {
    late Widget defaultMessageContent;

    switch (message.type) {
      case ZIMMessageType.text:
        defaultMessageContent = ChatTextMessage(
            onLongPress: onLongPress, onPressed: onPressed, message: message);
        break;
      case ZIMMessageType.audio:
        defaultMessageContent = ZIMKitAudioMessage(
            onLongPress: onLongPress, onPressed: onPressed, message: message);
        break;
      case ZIMMessageType.video:
        defaultMessageContent = ChatVideoMessage(
            onLongPress: onLongPress, onPressed: onPressed, message: message);
        break;
      case ZIMMessageType.file:
        defaultMessageContent = ZIMKitFileMessage(
            onLongPress: onLongPress, onPressed: onPressed, message: message);
        break;
      case ZIMMessageType.image:
        defaultMessageContent = ChatImageMessage(
            onLongPress: onLongPress, onPressed: onPressed, message: message);
        break;
      case ZIMMessageType.revoke:
        defaultMessageContent = const Text('Recalled a message.');
        break;
      case ZIMMessageType.custom:
        AppLogger.d('自定义消息：${message.customContent}, ');
        final customType = message.customType;
        switch (customType) {
          case CustomMessageType.redPacket:
            defaultMessageContent = ChatRedPacketMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.callEnd:
            defaultMessageContent = ChatCallEndMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.callReject:
            defaultMessageContent = ChatCallRejectMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.transfer:
            defaultMessageContent = ChatTransferMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.order:
            defaultMessageContent = ChatOrderMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.callMatch:
            defaultMessageContent = ChatCallMatchMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.callInvite:
            defaultMessageContent = ChatCallInviteMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          case CustomMessageType.location:
            defaultMessageContent = ChatLocationMessage(
              onLongPress: onLongPress,
              onPressed: onPressed,
              message: message,
            );
            break;
          default:
            defaultMessageContent = ChatUnknownMessage(
              message: message,
            );
            break;
        }
        break;
      default:
        defaultMessageContent = ChatUnknownMessage(
          message: message,
        );
    }
    return messageContentBuilder?.call(
          context,
          message,
          defaultMessageContent,
        ) ??
        defaultMessageContent;
  }

  Widget buildStatus(BuildContext context) {
    final Widget defaultStatusWidget = ZIMKitMessageStatusDot(message);
    return statusBuilder?.call(
          context,
          message,
          defaultStatusWidget,
        ) ??
        defaultStatusWidget;
  }

  Widget buildAvatar(BuildContext context) {
    final Widget defaultAvatarWidget = ChatAvatar.circle(
      userId: message.info.senderUserID,
      size: 40.rpx,
    );

    return avatarBuilder?.call(
          context,
          message,
          defaultAvatarWidget,
        ) ??
        defaultAvatarWidget;
  }

  Widget localMessage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.info.sentStatus != ZIMMessageSentStatus.success)
              buildStatus(context),
            buildMessageContent(context),
          ],
        ),
        // buildTime(horizontalPadding: 8.rpx)
      ],
    );
  }

  Widget remoteMessage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.rpx),
              child: buildAvatar(context),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildNickName(context),
                  buildMessageContent(context),
                ],
              ),
            ),
          ],
        ),
        // buildTime(horizontalPadding: 56.rpx),
      ],
    );
  }

  Widget buildNickName(context) {
    if (message.isMine ||
        message.info.conversationType != ZIMConversationType.group) {
      return const SizedBox.shrink();
    }

    return FutureBuilder(
      future: ZIMKit().queryGroupMemberInfo(
          message.info.conversationID, message.info.senderUserID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userInfo = snapshot.data! as ZIMGroupMemberInfo;
          return Text(
            userInfo.memberNickname.isNotEmpty
                ? userInfo.memberNickname
                : userInfo.userName,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color
                    ?.withOpacity(0.6)),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: FEdgeInsets(
        horizontal: 16.rpx,
        bottom: 24.rpx,
      ),
      child: FractionallySizedBox(
        widthFactor: message.isMine ? 0.87 : 1.0,
        alignment:
            message.isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: message.isMine ? localMessage(context) : remoteMessage(context),
      ),
    );
  }
}
