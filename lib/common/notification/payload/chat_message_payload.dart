
import 'dart:convert';

import 'package:guanjia/common/extension/iterable_extension.dart';

///聊天消息通知Payload
class ChatMessagePayload {

  ///会话ID
  final String conversationId;

  ChatMessagePayload({required this.conversationId});

  static ChatMessagePayload? fromJson(Map<String, dynamic> json){
    final id = json.getStringOrNull('conversationId');
    if(id != null && id.isNotEmpty){
      return ChatMessagePayload(conversationId: id);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
  };

  String toJsonString() => jsonEncode(toJson());
}