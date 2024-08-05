import 'package:zego_zimkit/zego_zimkit.dart';

class MessageListState {

  ///会话ID
  final String conversationId;

  ///会话类型
  final ZIMConversationType conversationType;

  MessageListState({
    required this.conversationId,
    required this.conversationType,
  });

}
