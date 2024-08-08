import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_state.dart';

class MessageListController extends GetxController {
  final MessageListState state;

  final recordProcessor = ZIMKitRecordStatus();
  final scrollController = ScrollController();
  ValueNotifier<ZIMKitConversation>? _conversationNotifier;

  @override
  void onInit() {
    super.onInit();
    recordProcessor.register();
    _conversationNotifier = ZIMKit().getConversation(state.conversationId, state.conversationType);
    _conversationNotifier?.addListener(_onConversationChanged);
    _onConversationChanged();
  }

  void _onConversationChanged(){
    state.conversationRx.value = _conversationNotifier?.value;
  }

  @override
  void onClose() {
    super.onClose();
    _conversationNotifier?.removeListener(_onConversationChanged);
    recordProcessor.unregister();
    scrollController.dispose();
  }

  MessageListController({
    required String conversationId,
    required ZIMConversationType conversationType,
  }) : state = MessageListState(
          conversationId: conversationId,
          conversationType: conversationType,
        );


  void showMoreBottomSheet() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [
          '查看个人主页',
          '关注',
        ],
        onTap: (index) {},
      ),
    );
  }
}
