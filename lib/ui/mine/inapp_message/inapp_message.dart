import 'dart:convert';

import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'inapp_message_type.dart';
import 'models/call_match_content.dart';
import 'models/order_update_content.dart';
import 'models/red_packet_update_content.dart';

///应用内消息
class InAppMessage {
  final InAppMessageType type;
  final Object? data;

  InAppMessage({
    required this.type,
    this.data,
  });

  static InAppMessage? fromJson(Map<String, dynamic> json) {
    final typeVal = json['type'];
    final data = json['data'];
    if (typeVal is! int) {
      AppLogger.w('InAppMessage.fromJson type is! int');
      return null;
    }
    final type = InAppMessageTypeX.valueOf(typeVal);
    if (type == null) {
      AppLogger.w('InAppMessageTypeX.valueOf == null');
      return null;
    }
    return InAppMessage(
      type: type,
      data: _parseContent(type, data),
    );
  }

  ///解析内容
  static dynamic _parseContent(InAppMessageType type, dynamic data){
    try{
      switch (type) {
        case InAppMessageType.callMatch:
        case InAppMessageType.callMatchSuccess:
          return CallMatchContent.fromJson(jsonDecode(data));
        case InAppMessageType.orderUpdate:
          return OrderUpdateContent.fromJson(jsonDecode(data));
        case InAppMessageType.redPacketUpdate:
          return RedPacketUpdateContent.fromJson(jsonDecode(data));
      }
    }catch(ex){
      AppLogger.w('InAppMessage>_parseContent: $ex');
    }
  }

  ///音视频速配内容
  CallMatchContent? get callMatchContent => data?.tryCast<CallMatchContent>();

  ///订单变更内容
  OrderUpdateContent? get orderUpdateContent => data?.tryCast<OrderUpdateContent>();

  ///红包状态变更内容
  RedPacketUpdateContent? get redPacketUpdateContent => data?.tryCast<RedPacketUpdateContent>();

}
