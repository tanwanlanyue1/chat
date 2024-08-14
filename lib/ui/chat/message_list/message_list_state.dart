import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/user_model.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_feature_panel.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../common/network/api/api.dart';

class MessageListState {

  ///会话ID
  final String conversationId;

  ///会话类型
  final ZIMConversationType conversationType;

  ///会话信息
  final conversationRx = Rxn<ZIMKitConversation>();

  ///用户信息
  final userInfoRx = Rxn<UserModel>();

  ///订单信息
  final orderRx = Rxn<OrderItemModel>();

  ///聊天功能面板功能
  final featureActionsRx = <ChatFeatureAction>[
    ...ChatFeatureAction.values.where((element) => element != ChatFeatureAction.date)
  ].obs;

  MessageListState({
    required this.conversationId,
    required this.conversationType,
  });

}
