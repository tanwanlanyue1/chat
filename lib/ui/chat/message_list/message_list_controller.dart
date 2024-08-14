import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_state.dart';
import 'widgets/chat_call_end_dialog.dart';
import 'widgets/chat_input_view.dart';

class MessageListController extends GetxController
    with UserAttentionMixin, GetAutoDisposeMixin {
  final MessageListState state;

  final recordProcessor = ZIMKitRecordStatus();
  final scrollController = ScrollController();
  ValueNotifier<ZIMKitConversation>? _conversationNotifier;
  final chatInputViewKey = GlobalKey<ChatInputViewState>();

  @override
  void onInit() {
    super.onInit();
    recordProcessor.register();
    _conversationNotifier =
        ZIMKit().getConversation(state.conversationId, state.conversationType);
    _conversationNotifier?.addListener(_onConversationChanged);
    _onConversationChanged();

    //获取用户关注状态
    getIsAttention(int.parse(state.conversationId));
  }

  void _onConversationChanged() {
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
          isAttentionRx.isTrue ? '取消关注' : '关注',
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(AppRoutes.userCenterPage, arguments: {
                'userId': int.parse(state.conversationId),
              });
              break;
            case 1:
              toggleAttention(int.parse(state.conversationId));
              break;
          }
        },
      ),
    );
  }
}
