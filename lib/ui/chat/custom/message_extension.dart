import 'dart:convert';

import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:guanjia/ui/chat/custom/message_transfer_content.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_call_end_content.dart';
import 'message_order_content.dart';
import 'message_red_packet_content.dart';

extension ZIMKitMessageExt on ZIMKitMessage {
  ///隐藏头像
  static const _kHideAvatar = 'hideAvatar';

  ///消息列表中，业务需要插入的消息
  static const _kInsertMessage = '_kInsertMessage';

  ///是否是业务撤回消息
  static const _kRevokeMessage = '_kRevokeMessage';

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

  T? _getOrParse<T>({
    required CustomMessageType type,
    required T? Function(Map<String, dynamic> json) parse,
  }) {
    if (type != customType) {
      return null;
    }

    final key = '${type.name}_msg_content';
    final data = zimkitExtraInfo[key];
    if (data is T) {
      return data;
    }
    try {
      final msg = customContent?.message ?? '';
      if (msg.isEmpty) {
        return null;
      }
      final json = jsonDecode(msg);
      if (json == null) {
        return null;
      }
      final model = parse(json);
      if (model != null) {
        zimkitExtraInfo[key] = model;
      }
      return model;
    } catch (ex) {
      AppLogger.w('解析${type.name}消息内容发生错误，$ex');
      return null;
    }
  }

  ///红包消息内容
  MessageRedPacketContent? get redPacketContent {
    return _getOrParse(
      type: CustomMessageType.redPacket,
      parse: MessageRedPacketContent.fromJson,
    );
  }

  ///转账消息内容
  MessageTransferContent? get transferContent {
    return _getOrParse(
      type: CustomMessageType.transfer,
      parse: MessageTransferContent.fromJson,
    );
  }

  ///通话结束消息内容
  MessageCallEndContent? get callEndContent {
    return _getOrParse(
      type: CustomMessageType.callEnd,
      parse: MessageCallEndContent.fromJson,
    );
  }


  ///是否隐藏头像
  set isHideAvatar(bool isHide) {
    zimkitExtraInfo[_kHideAvatar] = isHide;
  }

  ///是否隐藏头像
  bool get isHideAvatar => zimkitExtraInfo[_kHideAvatar] == true;

  ///是否业务需要插入的消息
  set isInsertMessage(bool value) {
    zimkitExtraInfo[_kInsertMessage] = value;
  }

  ///是否业务需要插入的消息
  bool get isInsertMessage => zimkitExtraInfo[_kInsertMessage] == true;

  ///是否是业务撤回消息
  set isRevokeMessage(bool value) {
    zimkitExtraInfo[_kRevokeMessage] = value;
  }

  ///是否是业务撤回消息
  bool get isRevokeMessage => zimkitExtraInfo[_kRevokeMessage] == true;


  ///订单消息内容
  MessageOrderContent? get orderContent {
    return _getOrParse(
      type: CustomMessageType.order,
      parse: MessageOrderContent.fromJson,
    );
  }


  ZIMKitMessage copy() {
    return zim.toKIT()
      ..localExtendedData = localExtendedData;
  }
}

extension ZIMCustomMessageExt on ZIMCustomMessage {

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
