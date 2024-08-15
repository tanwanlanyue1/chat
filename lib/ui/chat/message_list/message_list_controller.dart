import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/chat/message_list/message_order_part.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../common/network/network.dart';
import 'message_list_state.dart';
import 'widgets/chat_feature_panel.dart';
import 'widgets/chat_input_view.dart';

class MessageListController extends GetxController
    with UserAttentionMixin, GetAutoDisposeMixin, OrderOperationMixin {
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

    //监听用户信息，更新底部actions列表
    autoDisposeWorker(everAll([state.userInfoRx, state.orderRx], (_) {
      final userInfo = state.userInfoRx();
      final order = state.orderRx();
      final actions = [...ChatFeatureAction.values];
      //当前登录用户不是普通用户或者对方是普通用户，则不显示发起约会
      if (!SS.login.userType.isUser || userInfo?.type.isUser == true) {
        actions.remove(ChatFeatureAction.date);
      }

      //有进行中的订单，不能发起约会
      if (order != null &&
          ![OrderState.cancel, OrderState.finish].contains(order.state)) {
        actions.remove(ChatFeatureAction.date);
      }

      if (actions.length != state.featureActionsRx.length) {
        state.featureActionsRx.value = actions;
      }
    }));

    _fetchData();
  }

  ///聊天的用户ID
  int get userId => int.parse(state.conversationId);

  void _fetchData() async {
    final responses = await Future.wait([
      //获取用户关注状态
      getIsAttention(userId),
      //用户信息
      UserApi.info(uid: userId),
      //订单信息
      fetchOrder(),
    ]);

    //用户信息
    final userResponse = responses[1] as ApiResponse<UserModel>;
    if (userResponse.isSuccess) {
      state.userInfoRx.value = userResponse.data;
    }
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
                'userId': userId,
              });
              break;
            case 1:
              toggleAttention(userId);
              break;
          }
        },
      ),
    );
  }
}
