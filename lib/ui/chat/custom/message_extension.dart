import 'dart:convert';

import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_transfer_content.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_call_end_content.dart';
import 'message_red_packet_content.dart';

extension ZIMKitMessageExt on ZIMKitMessage {
  ///自定义消息类型
  CustomMessageType? get customType {
    if (type == ZIMMessageType.custom) {
      final typeVal = customContent?.type;
      if (typeVal != null) {
        return CustomMessageTypeX.valueOf(typeVal);
      }
    }
    return null;
  }

  ///红包消息内容
  MessageRedPacketContent? get redPacketContent {
    try {
      final msg = customContent?.message ?? '';
      if (msg.isEmpty) {
        return null;
      }
      final json = jsonDecode(msg);
      if (json == null) {
        return null;
      }
      return MessageRedPacketContent.fromJson(json);
    } catch (ex) {
      AppLogger.w('解析红包消息内容发生错误，$ex');
    }
    return null;
  }

  ///转账消息内容
  MessageTransferContent? get transferContent {
    try {
      final msg = customContent?.message ?? '';
      if (msg.isEmpty) {
        return null;
      }
      final json = jsonDecode(msg);
      if (json == null) {
        return null;
      }
      return MessageTransferContent.fromJson(json);
    } catch (ex) {
      AppLogger.w('解析转账消息内容发生错误，$ex');
    }
    return null;
  }

  ///通话结束消息内容
  MessageCallEndContent? get callEndContent {
    try {
      final msg = customContent?.message ?? '';
      if (msg.isEmpty) {
        return null;
      }
      final json = jsonDecode(msg);
      if (json == null) {
        return null;
      }
      return MessageCallEndContent.fromJson(json);
    } catch (ex) {
      AppLogger.w('解析通话结束消息内容发生错误，$ex');
    }
    return null;
  }

  ZIMKitMessage copy() {
    final message = ZIMMessage()
      ..type = type
      ..messageID = zim.messageID
      ..localMessageID = zim.localMessageID
      ..senderUserID = zim.senderUserID
      ..conversationID = zim.conversationID
      ..direction = zim.direction
      ..sentStatus = zim.sentStatus
      ..sentStatus = zim.sentStatus
      ..cbInnerID = zim.cbInnerID;

    return message.toKIT();
  }
}

extension ZIMCustomMessageExt on ZIMCustomMessage {

  ///隐藏头像
  static const _hideAvatar = 'hideAvatar';

  ///是否隐藏头像
  set isHideAvatar(bool isHide){
    localExtendedData = _hideAvatar;
  }

  ///是否隐藏头像
  bool get isHideAvatar => localExtendedData == _hideAvatar;

  ZIMCustomMessage copyWith({
    //ZIMMessage字段
    ZIMMessageType? type,
    int? messageID,
    int? localMessageID,
    String? senderUserID,
    String? conversationID,
    ZIMMessageDirection? direction,
    ZIMMessageSentStatus? sentStatus,
    ZIMConversationType? conversationType,
    int? timestamp,
    int? conversationSeq,
    int? orderKey,
    bool? isUserInserted,
    ZIMMessageReceiptStatus? receiptStatus,
    String? extendedData,
    String? localExtendedData,
    bool? isBroadcastMessage,
    bool? isServerMessage,
    bool? isMentionAll,
    List<String>? mentionedUserIds,
    List<ZIMMessageReaction>? reactions,
    String? cbInnerID,
    //ZIMCustomMessage字段
    String? message,
    int? subType,
    String? searchedContent,
  }) {
    return ZIMCustomMessage(
      message: message ?? this.message,
      subType: subType ?? this.subType,
    )
      ..type = type ?? this.type
      ..messageID = messageID ?? this.messageID
      ..localMessageID = localMessageID ?? this.localMessageID
      ..senderUserID = senderUserID ?? this.senderUserID
      ..conversationID = conversationID ?? this.conversationID
      ..direction = direction ?? this.direction
      ..sentStatus = sentStatus ?? this.sentStatus
      ..conversationType = conversationType ?? this.conversationType
      ..timestamp = timestamp ?? this.timestamp
      ..conversationSeq = conversationSeq ?? this.conversationSeq
      ..orderKey = orderKey ?? this.orderKey
      ..isUserInserted = isUserInserted ?? this.isUserInserted
      ..receiptStatus = receiptStatus ?? this.receiptStatus
      ..extendedData = extendedData ?? this.extendedData
      ..localExtendedData = localExtendedData ?? this.localExtendedData
      ..isBroadcastMessage = isBroadcastMessage ?? this.isBroadcastMessage
      ..isServerMessage = isServerMessage ?? this.isServerMessage
      ..isMentionAll = isMentionAll ?? this.isMentionAll
      ..mentionedUserIds = mentionedUserIds ?? this.mentionedUserIds
      ..reactions = reactions ?? this.reactions
      ..cbInnerID = cbInnerID ?? this.cbInnerID
      ..searchedContent = searchedContent ?? this.searchedContent;
  }
}


extension ZIMMessageExt on ZIMMessage {

  ///隐藏头像
  static const _hideAvatar = 'hideAvatar';

  ///是否隐藏头像
  set isHideAvatar(bool isHide){
    localExtendedData = _hideAvatar;
  }

  ///是否隐藏头像
  bool get isHideAvatar => localExtendedData == _hideAvatar;
}