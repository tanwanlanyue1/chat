import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ConversationListState {
  final isReadyRx = false.obs;

  var conversationListNotifier =
      ListNotifier<ValueNotifier<ZIMKitConversation>>([]);

  final loadStatusRx = RxStatus.loading().obs;
}
