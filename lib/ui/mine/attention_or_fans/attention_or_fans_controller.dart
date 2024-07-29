import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'attention_or_fans_state.dart';

class AttentionOrFansController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AttentionOrFansState state = AttentionOrFansState();

  late TabController tabController;

  void onTapTabIndex(int index) {
    state.tabIndex.value = index;
  }

  @override
  void onInit() {
    tabController = TabController(
      length: state.tabTitles.length,
      vsync: this,
    );
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
