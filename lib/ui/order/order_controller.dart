import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/network/api/model/order/order_list_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/ui/mine/inapp_message/inapp_message_type.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';

import 'enum/order_enum.dart';
import 'order_state.dart';

class OrderController extends GetxController
    with
        GetSingleTickerProviderStateMixin,
        GetAutoDisposeMixin,
        OrderOperationMixin {
  final OrderState state = OrderState();

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(
      initialIndex: state.selectIndex.value,
      length: state.titleList.length,
      vsync: this,
    );
    tabController.addListener(() {
      state.selectIndex.value = tabController.index;

      final userType = SS.login.userType;
      final listType = OrderListType.valueForIndex(state.selectIndex.value);
      final isShowDay =
          (listType == OrderListType.cancel && !userType.isUser) ||
              (listType == OrderListType.finish && !userType.isUser);
      state.isShowDay.value = isShowDay;
    });

    autoCancel(SS.inAppMessage.listen((p0) {
      if (p0.type != InAppMessageType.orderUpdate) return;
      final content = p0.orderUpdateContent;
      if (content == null) return;

      switch (content.state) {
        case OrderStatus.waitingAcceptance:
        case OrderStatus.waitingPayment:
        case OrderStatus.going:
          refreshTypeList(OrderListType.going);
          break;
        case OrderStatus.finish:
          refreshTypeList(OrderListType.going);
          refreshTypeList(OrderListType.finish);
          break;
        case OrderStatus.cancel:
        case OrderStatus.timeOut:
          refreshTypeList(OrderListType.going);
          refreshTypeList(OrderListType.cancel);
          break;
      }
    }));
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onChooseDay(int day) {
    state.selectDay.value = day;
  }
}
