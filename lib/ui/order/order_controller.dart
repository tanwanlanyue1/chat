import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'order_state.dart';

class OrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final OrderState state = OrderState();

  late final TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: state.titleList.length, vsync: this);
    super.onInit();
  }
}
