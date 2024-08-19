import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';

import 'enum/order_enum.dart';
import 'order_list/order_list_controller.dart';
import 'order_state.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
