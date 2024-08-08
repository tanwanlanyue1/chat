import 'package:get/get.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_feature_panel.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class MessageListState {

  ///会话ID
  final String conversationId;

  ///会话类型
  final ZIMConversationType conversationType;

  ///会话信息
  final conversationRx = Rxn<ZIMKitConversation>();

  ///聊天功能面板功能 //TODO 获取用户信息，判断对方是否是佳丽，如果是佳丽才会显示发起约会action
  final featureActions = <ChatFeatureAction>[...ChatFeatureAction.values];

  MessageListState({
    required this.conversationId,
    required this.conversationType,
  });

}
