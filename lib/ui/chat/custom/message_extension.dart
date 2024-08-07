import 'dart:convert';

import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

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

}
