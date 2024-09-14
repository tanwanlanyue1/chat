import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/ui/chat/custom/custom_message_type.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ConversationListState {
  final isReadyRx = false.obs;

  var conversationListNotifier =
      ListNotifier<ValueNotifier<ZIMKitConversation>>([]);

  final loadStatusRx = RxStatus.loading().obs;
}

class SysNoticeConversation extends ZIMKitConversation {
  SysNoticeConversation() {
    final message = ZIMCustomMessage(
      subType: CustomMessageType.sysNotice.value,
      message: '尊敬的管佳用户，恭喜您，充值成功。',
    )
      ..direction = ZIMMessageDirection.receive
      ..sentStatus = ZIMMessageSentStatus.success
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    lastMessage = message.toKIT();
    name = '系统通知';
    //排序字段，写大一点，让系统通知一直置顶
    orderKey = DateTime.now().add(const Duration(days: 3650)).millisecondsSinceEpoch;
  }
}
